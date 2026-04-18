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


def test_color_dot_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nColorDot { }\n")
    roots = engine.rootObjects()
    assert roots, "default ColorDot failed to load"
    assert roots[0].property("implicitWidth") == 22
    assert roots[0].property("implicitHeight") == 22


def test_color_dot_custom_size() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nColorDot { size: 32 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("size") == 32
