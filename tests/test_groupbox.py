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


def test_groupbox_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nGroupBox { }\n")
    roots = engine.rootObjects()
    assert roots, "default GroupBox failed to load"
    obj = roots[0]
    assert obj.property("title") == ""
    assert obj.property("description") == ""
    assert obj.property("collapsible") is False
    assert obj.property("expanded") is True
    assert obj.property("advanced") is False
    assert obj.property("advancedVisible") is True
    assert obj.property("visible") is True
    assert obj.property("implicitHeight") > 0


def test_groupbox_title_and_description() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'GroupBox { title: "Notifications"; description: "Configure alerts." }\n',
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("title") == "Notifications"
    assert obj.property("description") == "Configure alerts."


def test_groupbox_collapsible_toggle() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nGroupBox { collapsible: true; expanded: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("collapsible") is True
    assert obj.property("expanded") is False
    obj.setProperty("expanded", True)
    assert obj.property("expanded") is True


def test_groupbox_advanced_visibility_gate_hidden() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"GroupBox { advanced: true; advancedVisible: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("advanced") is True
    assert obj.property("advancedVisible") is False
    assert obj.property("visible") is False


def test_groupbox_advanced_visibility_gate_shown() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"GroupBox { advanced: true; advancedVisible: true }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("visible") is True


def test_groupbox_non_advanced_always_visible() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"GroupBox { advanced: false; advancedVisible: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("visible") is True


def test_groupbox_disabled_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nGroupBox { enabled: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_groupbox_default_content_alias() -> None:
    engine = _load(
        b"import QtQuick\nimport QtQuick.Controls\nimport PearlKit 1.0\n"
        b'GroupBox { title: "x"; CheckBox { } CheckBox { checked: true } }\n',
    )
    roots = engine.rootObjects()
    assert roots, "GroupBox with default-slot children failed to load"
