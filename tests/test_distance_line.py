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


def test_distance_line_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nDistanceLine { }\n")
    roots = engine.rootObjects()
    assert roots, "default DistanceLine failed to load"
    assert roots[0].property("preview") is False
    assert roots[0].property("selected") is False


def test_distance_line_roundtrip_points() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'DistanceLine { x1: 10; y1: 20; x2: 110; y2: 95; label: "12.3 mm" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("x1") == 10
    assert roots[0].property("y2") == 95
    assert roots[0].property("label") == "12.3 mm"


def test_distance_line_preview_mode_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"DistanceLine { x1: 0; y1: 0; x2: 50; y2: 50; preview: true }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("preview") is True
