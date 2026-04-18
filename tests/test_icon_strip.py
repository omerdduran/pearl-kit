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


_EMPTY = b"""
import QtQuick
import PearlKit 1.0
IconStrip { }
"""

_BASIC = b"""
import QtQuick
import PearlKit 1.0
IconStrip {
    items: [
        { key: "viewer",       iconSource: "", label: "View" },
        { key: "segmentation", iconSource: "", label: "Segment" }
    ]
    footerItems: [
        { key: "settings",     iconSource: "", label: "Settings" }
    ]
    activeKey: "viewer"
}
"""

_CUSTOM_DIMS = b"""
import QtQuick
import PearlKit 1.0
IconStrip {
    stripWidth: 56
    tileHeight: 60
    iconSize: 24
    showLabels: false
    items: [
        { key: "a", iconSource: "", label: "A" }
    ]
}
"""


def test_icon_strip_empty_loads() -> None:
    engine = _load(_EMPTY)
    assert engine.rootObjects(), "empty IconStrip failed to load"
    strip = engine.rootObjects()[0]
    assert strip.property("implicitWidth") == 48
    assert strip.property("stripWidth") == 48
    assert strip.property("tileHeight") == 52
    assert strip.property("iconSize") == 20
    assert strip.property("showLabels") is True
    assert strip.property("activeKey") == ""


def test_icon_strip_basic_loads() -> None:
    engine = _load(_BASIC)
    assert engine.rootObjects(), "basic IconStrip failed to load"
    strip = engine.rootObjects()[0]
    assert strip.property("activeKey") == "viewer"
    assert len(strip.property("items").toVariant()) == 2
    assert len(strip.property("footerItems").toVariant()) == 1


def test_icon_strip_custom_dims_apply() -> None:
    engine = _load(_CUSTOM_DIMS)
    assert engine.rootObjects(), "custom-dim IconStrip failed to load"
    strip = engine.rootObjects()[0]
    assert strip.property("implicitWidth") == 56
    assert strip.property("stripWidth") == 56
    assert strip.property("tileHeight") == 60
    assert strip.property("iconSize") == 24
    assert strip.property("showLabels") is False


def test_icon_strip_active_key_roundtrip() -> None:
    engine = _load(_BASIC)
    roots = engine.rootObjects()
    assert roots
    strip = roots[0]
    strip.setProperty("activeKey", "segmentation")
    assert strip.property("activeKey") == "segmentation"
    strip.setProperty("activeKey", "")
    assert strip.property("activeKey") == ""


def test_icon_strip_disabled_state() -> None:
    engine = _load(_BASIC)
    roots = engine.rootObjects()
    assert roots
    strip = roots[0]
    strip.setProperty("enabled", False)
    assert strip.property("enabled") is False
    strip.setProperty("enabled", True)
    assert strip.property("enabled") is True
