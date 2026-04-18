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


def test_chat_composer_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nChatComposer { }\n")
    roots = engine.rootObjects()
    assert roots, "default ChatComposer failed to load"
    assert roots[0].property("submitLabel") == "ASK"


def test_chat_composer_text_roundtrip() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nChatComposer { text: "what is the bone density" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "what is the bone density"


def test_chat_composer_custom_submit_label() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nChatComposer { submitLabel: "SEND" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("submitLabel") == "SEND"
