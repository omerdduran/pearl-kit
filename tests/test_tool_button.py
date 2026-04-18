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


def test_tool_button_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nToolButton { }\n")
    roots = engine.rootObjects()
    assert roots, "default ToolButton failed to load"
    assert roots[0].property("implicitWidth") == 32
    assert roots[0].property("implicitHeight") == 32
    assert roots[0].property("checked") is False


def test_tool_button_checked_roundtrip() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nToolButton { checked: true }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("checked") is True


def test_tool_button_metadata_roundtrip() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nToolButton { label: "Pan"; hotkey: "V" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("label") == "Pan"
    assert roots[0].property("hotkey") == "V"
