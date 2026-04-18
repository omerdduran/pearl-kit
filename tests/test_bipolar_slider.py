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


def test_bipolar_slider_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nBipolarSlider { }\n")
    roots = engine.rootObjects()
    assert roots, "default BipolarSlider failed to load"
    assert roots[0].property("value") == 0
    assert roots[0].property("range") == 15


def test_bipolar_slider_custom_range_value() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nBipolarSlider { value: -8; range: 30 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("value") == -8
    assert roots[0].property("range") == 30
