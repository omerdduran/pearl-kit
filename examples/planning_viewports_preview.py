"""Preview of pearl-kit's planning viewport primitives (VTK + Image).

Runs a 2x2 grid that mirrors the DALI Plan tab layout:

    ┌──────────────────────┬──────────────────────┐
    │ VTKViewport (3D)     │ ImageViewport (AX)   │
    ├──────────────────────┼──────────────────────┤
    │ ImageViewport (CO)   │ ImageViewport (SA)   │
    └──────────────────────┴──────────────────────┘

The VTK viewport builds a tiny cube pipeline when VTK is importable so the
surface isn't blank. The 2D image viewports display a synthetic gradient so
pan / zoom / wheel interactions can be exercised.
"""

from __future__ import annotations

import math
import sys
from pathlib import Path

from PySide6.QtCore import QObject, QSize, QTimer, QUrl
from PySide6.QtGui import QColor, QFontDatabase, QGuiApplication, QImage, QPainter
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit
from pearl_kit._viewports import vtk_available

_EXAMPLES_DIR = Path(__file__).resolve().parent
_FONTS_DIR = _EXAMPLES_DIR / "fonts"
_FONT_FILES = (
    "DMSerifDisplay-Regular.ttf",
    "PlusJakartaSans-Regular.ttf",
    "PlusJakartaSans-Bold.ttf",
    "PlusJakartaSans-Light.ttf",
    "JetBrainsMono-Regular.ttf",
)


def _load_fonts() -> None:
    for name in _FONT_FILES:
        path = _FONTS_DIR / name
        if path.exists():
            QFontDatabase.addApplicationFont(str(path))


def _synthetic_slice(w: int, h: int, phase: float, tint: QColor) -> QImage:
    """Synthesize a dentition-shaped radial gradient image for preview."""
    img = QImage(QSize(w, h), QImage.Format.Format_ARGB32)
    img.fill(QColor(0, 0, 0))
    p = QPainter(img)
    p.setRenderHint(QPainter.RenderHint.Antialiasing, True)
    p.fillRect(0, 0, w, h, QColor("#121A2B"))
    cx, cy = w / 2, h / 2
    rx, ry = w * 0.34, h * 0.3
    for i in range(40, 0, -1):
        a = int(255 * (1.0 - (i / 40)) * 0.05)
        c = QColor(tint)
        c.setAlpha(a)
        p.setBrush(c)
        p.setPen(QColor(0, 0, 0, 0))
        s = i / 40.0
        p.drawEllipse(int(cx - rx * s), int(cy - ry * s), int(2 * rx * s), int(2 * ry * s))
    sx = cx + math.cos(phase) * w * 0.18
    sy = cy + math.sin(phase) * h * 0.12
    p.setBrush(QColor("#EFF6FF"))
    p.setPen(QColor(0, 0, 0, 0))
    p.drawEllipse(int(sx - 4), int(sy - 20), 7, 40)
    p.end()
    return img


_QML = """
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import PearlKit 1.0 as P

ApplicationWindow {
    id: win
    width: 1200
    height: 760
    visible: true
    color: P.Tokens.background
    title: "pearl-kit planning viewports preview"

    property var axialFrame: null
    property var coronalFrame: null
    property var sagittalFrame: null
    property bool vtkReady: false

    GridLayout {
        anchors.fill: parent
        anchors.margins: 12
        columns: 2
        rows: 2
        columnSpacing: 10
        rowSpacing: 10

        P.VTKViewport {
            objectName: "vtk3d"
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: win.vtkReady ? "3D" : "3D · no VTK"
            bottomInfo: win.vtkReady ? "cube preview" : ""
        }

        P.ImageViewport {
            Layout.fillWidth: true
            Layout.fillHeight: true
            plane: "axial"; slice: 142; total: 512
            frame: win.axialFrame
        }

        P.ImageViewport {
            Layout.fillWidth: true
            Layout.fillHeight: true
            plane: "coronal"; slice: 220; total: 480
            frame: win.coronalFrame
        }

        P.ImageViewport {
            Layout.fillWidth: true
            Layout.fillHeight: true
            plane: "sagittal"; slice: 190; total: 420
            frame: win.sagittalFrame
        }
    }
}
"""


def _build_vtk_cube(viewport_obj: QObject) -> None:
    """If VTK is available, push a rotating-cube pipeline into the viewport."""
    if not vtk_available():
        return
    native = viewport_obj.property("nativeItem")
    if native is None:
        return
    rw = native.render_window()
    renderer = native.renderer()
    if rw is None or renderer is None:
        return

    from vtkmodules.vtkFiltersSources import vtkCubeSource  # type: ignore
    from vtkmodules.vtkRenderingCore import (  # type: ignore
        vtkActor,
        vtkPolyDataMapper,
    )

    cube = vtkCubeSource()
    cube.SetXLength(1.0)
    cube.SetYLength(1.0)
    cube.SetZLength(1.0)

    mapper = vtkPolyDataMapper()
    mapper.SetInputConnection(cube.GetOutputPort())

    actor = vtkActor()
    actor.SetMapper(mapper)
    actor.GetProperty().SetColor(0.61, 0.78, 0.96)

    renderer.AddActor(actor)
    renderer.ResetCamera()
    native.allow_rendering()
    native.render_now()


def main() -> int:
    app = QGuiApplication(sys.argv)
    _load_fonts()

    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(_QML.encode("utf-8"), QUrl.fromLocalFile("preview.qml"))
    roots = engine.rootObjects()
    if not roots:
        return 1
    win = roots[0]
    win.setProperty("vtkReady", vtk_available())

    vtk3d = win.findChild(QObject, "vtk3d")
    if vtk3d is not None:
        try:
            _build_vtk_cube(vtk3d)
        except Exception as e:
            print(f"VTK pipeline build skipped: {e}")

    phase = [0.0]

    def tick() -> None:
        phase[0] += 0.04
        win.setProperty("axialFrame", _synthetic_slice(512, 512, phase[0], QColor("#DBEAFE")))
        win.setProperty(
            "coronalFrame", _synthetic_slice(512, 512, phase[0] + 1.0, QColor("#FECACA"))
        )
        win.setProperty(
            "sagittalFrame", _synthetic_slice(512, 512, phase[0] + 2.0, QColor("#BBF7D0"))
        )

    timer = QTimer(app)
    timer.timeout.connect(tick)
    timer.start(40)
    tick()

    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
