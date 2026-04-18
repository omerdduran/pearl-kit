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


_TOASTER_PROBE = b"""
import QtQuick
import PearlKit 1.0

Item {
    property int stackCount: Toaster._stack.count
    property string position: Toaster.position
    property int maxStack: Toaster.maxStack

    property int showOne: 0
    property int showCount: 0
    property int resetStack: 0

    onShowOneChanged: Toaster.show({type: "success", title: "hi"})
    onShowCountChanged: {
        for (var i = 0; i < showCount; ++i) Toaster.show({type: "info", title: "n" + i})
    }
    onResetStackChanged: {
        while (Toaster._stack.count > 0) Toaster._stack.remove(0)
    }
}
"""


def _fresh_probe() -> QQmlApplicationEngine:
    engine = _load(_TOASTER_PROBE)
    obj = engine.rootObjects()[0]
    obj.setProperty("resetStack", obj.property("resetStack") + 1)
    return engine


def test_toaster_singleton_loads() -> None:
    engine = _fresh_probe()
    obj = engine.rootObjects()[0]
    assert obj.property("position") == "top-right"
    assert obj.property("maxStack") == 3


def test_toaster_show_increments_stack() -> None:
    engine = _fresh_probe()
    obj = engine.rootObjects()[0]
    assert obj.property("stackCount") == 0
    obj.setProperty("showOne", obj.property("showOne") + 1)
    assert obj.property("stackCount") == 1


def test_toaster_max_stack_enforced() -> None:
    engine = _fresh_probe()
    obj = engine.rootObjects()[0]
    obj.setProperty("showCount", 5)
    assert obj.property("stackCount") == 3


def test_toaster_default_duration_is_4000() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
Item {
    property int d: Toaster.defaultDuration
}
"""
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("d") == 4000
