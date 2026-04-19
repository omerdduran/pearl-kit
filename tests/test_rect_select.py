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


def test_rect_select_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nRectSelect { }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("active") is False


def test_rect_select_active_mode_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nRectSelect { active: true }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("active") is True
