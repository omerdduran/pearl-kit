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


def test_card_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nCard { }\n")
    roots = engine.rootObjects()
    assert roots, "default Card failed to load"
    obj = roots[0]
    assert obj.property("variant") == "default"
    assert obj.property("accentWidth") == 0
    assert obj.property("padding") == 24
    assert obj.property("spacing") == 24
    assert obj.property("enabled") is True


def test_card_all_variants_load() -> None:
    for v in ("default", "destructive", "warning", "success", "info"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n" + f'Card {{ variant: "{v}" }}\n'.encode(),
        )
        roots = engine.rootObjects()
        assert roots, f"variant={v} failed to load"
        assert roots[0].property("variant") == v


def test_card_accent_width_auto_for_non_default() -> None:
    for v in ("destructive", "warning", "success", "info"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n" + f'Card {{ variant: "{v}" }}\n'.encode(),
        )
        obj = engine.rootObjects()[0]
        assert obj.property("accentWidth") == 4, f"variant={v} accent width mismatch"


def test_card_accent_width_override() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nCard { variant: "destructive"; accentWidth: 8 }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("accentWidth") == 8


def test_card_padding_override() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nCard { padding: 12; spacing: 8 }\n",
    )
    obj = engine.rootObjects()[0]
    assert obj.property("padding") == 12
    assert obj.property("spacing") == 8


def test_card_disabled_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nCard { enabled: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_card_default_content_alias() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'Card { PearlText { text: "a" } PearlText { text: "b" } }\n',
    )
    roots = engine.rootObjects()
    assert roots, "Card with default-slot children failed to load"


def test_card_implicit_size_reflects_padding() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nCard { padding: 16; PearlText { text: "x" } }\n',
    )
    obj = engine.rootObjects()[0]
    assert obj.property("implicitHeight") >= 32
    assert obj.property("implicitWidth") >= 240
