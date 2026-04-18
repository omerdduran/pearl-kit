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


def test_chat_message_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nChatMessage { }\n")
    roots = engine.rootObjects()
    assert roots, "default ChatMessage failed to load"
    assert roots[0].property("role") == "ai"


def test_chat_message_both_roles_load() -> None:
    for role in ("user", "ai"):
        qml = (
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'ChatMessage {{ role: "{role}"; author: "{role.upper()}"; text: "hi" }}\n'.encode()
        )
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots, f"role={role} failed to load"
        assert roots[0].property("role") == role


def test_chat_message_with_action() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'ChatMessage { role: "ai"; text: "suggest"; actionLabel: "APPLY" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("actionLabel") == "APPLY"
