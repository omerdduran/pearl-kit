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


def test_slider_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSlider { from: 0; to: 100; value: 50 }\n")
    roots = engine.rootObjects()
    assert roots, "default Slider failed to load"
    slider = roots[0]
    assert slider.property("value") == 50
    assert slider.property("from") == 0
    assert slider.property("to") == 100
    assert slider.property("implicitWidth") == 200
    assert slider.property("implicitHeight") == 20


def test_slider_vertical_orientation_swaps_implicit_size() -> None:
    engine = _load(
        b"import QtQuick\nimport QtQuick.Controls\nimport PearlKit 1.0\n"
        b"Slider { orientation: Qt.Vertical; from: 0; to: 100 }\n"
    )
    roots = engine.rootObjects()
    assert roots, "vertical Slider failed to load"
    slider = roots[0]
    assert slider.property("implicitWidth") == 20
    assert slider.property("implicitHeight") == 176


def test_slider_value_round_trips() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Slider { from: 0; to: 6000; value: 3000; stepSize: 100 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    slider = roots[0]
    assert slider.property("value") == 3000
    assert slider.property("to") == 6000
    assert slider.property("stepSize") == 100


def test_slider_disabled_state() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSlider { enabled: false; value: 25 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False
    assert roots[0].property("value") == 25


def test_slider_show_ticks_toggles() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Slider { showTicks: true; tickCount: 11; from: 0; to: 100 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    slider = roots[0]
    assert slider.property("showTicks") is True
    assert slider.property("tickCount") == 11


def test_slider_tick_count_zero_is_auto() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Slider { showTicks: true; from: 0; to: 100; stepSize: 25 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    slider = roots[0]
    assert slider.property("showTicks") is True
    assert slider.property("tickCount") == 0


def test_slider_large_range_window_level() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nSlider { from: 0; to: 6000; value: 2048 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    slider = roots[0]
    assert slider.property("value") == 2048
