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


def test_arrow_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nArrow { }\n")
    roots = engine.rootObjects()
    assert roots, "default Arrow failed to load"
    assert roots[0].property("preview") is False


def test_arrow_roundtrip_points() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Arrow { x1: 5; y1: 10; x2: 100; y2: 45; headSize: 14 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("x2") == 100
    assert roots[0].property("headSize") == 14
