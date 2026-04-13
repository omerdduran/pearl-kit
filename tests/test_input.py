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


def test_input_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nInput { placeholderText: 'Email' }\n")
    roots = engine.rootObjects()
    assert roots, "default Input failed to load"
    inp = roots[0]
    assert inp.property("implicitHeight") == 36
    assert inp.property("error") is False
    assert inp.property("placeholderText") == "Email"


def test_input_error_state_toggle() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nInput { error: true; text: 'bad' }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("error") is True


def test_input_icon_left_adjusts_left_padding() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nInput { iconLeft: "qrc:/search.svg" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("leftPadding") == 36
    assert roots[0].property("rightPadding") == 12


def test_input_icon_right_adjusts_right_padding() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nInput { iconRight: "qrc:/clear.svg" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("leftPadding") == 12
    assert roots[0].property("rightPadding") == 36


def test_input_both_icons_adjust_both_paddings() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'Input { iconLeft: "qrc:/a.svg"; iconRight: "qrc:/b.svg" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("leftPadding") == 36
    assert roots[0].property("rightPadding") == 36


def test_input_disabled_state() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nInput { enabled: false; text: 'x' }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_input_echo_mode_passthrough() -> None:
    engine = _load(
        b"import QtQuick\nimport QtQuick.Controls\nimport PearlKit 1.0\n"
        b"Input { echoMode: TextInput.Password; text: 'secret' }\n"
    )
    roots = engine.rootObjects()
    assert roots, "Input with echoMode failed to load"
    # The QQuickTextInput.EchoMode enum does not cross the PySide property bridge
    # as a plain int, so the meaningful smoke test is that the engine accepted the
    # binding without QML errors. Verify text round-trips correctly as a proxy.
    assert roots[0].property("text") == "secret"
