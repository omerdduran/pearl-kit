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


def test_checkbox_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nCheckBox { }\n")
    roots = engine.rootObjects()
    assert roots, "default CheckBox failed to load"
    obj = roots[0]
    assert obj.property("implicitWidth") == 16
    assert obj.property("implicitHeight") == 16
    assert obj.property("checked") is False
    assert obj.property("error") is False
    assert obj.property("tristate") is False


def test_checkbox_checked_roundtrip() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nCheckBox { checked: true }\n")
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("checked") is True
    obj.setProperty("checked", False)
    assert obj.property("checked") is False


def test_checkbox_error_roundtrip() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nCheckBox { error: true }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("error") is True


def test_checkbox_disabled_state() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nCheckBox { enabled: false }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_checkbox_tristate_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"CheckBox { tristate: true; checkState: Qt.PartiallyChecked }\n"
    )
    roots = engine.rootObjects()
    assert roots, "tristate CheckBox failed to load"
    assert roots[0].property("tristate") is True


def test_checkbox_text_ignored() -> None:
    # shadcn divergence: label is composed externally. `text` is harmless but not rendered.
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nCheckBox { text: "ignored" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "ignored"
