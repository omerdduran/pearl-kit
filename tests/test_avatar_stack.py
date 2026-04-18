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


def test_avatar_stack_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nAvatarStack { }\n")
    roots = engine.rootObjects()
    assert roots, "default AvatarStack failed to load"
    assert roots[0].property("avatarSize") == 34
    assert roots[0].property("showAddButton") is True


def test_avatar_stack_with_initials() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"AvatarStack {\n"
        b"  avatars: [\n"
        b'    { "initials": "MK", "background": "#DBEAFE", "foreground": "#1E3A8A" },\n'
        b'    { "initials": "AS", "background": "#FEF3C7", "foreground": "#92400E" },\n'
        b'    { "initials": "EK", "background": "#D1FAE5", "foreground": "#065F46" }\n'
        b"  ]\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots


def test_avatar_stack_no_add_button() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nAvatarStack { showAddButton: false }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("showAddButton") is False
