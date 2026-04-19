"""VTK-backed QQuickPaintedItem for embedding a VTK render window in QML.

This item lets callers drop a full VTK render pipeline into a QtQuick scene.
The native item owns an offscreen `vtkGenericOpenGLRenderWindow` (when VTK is
available) and paints each completed frame onto the QtQuick scene graph via
`QQuickPaintedItem.paint`. Mouse / wheel events are forwarded to VTK's
`vtkGenericRenderWindowInteractor` so that existing VTK callbacks (camera
manipulation, picking, clipping) keep working unchanged.

Design notes
------------
- VTK is an **optional** runtime dependency of pearl-kit. `vtk_available()`
  reports whether the backend is usable; if not, the item paints a
  placeholder and `renderer()` returns ``None``.
- The `gated` flag mirrors DALI's `_GatedVTKWidget` pattern
  (`ui/volume_render_viewer.py:51-75`): paint is a no-op until the consumer
  has finished wiring up the pipeline and calls `allow_rendering()`.
  Without this, VTK's first render call blocks the main thread for seconds
  while GPU-side mappers initialise.
- The first real render happens off the paint path (via `render_now`), so
  consumers can warm up the pipeline before the first frame is shown.

Consumer API (typical usage from DALI)
--------------------------------------
    item = VTKViewportItem()           # QQuickItem — place inside a QML scene
    rw = item.render_window()          # vtkRenderWindow | None
    renderer = item.renderer()         # vtkRenderer | None
    # ... configure pipeline (volume mapper, actors, camera) ...
    item.allow_rendering()
    item.render_now()

The heavy lifting (volume mapper choice, preset selection, LOD, clipping,
lighting) stays in the caller — this item only provides the QtQuick
integration surface. Keeping the render pipeline in the caller means the
existing DALI `VolumeRenderViewer` logic can be reused unchanged when the
item is wrapped by DALI's `PlanningBridge`.
"""

from __future__ import annotations

import logging
from typing import Any

from PySide6.QtCore import QPointF, Qt, Signal
from PySide6.QtGui import QColor, QImage, QMouseEvent, QPainter, QWheelEvent
from PySide6.QtQuick import QQuickPaintedItem

logger = logging.getLogger(__name__)

# Detect VTK availability once at module import. The actual VTK symbols are
# imported lazily inside methods so test environments without VTK can still
# import pearl_kit. Symbol locations vary across VTK versions:
#   - VTK 9.2-:  vtkRenderingCore.vtkGenericOpenGLRenderWindow
#   - VTK 9.3+:  vtkRenderingOpenGL2.vtkGenericOpenGLRenderWindow
# so we probe both.
try:
    from vtkmodules.vtkRenderingCore import vtkRenderer  # type: ignore[import-not-found]
    from vtkmodules.vtkRenderingUI import (
        vtkGenericRenderWindowInteractor,  # type: ignore[import-not-found]
    )

    try:
        from vtkmodules.vtkRenderingOpenGL2 import (
            vtkGenericOpenGLRenderWindow,  # type: ignore[import-not-found]
        )
    except ImportError:
        from vtkmodules.vtkRenderingCore import (  # type: ignore[import-not-found]
            vtkGenericOpenGLRenderWindow,
        )

    _VTK_AVAILABLE = True
except Exception as e:
    logger.debug("VTK not available for VTKViewportItem (%s)", e)
    _VTK_AVAILABLE = False


def vtk_available() -> bool:
    """Return True when VTK's OpenGL2 backend imported successfully."""
    return _VTK_AVAILABLE


class VTKViewportItem(QQuickPaintedItem):
    """QQuickItem host for a VTK render window.

    Paints the offscreen VTK render to the QtQuick scene graph each frame.
    Forwards pointer + wheel events to VTK's generic interactor so that
    existing VTK callbacks keep working.
    """

    #: Emitted after the first successful render completes. Useful for
    #: consumers that want to tear down a splash / loading overlay.
    firstRenderCompleted = Signal()  # noqa: N815 — QML signal name

    #: Emitted on every completed render with the elapsed render time in ms.
    #: Consumers can drive LOD / quality heuristics off this.
    renderFinished = Signal(float)  # noqa: N815 — QML signal name

    def __init__(self, parent: Any = None) -> None:
        super().__init__(parent)
        self.setAcceptedMouseButtons(
            Qt.MouseButton.LeftButton | Qt.MouseButton.RightButton | Qt.MouseButton.MiddleButton
        )
        self.setAcceptHoverEvents(True)
        # Force the item to repaint when size or content changes.
        self.setFlag(QQuickPaintedItem.Flag.ItemHasContents, True)

        self._gated: bool = True  # mirrors DALI _GatedVTKWidget
        self._first_render_done: bool = False
        self._bg_color: QColor = QColor("#0B1120")  # match pearl-kit viewport bg
        self._render_window: Any | None = None
        self._renderer: Any | None = None
        self._interactor: Any | None = None
        self._last_frame: QImage | None = None

        if _VTK_AVAILABLE:
            self._init_vtk()

    # ------------------------------------------------------------------
    # VTK lifecycle
    # ------------------------------------------------------------------
    def _init_vtk(self) -> None:
        """Create the offscreen render window + default renderer + interactor."""
        rw = vtkGenericOpenGLRenderWindow()
        rw.SetMultiSamples(0)
        rw.SetSize(max(1, int(self.width())), max(1, int(self.height())))

        renderer = vtkRenderer()
        renderer.SetBackground(
            self._bg_color.redF(), self._bg_color.greenF(), self._bg_color.blueF()
        )
        rw.AddRenderer(renderer)

        interactor = vtkGenericRenderWindowInteractor()
        interactor.SetRenderWindow(rw)

        self._render_window = rw
        self._renderer = renderer
        self._interactor = interactor

    # ------------------------------------------------------------------
    # Public accessors — caller builds the pipeline against these
    # ------------------------------------------------------------------
    def render_window(self) -> Any | None:
        """Return the underlying `vtkRenderWindow` (or None if VTK absent)."""
        return self._render_window

    def renderer(self) -> Any | None:
        """Return the default `vtkRenderer` (or None if VTK absent)."""
        return self._renderer

    def interactor(self) -> Any | None:
        """Return the generic interactor forwarding Qt events to VTK."""
        return self._interactor

    def set_background_color(self, color: QColor) -> None:
        self._bg_color = QColor(color)
        if self._renderer is not None:
            self._renderer.SetBackground(
                self._bg_color.redF(), self._bg_color.greenF(), self._bg_color.blueF()
            )
            self.update()

    # ------------------------------------------------------------------
    # Gating (mirrors DALI _GatedVTKWidget)
    # ------------------------------------------------------------------
    def allow_rendering(self) -> None:
        """Open the gate. Subsequent `paint()` calls will trigger VTK render."""
        self._gated = False
        self.update()

    def block_rendering(self) -> None:
        """Close the gate. `paint()` becomes a no-op until reopened."""
        self._gated = True

    def render_now(self) -> None:
        """Force a render tick off the paint path (useful for warm-up)."""
        if not _VTK_AVAILABLE or self._render_window is None:
            return
        if self._gated:
            return
        try:
            self._render_window.Render()
        except Exception:
            logger.exception("VTKViewportItem render_now failed")
            return
        self.update()

    # ------------------------------------------------------------------
    # QQuickPaintedItem hooks
    # ------------------------------------------------------------------
    def paint(self, painter: QPainter) -> None:
        rect = self.boundingRect().toRect()
        # Always fill background so placeholder state looks intentional.
        painter.fillRect(rect, self._bg_color)

        if not _VTK_AVAILABLE or self._render_window is None:
            # VTK missing → draw a subtle "VTK unavailable" placeholder. This
            # path should never be hit inside DALI (VTK is required there),
            # but pearl-kit consumers without VTK get a graceful fallback.
            painter.setPen(QColor("#64748B"))
            painter.drawText(rect, int(Qt.AlignmentFlag.AlignCenter), "VTK backend unavailable")
            return

        if self._gated:
            # Gate closed — background only. Mirrors _GatedVTKWidget.paintEvent.
            return

        # Render VTK to an offscreen framebuffer, blit to Qt.
        try:
            self._render_window.Render()
            # Read back the rendered pixels as a QImage. This path is O(W*H)
            # and is acceptable for typical CBCT viewports (≤ 1024²). When
            # QQuickVTKRenderItem PySide bindings ship we'll switch to the
            # zero-copy scene-graph path.
            size = self._render_window.GetSize()
            if size[0] <= 0 or size[1] <= 0:
                return
            buf = self._render_window.GetRGBACharPixelData(
                0,
                0,
                size[0] - 1,
                size[1] - 1,
                1,  # 1 = front buffer
            )
            # vtkUnsignedCharArray → raw bytes
            raw = bytes(buf)
            img = QImage(raw, size[0], size[1], QImage.Format.Format_RGBA8888)
            # VTK origin is bottom-left, Qt is top-left.
            img = img.mirrored(False, True).copy()
            self._last_frame = img
            painter.drawImage(rect, img)
            if not self._first_render_done:
                self._first_render_done = True
                self.firstRenderCompleted.emit()
        except Exception:
            logger.exception("VTKViewportItem paint failed")

    def geometryChange(self, new_geom: Any, old_geom: Any) -> None:  # noqa: N802 — Qt override
        super().geometryChange(new_geom, old_geom)
        if self._render_window is not None:
            w = max(1, int(self.width()))
            h = max(1, int(self.height()))
            self._render_window.SetSize(w, h)
            if self._interactor is not None:
                self._interactor.SetSize(w, h)
            self.update()

    # ------------------------------------------------------------------
    # Event forwarding to VTK interactor — preserves existing VTK bindings
    # ------------------------------------------------------------------
    # Position + modifier state goes through `SetEventPosition` +
    # `SetControlKey` / `SetShiftKey` / `SetAltKey`. VTK 9.5+ changed the
    # 5th argument of `SetEventInformationFlipY` to a char (keycode); passing
    # `int 0` raises TypeError, so we drop that path entirely. Every forward
    # is wrapped in try/except so one flaky VTK accessor does not spam the
    # whole planning session.

    def _set_interactor_state(self, pos_x: int, pos_y_qt: int, modifiers: Any) -> None:
        """Write flipped position + modifier state onto the interactor."""
        import contextlib

        if self._interactor is None:
            return
        try:
            y_vtk = int(self.height() - pos_y_qt)
            self._interactor.SetEventPosition(int(pos_x), y_vtk)
            ctrl = bool(modifiers & Qt.KeyboardModifier.ControlModifier)
            shift = bool(modifiers & Qt.KeyboardModifier.ShiftModifier)
            alt = bool(modifiers & Qt.KeyboardModifier.AltModifier)
            self._interactor.SetControlKey(1 if ctrl else 0)
            self._interactor.SetShiftKey(1 if shift else 0)
            with contextlib.suppress(AttributeError):
                self._interactor.SetAltKey(1 if alt else 0)
        except Exception:
            logger.debug("VTKViewportItem: interactor state set failed", exc_info=True)

    def _forward_mouse(self, event: QMouseEvent, kind: str) -> None:
        if self._interactor is None:
            return
        pos = event.position() if hasattr(event, "position") else QPointF(event.pos())
        self._set_interactor_state(int(pos.x()), int(pos.y()), event.modifiers())
        try:
            buttons = event.buttons()
            if kind == "press":
                if buttons & Qt.MouseButton.LeftButton:
                    self._interactor.LeftButtonPressEvent()
                elif buttons & Qt.MouseButton.RightButton:
                    self._interactor.RightButtonPressEvent()
                elif buttons & Qt.MouseButton.MiddleButton:
                    self._interactor.MiddleButtonPressEvent()
            elif kind == "release":
                btn = event.button()
                if btn == Qt.MouseButton.LeftButton:
                    self._interactor.LeftButtonReleaseEvent()
                elif btn == Qt.MouseButton.RightButton:
                    self._interactor.RightButtonReleaseEvent()
                elif btn == Qt.MouseButton.MiddleButton:
                    self._interactor.MiddleButtonReleaseEvent()
            elif kind == "move":
                self._interactor.MouseMoveEvent()
        except Exception:
            logger.debug("VTKViewportItem: mouse forward failed", exc_info=True)
        self.update()

    def mousePressEvent(self, event: QMouseEvent) -> None:  # noqa: N802 — Qt override
        self._forward_mouse(event, "press")

    def mouseReleaseEvent(self, event: QMouseEvent) -> None:  # noqa: N802 — Qt override
        self._forward_mouse(event, "release")

    def mouseMoveEvent(self, event: QMouseEvent) -> None:  # noqa: N802 — Qt override
        self._forward_mouse(event, "move")

    def hoverMoveEvent(self, event: Any) -> None:  # noqa: N802 — Qt override
        if self._interactor is None:
            return
        pos = event.position() if hasattr(event, "position") else QPointF(event.pos())
        self._set_interactor_state(int(pos.x()), int(pos.y()), Qt.KeyboardModifier.NoModifier)
        try:
            self._interactor.MouseMoveEvent()
        except Exception:
            logger.debug("VTKViewportItem: hover forward failed", exc_info=True)
        self.update()

    def wheelEvent(self, event: QWheelEvent) -> None:  # noqa: N802 — Qt override
        if self._interactor is None:
            return
        try:
            delta = event.angleDelta().y()
            if delta > 0:
                self._interactor.MouseWheelForwardEvent()
            elif delta < 0:
                self._interactor.MouseWheelBackwardEvent()
        except Exception:
            logger.debug("VTKViewportItem: wheel forward failed", exc_info=True)
        self.update()
