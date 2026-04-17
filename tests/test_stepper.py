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


def test_stepper_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStepper { }\n")
    roots = engine.rootObjects()
    assert roots, "default Stepper failed to load"
    obj = roots[0]
    assert obj.property("implicitWidth") == 160
    assert obj.property("implicitHeight") == 36
    assert obj.property("from") == 0
    assert obj.property("to") == 100
    assert obj.property("value") == 0
    assert obj.property("decimals") == 0
    assert obj.property("suffix") == ""
    assert obj.property("editable") is True
    assert obj.property("error") is False


def test_stepper_int_value_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nStepper { from: 0; to: 100; value: 42 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("value") == 42


def test_stepper_float_value_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Stepper { from: 0; to: 10; decimals: 2; stepSize: 0.1; value: 2.5 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert abs(roots[0].property("value") - 2.5) < 1e-9


def test_stepper_suffix_and_special_value_text() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nStepper { suffix: '%'; specialValueText: 'Auto' }\n"
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("suffix") == "%"
    assert obj.property("specialValueText") == "Auto"


def test_stepper_error_state() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStepper { error: true }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("error") is True


def test_stepper_disabled_state() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStepper { enabled: false }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_stepper_editable_false() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStepper { editable: false }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("editable") is False


def test_stepper_range_and_step_size() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Stepper { from: -50; to: 50; stepSize: 5; value: 10 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("from") == -50
    assert obj.property("to") == 50
    assert obj.property("stepSize") == 5
    assert obj.property("value") == 10
