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


def test_radiobutton_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nRadioButton { text: 'A' }\n")
    roots = engine.rootObjects()
    assert roots, "default RadioButton failed to load"
    rb = roots[0]
    assert rb.property("checked") is False
    assert rb.property("error") is False
    # indicator + spacing + label → wider than the bare 18px indicator
    assert rb.property("implicitWidth") > 18
    assert rb.property("implicitHeight") >= 18


def test_radiobutton_checked_roundtrip() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nRadioButton { text: 'A'; checked: true }\n")
    roots = engine.rootObjects()
    assert roots
    rb = roots[0]
    assert rb.property("checked") is True
    rb.setProperty("checked", False)
    assert rb.property("checked") is False


def test_radiobutton_error_state() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nRadioButton { text: 'A'; error: true }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("error") is True


def test_radiobutton_disabled_state() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nRadioButton { text: 'A'; enabled: false }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_radiobutton_autoexclusive_group() -> None:
    # Two radios in the same parent are mutually exclusive (T.RadioButton
    # autoExclusive is on by default) — checking the second clears the first.
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Column {\n"
        b"  RadioButton { objectName: 'r1'; text: 'One'; checked: true }\n"
        b"  RadioButton { objectName: 'r2'; text: 'Two' }\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    col = roots[0]
    r1 = col.findChild(type(col), "r1")
    r2 = col.findChild(type(col), "r2")
    assert r1 is not None and r2 is not None
    assert r1.property("checked") is True
    r2.setProperty("checked", True)
    assert r2.property("checked") is True
    assert r1.property("checked") is False
