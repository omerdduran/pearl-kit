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


def test_readout_slider_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nReadoutSlider { }\n")
    roots = engine.rootObjects()
    assert roots, "default ReadoutSlider failed to load"
    assert roots[0].property("implicitWidth") == 340


def test_readout_slider_with_value_and_unit() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'ReadoutSlider { value: 2.5; from: 1.0; to: 4.0; stepSize: 0.1; unit: "mm" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("value") == 2.5
    assert roots[0].property("from") == 1.0
    assert roots[0].property("to") == 4.0
    assert roots[0].property("unit") == "mm"


def test_readout_slider_integer_step() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'ReadoutSlider { value: 64; from: 8; to: 128; stepSize: 8; unit: "GB" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("value") == 64
    assert roots[0].property("stepSize") == 8
