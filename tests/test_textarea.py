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


def test_textarea_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nTextArea { placeholderText: 'Notes' }\n")
    roots = engine.rootObjects()
    assert roots, "default TextArea failed to load"
    ta = roots[0]
    assert ta.property("error") is False
    assert ta.property("mono") is False
    assert ta.property("minHeight") == 64
    assert ta.property("placeholderText") == "Notes"
    assert ta.property("leftPadding") == 12
    assert ta.property("rightPadding") == 12
    assert ta.property("topPadding") == 8
    assert ta.property("bottomPadding") == 8


def test_textarea_implicit_height_respects_min_height() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nTextArea { }\n")
    roots = engine.rootObjects()
    assert roots
    ta = roots[0]
    # implicitHeight = max(minHeight=64, contentHeight + topPadding + bottomPadding)
    assert ta.property("implicitHeight") >= 64


def test_textarea_custom_min_height() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nTextArea { minHeight: 120 }\n")
    roots = engine.rootObjects()
    assert roots
    ta = roots[0]
    assert ta.property("minHeight") == 120
    assert ta.property("implicitHeight") >= 120


def test_textarea_error_state_toggle() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nTextArea { error: true; text: 'bad' }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("error") is True
    assert roots[0].property("text") == "bad"


def test_textarea_mono_variant_toggle() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"TextArea { mono: true; text: 'AAAA-BBBB-CCCC-DDDD' }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("mono") is True
    assert roots[0].property("text") == "AAAA-BBBB-CCCC-DDDD"


def test_textarea_read_only() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"TextArea { readOnly: true; text: 'log line 1\\nlog line 2' }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("readOnly") is True
    assert roots[0].property("text") == "log line 1\nlog line 2"


def test_textarea_disabled_state() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nTextArea { enabled: false; text: 'x' }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_textarea_multiline_text_round_trip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nTextArea { text: 'first\\nsecond\\nthird' }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "first\nsecond\nthird"
