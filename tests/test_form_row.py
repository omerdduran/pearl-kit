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


def test_form_row_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nFormRow { }\n")
    roots = engine.rootObjects()
    assert roots, "default FormRow failed to load"
    row = roots[0]
    assert row.property("label") == ""
    assert row.property("hint") == ""
    assert row.property("error") == ""
    assert row.property("labelWidth") == 120
    assert row.property("enabled") is True


def test_form_row_label_and_hint_round_trip() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nFormRow { label: "Email"; hint: "Work address" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    row = roots[0]
    assert row.property("label") == "Email"
    assert row.property("hint") == "Work address"
    assert row.property("error") == ""


def test_form_row_error_round_trip() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nFormRow { label: "Password"; error: "Required" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    row = roots[0]
    assert row.property("error") == "Required"
    row.setProperty("error", "")
    assert row.property("error") == ""


def test_form_row_custom_label_width() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nFormRow { labelWidth: 180 }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("labelWidth") == 180


def test_form_row_disabled_state() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nFormRow { enabled: false }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_form_row_default_slot_accepts_input() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'FormRow { label: "Email"; Input { objectName: "emailInput" } }\n',
    )
    roots = engine.rootObjects()
    assert roots, "FormRow with default-slot child failed to load"
    # root FormRow has implicit height > 0 once its child is laid out
    assert roots[0].property("implicitHeight") > 0


def test_form_row_stacks_in_column_layout() -> None:
    engine = _load(
        b"import QtQuick\nimport QtQuick.Layouts\nimport PearlKit 1.0\n"
        b"ColumnLayout {\n"
        b"    width: 480\n"
        b"    spacing: 8\n"
        b'    FormRow { Layout.fillWidth: true; label: "First name"; Input { } }\n'
        b'    FormRow { Layout.fillWidth: true; label: "Email"; hint: "Work"; Input { } }\n'
        b'    FormRow { Layout.fillWidth: true; label: "Password"; error: "Required"; Input { } }\n'
        b"}\n",
    )
    roots = engine.rootObjects()
    assert roots, "FormRow stack failed to load"
