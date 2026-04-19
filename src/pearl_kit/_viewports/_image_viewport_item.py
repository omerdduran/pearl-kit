"""QImage-backed QQuickPaintedItem for 2D slice viewports (axial / coronal / sagittal).

Consumers that already own a 2D render surface (e.g. DALI's `ImageViewer`,
a QGraphicsView-based slice viewer with overlays for crosshair, measurement,
arch drawing, implant projection, segmentation) drive this item by pushing
pre-rendered `QImage` frames via `set_frame()`. The item handles display
(pan, zoom, fit-to-view) and emits normalised pointer events back to the
consumer so that existing Python overlay logic keeps working.

Why this shape?
---------------
Fully re-implementing DALI's 2445-line `ImageViewer` in pure QML is neither
realistic nor desirable for v1. The render pipeline already knows how to
draw the slice, segmentation overlay, crosshair, measurement annotations,
implant 2D projections, and so on — we just need those pixels to land in a
QtQuick scene. By accepting a `QImage` (which the consumer can produce via
`QGraphicsScene.render(QPainter(QImage(...)))` or directly via numpy slicing
+ LUT), we preserve full feature parity on day one, and can later migrate
individual overlay layers to native QML as time permits.

Event forwarding
----------------
Pointer events are emitted as signals in **image coordinates** (the
untransformed frame pixel position) so that the consumer can apply the same
row/col math its existing `crosshairClicked(row, col, slice, plane)` signal
expects. The item applies pan + zoom internally for display only.

Consumer API
------------
    item = ImageViewportItem()
    item.plane = "axial"       # informational, used by pearl-kit overlays
    item.set_frame(qimage)     # typically once per slice change
    # ... connect to signals ...
    item.pointerPressed.connect(on_press)   # (x_img, y_img, buttons)
    item.pointerMoved.connect(on_move)
    item.pointerReleased.connect(on_release)
    item.wheelScrolled.connect(on_wheel)    # (delta, modifiers)
    item.zoomChanged.connect(on_zoom)       # (percent)
"""

from __future__ import annotations

import logging
from typing import Any

from PySide6.QtCore import Property, QPointF, Qt, Signal, Slot
from PySide6.QtGui import QColor, QImage, QMouseEvent, QPainter, QTransform, QWheelEvent
from PySide6.QtQuick import QQuickPaintedItem

logger = logging.getLogger(__name__)


class ImageViewportItem(QQuickPaintedItem):
    """QtQuick item that displays a caller-supplied QImage with pan/zoom.

    Keeps interaction generic (emits image-space pointer events) so that the
    existing Python overlay logic in the consumer app can run unchanged.
    """

    #: `(x_img, y_img, buttons)` — pointer in **image** coordinates (not view).
    pointerPressed = Signal(float, float, int)  # noqa: N815
    pointerMoved = Signal(float, float, int)  # noqa: N815
    pointerReleased = Signal(float, float, int)  # noqa: N815
    #: `(delta, modifiers)` — raw wheel delta; consumer decides zoom vs. slice.
    wheelScrolled = Signal(int, int)  # noqa: N815
    #: `(percent)` — emitted whenever pan/zoom state changes.
    zoomChanged = Signal(float)  # noqa: N815

    # --- QML-visible properties -----------------------------------------
    planeChanged = Signal()  # noqa: N815
    fitOnChangeChanged = Signal()  # noqa: N815
    backgroundColorChanged = Signal()  # noqa: N815
    frameChanged = Signal()  # noqa: N815

    def __init__(self, parent: Any = None) -> None:
        super().__init__(parent)
        self.setAcceptedMouseButtons(
            Qt.MouseButton.LeftButton | Qt.MouseButton.RightButton | Qt.MouseButton.MiddleButton
        )
        self.setAcceptHoverEvents(True)
        self.setFlag(QQuickPaintedItem.Flag.ItemHasContents, True)

        self._frame: QImage | None = None
        self._plane: str = "axial"
        self._fit_on_change: bool = True
        self._bg_color: QColor = QColor("#000000")

        # Pan/zoom state
        self._zoom: float = 1.0  # 1.0 = fit
        self._pan: QPointF = QPointF(0.0, 0.0)
        self._dragging: bool = False
        self._drag_start: QPointF = QPointF()
        self._pan_at_drag_start: QPointF = QPointF()

    # ------------------------------------------------------------------
    # Properties (exposed to QML)
    # ------------------------------------------------------------------
    def _get_plane(self) -> str:
        return self._plane

    def _set_plane(self, value: str) -> None:
        if self._plane == value:
            return
        self._plane = value
        self.planeChanged.emit()

    plane = Property(str, _get_plane, _set_plane, notify=planeChanged)

    def _get_fit_on_change(self) -> bool:
        return self._fit_on_change

    def _set_fit_on_change(self, value: bool) -> None:
        if self._fit_on_change == value:
            return
        self._fit_on_change = value
        self.fitOnChangeChanged.emit()

    fitOnChange = Property(bool, _get_fit_on_change, _set_fit_on_change, notify=fitOnChangeChanged)  # noqa: N815

    def _get_bg_color(self) -> QColor:
        return self._bg_color

    def _set_bg_color(self, color: QColor) -> None:
        c = QColor(color)
        if self._bg_color == c:
            return
        self._bg_color = c
        self.backgroundColorChanged.emit()
        self.update()

    backgroundColor = Property(  # noqa: N815
        QColor, _get_bg_color, _set_bg_color, notify=backgroundColorChanged
    )

    def _get_frame(self) -> QImage | None:
        return self._frame

    def _set_frame_property(self, image: QImage | None) -> None:
        self.set_frame(image)

    #: QML-bindable alias for :meth:`set_frame`. Enables declarative
    #: ``frame: myQImage`` bindings without the QML wrapper needing an
    #: explicit ``onFrameChanged`` handler.
    frame = Property("QImage", _get_frame, _set_frame_property, notify=frameChanged)

    # ------------------------------------------------------------------
    # Public API — consumer drives the frame
    # ------------------------------------------------------------------
    @Slot("QImage")
    def set_frame(self, image: QImage | None) -> None:
        """Set the displayed frame. Pass None to clear.

        Exposed as a Qt slot so QML bindings can call it directly
        (e.g. ``onFrameChanged: _img.set_frame(control.frame)`` inside
        the ``ImageViewport`` QML wrapper).
        """
        logger.info(
            "ImageViewportItem[%s] set_frame: image=%s size=%dx%d self_size=%.0fx%.0f",
            self._plane,
            type(image).__name__ if image is not None else "None",
            image.width() if image is not None else -1,
            image.height() if image is not None else -1,
            self.width(),
            self.height(),
        )
        self._frame = image.copy() if image is not None else None
        if self._fit_on_change:
            self._zoom = 1.0
            self._pan = QPointF(0.0, 0.0)
            self.zoomChanged.emit(self._effective_zoom_percent())
        self.frameChanged.emit()
        self.update()

    def current_frame(self) -> QImage | None:
        return self._frame

    def reset_view(self) -> None:
        self._zoom = 1.0
        self._pan = QPointF(0.0, 0.0)
        self.zoomChanged.emit(self._effective_zoom_percent())
        self.update()

    def set_zoom(self, factor: float) -> None:
        factor = max(0.05, min(50.0, float(factor)))
        if abs(self._zoom - factor) < 1e-6:
            return
        self._zoom = factor
        self.zoomChanged.emit(self._effective_zoom_percent())
        self.update()

    # ------------------------------------------------------------------
    # Painting
    # ------------------------------------------------------------------
    def paint(self, painter: QPainter) -> None:
        rect = self.boundingRect()
        painter.fillRect(rect, self._bg_color)

        if self._frame is None or self._frame.isNull():
            logger.debug(
                "ImageViewportItem[%s].paint: no frame (bounding=%.0fx%.0f)",
                self._plane, rect.width(), rect.height(),
            )
            return

        logger.info(
            "ImageViewportItem[%s].paint: rect=%.0fx%.0f frame=%dx%d",
            self._plane, rect.width(), rect.height(),
            self._frame.width(), self._frame.height(),
        )
        painter.setRenderHint(QPainter.RenderHint.SmoothPixmapTransform, True)
        transform = self._compute_transform()
        painter.setTransform(transform)
        painter.drawImage(0, 0, self._frame)

    def _compute_transform(self) -> QTransform:
        """Map image-space (0..img_w, 0..img_h) → view-space (0..item_w, 0..item_h).

        Scale to fit longest axis, centre, then apply pan + zoom on top.
        """
        t = QTransform()
        if self._frame is None or self._frame.isNull():
            return t
        item_w = max(1.0, self.width())
        item_h = max(1.0, self.height())
        img_w = float(self._frame.width())
        img_h = float(self._frame.height())
        fit = min(item_w / img_w, item_h / img_h)
        scale = fit * self._zoom
        # Centre of item in view space
        cx = item_w / 2.0 + self._pan.x()
        cy = item_h / 2.0 + self._pan.y()
        t.translate(cx, cy)
        t.scale(scale, scale)
        t.translate(-img_w / 2.0, -img_h / 2.0)
        return t

    def _view_to_image(self, pt: QPointF) -> QPointF:
        """Inverse transform: view-space QPointF → image-space QPointF."""
        t = self._compute_transform()
        inv, ok = t.inverted()
        if not ok:
            return QPointF(-1.0, -1.0)
        return inv.map(pt)

    def _effective_zoom_percent(self) -> float:
        return self._zoom * 100.0

    # ------------------------------------------------------------------
    # Event forwarding
    # ------------------------------------------------------------------
    @staticmethod
    def _flags_to_int(flags: Any) -> int:
        """Cast a Qt flags/enum value to int across PySide6 versions.

        PySide6 6.11+ no longer supports ``int(QFlags)`` directly; the
        correct access path is ``flags.value``. Older releases kept the
        implicit cast working. This helper tolerates both.
        """
        try:
            return int(flags.value)
        except AttributeError:
            try:
                return int(flags)
            except (TypeError, ValueError):
                return 0

    def mousePressEvent(self, event: QMouseEvent) -> None:  # noqa: N802 — Qt override
        pos = event.position() if hasattr(event, "position") else QPointF(event.pos())
        # Middle button → pan the view (local to the item).
        if event.button() == Qt.MouseButton.MiddleButton:
            self._dragging = True
            self._drag_start = QPointF(pos)
            self._pan_at_drag_start = QPointF(self._pan)
            return
        img_pt = self._view_to_image(pos)
        self.pointerPressed.emit(img_pt.x(), img_pt.y(), self._flags_to_int(event.buttons()))

    def mouseMoveEvent(self, event: QMouseEvent) -> None:  # noqa: N802 — Qt override
        pos = event.position() if hasattr(event, "position") else QPointF(event.pos())
        if self._dragging:
            delta = pos - self._drag_start
            self._pan = self._pan_at_drag_start + delta
            self.update()
            return
        img_pt = self._view_to_image(pos)
        self.pointerMoved.emit(img_pt.x(), img_pt.y(), self._flags_to_int(event.buttons()))

    def mouseReleaseEvent(self, event: QMouseEvent) -> None:  # noqa: N802 — Qt override
        pos = event.position() if hasattr(event, "position") else QPointF(event.pos())
        if self._dragging and event.button() == Qt.MouseButton.MiddleButton:
            self._dragging = False
            return
        img_pt = self._view_to_image(pos)
        self.pointerReleased.emit(img_pt.x(), img_pt.y(), self._flags_to_int(event.buttons()))

    def hoverMoveEvent(self, event: Any) -> None:  # noqa: N802 — Qt override
        pos = event.position() if hasattr(event, "position") else QPointF(event.pos())
        img_pt = self._view_to_image(pos)
        self.pointerMoved.emit(img_pt.x(), img_pt.y(), 0)

    def wheelEvent(self, event: QWheelEvent) -> None:  # noqa: N802 — Qt override
        delta = event.angleDelta().y()
        mods = self._flags_to_int(event.modifiers())
        # Ctrl+wheel zooms locally; bare wheel is slice-scroll (caller's job).
        if event.modifiers() & Qt.KeyboardModifier.ControlModifier:
            factor = 1.15 if delta > 0 else (1.0 / 1.15)
            self.set_zoom(self._zoom * factor)
            return
        self.wheelScrolled.emit(delta, mods)
