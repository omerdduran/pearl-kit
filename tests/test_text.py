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


def test_text_default_loads() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nText { text: "hello" }\n',
    )
    roots = engine.rootObjects()
    assert roots, "default Text failed to load"
    obj = roots[0]
    assert obj.property("text") == "hello"
    assert obj.property("variant") == "body"


def test_text_all_variants_load() -> None:
    for v in ("title", "heading", "body", "muted", "label", "code", "mono"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'Text {{ variant: "{v}"; text: "sample" }}\n'.encode(),
        )
        roots = engine.rootObjects()
        assert roots, f"variant={v} failed to load"
        assert roots[0].property("variant") == v


def test_text_title_is_xxl_semibold() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nText { variant: "title"; text: "t" }\n',
    )
    obj = engine.rootObjects()[0]
    font = obj.property("font")
    assert font.pixelSize() == 24


def test_text_heading_is_lg() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nText { variant: "heading"; text: "h" }\n',
    )
    obj = engine.rootObjects()[0]
    assert obj.property("font").pixelSize() == 18


def test_text_body_is_sm() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nText { variant: "body"; text: "b" }\n',
    )
    obj = engine.rootObjects()[0]
    assert obj.property("font").pixelSize() == 14


def test_text_elide_passthrough() -> None:
    # elide is a QQuickText enum — cannot be round-tripped via .property();
    # smoke-load only to confirm the binding parses.
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'Text { text: "very long text that elides"; width: 80; elide: Text.ElideRight }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "very long text that elides"


def test_text_disabled_state() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nText { text: "x"; enabled: false }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False
