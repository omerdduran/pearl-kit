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


def test_dialog_default_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nDialog { }\n",
    )
    roots = engine.rootObjects()
    assert roots, "default Dialog failed to load"
    obj = roots[0]
    assert obj.property("title") == ""
    assert obj.property("description") == ""
    assert obj.property("showCloseButton") is True
    assert obj.property("maxWidth") == 512
    assert obj.property("modal") is True


def test_dialog_title_and_description() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nDialog { title: "Hello"; description: "World" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("title") == "Hello"
    assert obj.property("description") == "World"


def test_dialog_close_button_toggle() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nDialog { showCloseButton: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("showCloseButton") is False


def test_dialog_max_width_override() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nDialog { maxWidth: 720 }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("maxWidth") == 720


def test_dialog_inside_window_opens() -> None:
    engine = _load(
        b"import QtQuick\n"
        b"import QtQuick.Controls\n"
        b"import PearlKit 1.0\n"
        b"ApplicationWindow {\n"
        b"  width: 400; height: 300; visible: true\n"
        b'  Dialog { id: dlg; title: "t" }\n'
        b"  Component.onCompleted: dlg.open()\n"
        b"}\n",
    )
    roots = engine.rootObjects()
    assert roots


def test_dialog_disabled_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nDialog { enabled: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False
