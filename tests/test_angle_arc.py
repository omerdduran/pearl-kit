import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def _load(qml: bytes) -> QQmlApplicationEngine:
    import pearl_kit

    _ = QGuiApplication.instance() or QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(qml)
    return engine


def test_angle_arc_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nAngleArc { }\n")
    roots = engine.rootObjects()
    assert roots, "default AngleArc failed to load"
    assert roots[0].property("preview") is False
    assert roots[0].property("angle") == 0


def test_angle_arc_roundtrip_points() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"AngleArc { x1: 10; y1: 20; xv: 50; yv: 60; x2: 110; y2: 30; "
        b'angle: 47.5; label: "47.5\xc2\xb0" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("xv") == 50
    assert roots[0].property("angle") == 47.5
    assert roots[0].property("label") == "47.5\u00b0"


def test_angle_arc_preview_mode_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"AngleArc { x1: 0; y1: 0; xv: 40; yv: 40; x2: 80; y2: 0; preview: true }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("preview") is True
