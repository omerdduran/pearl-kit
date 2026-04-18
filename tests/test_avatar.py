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


def test_avatar_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nAvatar { }\n")
    roots = engine.rootObjects()
    assert roots, "default Avatar failed to load"
    obj = roots[0]
    assert obj.property("size") == "default"
    assert obj.property("variant") == "default"
    assert obj.property("initials") == ""
    assert obj.property("implicitWidth") == 32
    assert obj.property("implicitHeight") == 32


def test_avatar_all_sizes_have_correct_dimension() -> None:
    for size, d in (("sm", 24), ("default", 32), ("lg", 40)):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n" + f'Avatar {{ size: "{size}" }}\n'.encode(),
        )
        roots = engine.rootObjects()
        assert roots, f"size={size} failed to load"
        assert roots[0].property("implicitWidth") == d
        assert roots[0].property("implicitHeight") == d


def test_avatar_all_variants_load() -> None:
    for v in ("default", "primary", "secondary"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'Avatar {{ variant: "{v}"; initials: "AB" }}\n'.encode(),
        )
        roots = engine.rootObjects()
        assert roots, f"variant={v} failed to load"
        assert roots[0].property("variant") == v


def test_avatar_initials_round_trip() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nAvatar { initials: "OD" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("initials") == "OD"


def test_avatar_source_round_trip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'Avatar { source: "https://example.com/avatar.png" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("source").toString() == "https://example.com/avatar.png"


def test_avatar_icon_source_round_trip() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nAvatar { iconSource: "qrc:/user.svg" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("iconSource").toString() == "qrc:/user.svg"


def test_avatar_disabled_state() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nAvatar { enabled: false; initials: "X" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_avatar_chat_role_pair_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport QtQuick.Layouts\nimport PearlKit 1.0\n"
        b"RowLayout {\n"
        b'    Avatar { variant: "primary"; initials: "AI" }\n'
        b'    Avatar { variant: "secondary"; initials: "OD" }\n'
        b"}\n",
    )
    roots = engine.rootObjects()
    assert roots, "chat role pair failed to load"
