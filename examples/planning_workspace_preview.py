"""Full planning workspace chrome preview.

Assembles the pieces pearl-kit now ships for DALI's Plan tab:

    ┌───────────────┬────────────────────────────────────┬────────────┐
    │  ToolPalette  │   2x2 viewport grid                │  Params    │
    │  (Nav/Meas/   │   ┌─────────┬─────────┐            │  panel     │
    │   Plan + WL)  │   │ 3D VTK  │ Axial   │            │            │
    │               │   ├─────────┼─────────┤            │            │
    │               │   │ Coronal │ Sagittal│            │            │
    │               │   └─────────┴─────────┘            │            │
    └───────────────┴────────────────────────────────────┴────────────┘

The 2D viewports carry a draggable `Crosshair`, implant markers, and
live synthetic slice frames so pan / zoom / wheel / crosshair drag can
be exercised without a real DICOM volume. The VTK cell renders a small
cube when VTK is importable; it paints a "backend unavailable" note
otherwise.
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
    width: 1400
    height: 900
    visible: true
    color: P.Tokens.background
    title: "pearl-kit planning workspace preview"

    property var axialFrame: null
    property var coronalFrame: null
    property var sagittalFrame: null

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        P.ToolPalette {
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            tools: [
                { key: "navigate", label: "Navigate", hotkey: "V" },
                { key: "measure",  label: "Measure",  hotkey: "M" },
                { key: "plan",     label: "Plan",     hotkey: "P" }
            ]
            currentTool: "plan"
            currentPreset: "bone"
            onToolSelected: (k) => console.log("tool", k)
            onPresetSelected: (k) => console.log("preset", k)
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rows: 2
            columnSpacing: 8
            rowSpacing: 8

            P.VTKViewport {
                objectName: "vtk3d"
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "3D"
                bottomInfo: "cube preview"
            }

            P.ImageViewport {
                Layout.fillWidth: true
                Layout.fillHeight: true
                plane: "axial"; slice: 142; total: 512
                frame: win.axialFrame

                P.Crosshair {
                    plane: "axial"
                    imageX: parent.width / 2
                    imageY: parent.height / 2
                    onMoved: (x, y) => console.log("ax crosshair", x.toFixed(0), y.toFixed(0))
                }
                P.ImplantMarker {
                    x: parent.width * 0.45 - width / 2
                    y: parent.height * 0.4 - height / 2
                    identifier: "I1"; state: "ok"; selected: true
                }
                P.ImplantMarker {
                    x: parent.width * 0.55 - width / 2
                    y: parent.height * 0.5 - height / 2
                    identifier: "I2"; state: "warn"
                }
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

        P.ImplantParameterPanel {
            Layout.preferredWidth: 320
            Layout.fillHeight: true
            diameter: 4.1; length: 10.0; angulation: -2.5
            boneDensityHU: 650
            safetyRows: [
                { label: "Inferior alveolar nerve", value: 2.8, min: 2.0, unit: "mm" },
                { label: "Maxillary sinus",         value: 1.2, min: 1.0, unit: "mm" },
                { label: "Adjacent root",           value: 0.9, min: 1.5, unit: "mm" },
                { label: "Buccal cortex",           value: 1.6, min: 1.0, unit: "mm" }
            ]
            onDiameterMoved: (v) => console.log("diameter", v.toFixed(2))
            onAngulationMoved: (v) => console.log("angulation", v.toFixed(1))
            onLengthSelected: (v) => console.log("length", v)
        }
    }
}
"""


def _build_vtk_cube(viewport_obj: QObject) -> None:
    if not vtk_available():
        return
    native = viewport_obj.property("nativeItem")
    if native is None:
        return
    rw = native.render_window()
    renderer = native.renderer()
    if rw is None or renderer is None:
        return

    from vtkmodules.vtkFiltersSources import vtkCubeSource
    from vtkmodules.vtkRenderingCore import vtkActor, vtkPolyDataMapper

    cube = vtkCubeSource()
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
    engine.loadData(_QML.encode("utf-8"), QUrl.fromLocalFile("planning.qml"))
    roots = engine.rootObjects()
    if not roots:
        return 1
    win = roots[0]

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
