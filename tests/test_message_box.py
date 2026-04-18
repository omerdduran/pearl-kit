import sys

import pytest
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def _load(qml: bytes) -> QQmlApplicationEngine:
    import pearl_kit

    _ = QGuiApplication.instance() or QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(qml)
    return engine


def test_message_box_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nMessageBox { }\n")
    roots = engine.rootObjects()
    assert roots, "default MessageBox failed to load"
    obj = roots[0]
    assert obj.property("variant") == "info"
    assert obj.property("heading") == ""
    assert obj.property("message") == ""
    assert obj.property("okText") == "OK"
    assert obj.property("cancelText") == "Cancel"
    assert obj.property("okVariant") == "default"
    assert obj.property("showCloseButton") is False
    assert obj.property("maxWidth") == 420


@pytest.mark.parametrize("variant", ["info", "warning", "error", "confirm"])
def test_message_box_each_variant_loads(variant: str) -> None:
    qml = f'import QtQuick\nimport PearlKit 1.0\nMessageBox {{ variant: "{variant}" }}\n'
    engine = _load(qml.encode("utf-8"))
    roots = engine.rootObjects()
    assert roots, f"MessageBox variant={variant} failed to load"
    assert roots[0].property("variant") == variant


def test_message_box_error_auto_destructive_ok() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nMessageBox { variant: "error" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("okVariant") == "destructive"


def test_message_box_ok_variant_override() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'MessageBox { variant: "error"; okVariant: "default" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("okVariant") == "default"


def test_message_box_heading_and_message_round_trip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'MessageBox { heading: "Saved"; message: "Changes written." }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("heading") == "Saved"
    assert roots[0].property("message") == "Changes written."


def test_message_box_custom_button_labels() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'MessageBox { okText: "Delete"; cancelText: "Keep" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("okText") == "Delete"
    assert roots[0].property("cancelText") == "Keep"


def test_message_box_inside_window_opens() -> None:
    engine = _load(
        b"import QtQuick\n"
        b"import QtQuick.Controls\n"
        b"import PearlKit 1.0\n"
        b"ApplicationWindow {\n"
        b"  width: 400; height: 300; visible: true\n"
        b'  MessageBox { id: mb; variant: "info"; heading: "Hi"; message: "Body." }\n'
        b"  Component.onCompleted: mb.open()\n"
        b"}\n",
    )
    roots = engine.rootObjects()
    assert roots


def test_message_box_disabled_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nMessageBox { enabled: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False
