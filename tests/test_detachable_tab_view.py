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


_DEFAULT = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"DetachableTabView {\n"
    b"    width: 600; height: 400\n"
    b'    DetachableTab { title: "First";  stackKey: "first" }\n'
    b'    DetachableTab { title: "Second"; stackKey: "second" }\n'
    b'    DetachableTab { title: "Third";  stackKey: "third" }\n'
    b"}\n"
)

_INITIAL_KEY = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"DetachableTabView {\n"
    b'    currentKey: "second"\n'
    b"    width: 600; height: 400\n"
    b'    DetachableTab { title: "First";  stackKey: "first" }\n'
    b'    DetachableTab { title: "Second"; stackKey: "second" }\n'
    b'    DetachableTab { title: "Third";  stackKey: "third" }\n'
    b"}\n"
)

_VARIANTS = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b'DetachableTabView { variant: "line"; width: 400; height: 300;'
    b' DetachableTab { title: "A"; stackKey: "a" } }\n'
)

_DETACH_AT_ONE = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"DetachableTabView {\n"
    b"    id: v\n"
    b"    width: 600; height: 400\n"
    b'    DetachableTab { title: "First";  stackKey: "first" }\n'
    b'    DetachableTab { title: "Second"; stackKey: "second" }\n'
    b'    DetachableTab { title: "Third";  stackKey: "third" }\n'
    b"    property int afterDocked: -1\n"
    b"    property int afterFloating: -1\n"
    b'    property string afterKey: ""\n'
    b"    Component.onCompleted: {\n"
    b"        v.detachTab(1)\n"
    b"        afterDocked = v.dockedCount\n"
    b"        afterFloating = v.floatingCount\n"
    b"        afterKey = v.currentKey\n"
    b"    }\n"
    b"}\n"
)

_DETACH_AND_DOCK = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"DetachableTabView {\n"
    b"    id: v\n"
    b"    width: 600; height: 400\n"
    b'    DetachableTab { title: "First";  stackKey: "first" }\n'
    b'    DetachableTab { title: "Second"; stackKey: "second" }\n'
    b"    property int afterDetachFloating: -1\n"
    b"    property int afterDockFloating: -1\n"
    b"    property int afterDockDocked: -1\n"
    b"    Component.onCompleted: {\n"
    b'        v.detachTabByKey("second")\n'
    b"        afterDetachFloating = v.floatingCount\n"
    b'        v.dockTabByKey("second")\n'
    b"        afterDockFloating = v.floatingCount\n"
    b"        afterDockDocked = v.dockedCount\n"
    b"    }\n"
    b"}\n"
)

_PERMANENT_CANNOT_DETACH = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"DetachableTabView {\n"
    b"    id: v\n"
    b"    width: 600; height: 400\n"
    b'    DetachableTab { title: "Main";  stackKey: "main"; permanent: true }\n'
    b'    DetachableTab { title: "Other"; stackKey: "other" }\n'
    b"    property int floatingAfter: -1\n"
    b"    Component.onCompleted: {\n"
    b"        v.detachTab(0)\n"
    b"        floatingAfter = v.floatingCount\n"
    b"    }\n"
    b"}\n"
)

_NON_DETACHABLE_CANNOT_DETACH = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"DetachableTabView {\n"
    b"    id: v\n"
    b"    width: 600; height: 400\n"
    b'    DetachableTab { title: "Fixed"; stackKey: "fixed"; nonDetachable: true }\n'
    b'    DetachableTab { title: "Other"; stackKey: "other" }\n'
    b"    property int floatingAfter: -1\n"
    b"    Component.onCompleted: {\n"
    b"        v.detachTab(0)\n"
    b"        floatingAfter = v.floatingCount\n"
    b"    }\n"
    b"}\n"
)

_CLOSE_ALL_FLOATING = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"DetachableTabView {\n"
    b"    id: v\n"
    b"    width: 600; height: 400\n"
    b'    DetachableTab { title: "A"; stackKey: "a" }\n'
    b'    DetachableTab { title: "B"; stackKey: "b" }\n'
    b'    DetachableTab { title: "C"; stackKey: "c" }\n'
    b"    property int afterDetachCount: -1\n"
    b"    property int afterCloseCount: -1\n"
    b"    property int afterCloseDocked: -1\n"
    b"    Component.onCompleted: {\n"
    b'        v.detachTabByKey("b")\n'
    b'        v.detachTabByKey("c")\n'
    b"        afterDetachCount = v.floatingCount\n"
    b"        v.closeAllFloating()\n"
    b"        afterCloseCount = v.floatingCount\n"
    b"        afterCloseDocked = v.dockedCount\n"
    b"    }\n"
    b"}\n"
)


def test_detachable_tab_view_default_loads() -> None:
    engine = _load(_DEFAULT)
    roots = engine.rootObjects()
    assert roots, "default DetachableTabView failed to load"
    obj = roots[0]
    assert obj.property("currentIndex") == 0
    assert obj.property("currentKey") == "first"
    assert obj.property("dockedCount") == 3
    assert obj.property("floatingCount") == 0
    assert obj.property("variant") == "default"


def test_detachable_tab_view_initial_current_key() -> None:
    engine = _load(_INITIAL_KEY)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("currentKey") == "second"
    assert roots[0].property("currentIndex") == 1


def test_detachable_tab_view_variant_line() -> None:
    engine = _load(_VARIANTS)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("variant") == "line"


def test_detachable_tab_detach_at_index() -> None:
    engine = _load(_DETACH_AT_ONE)
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("afterDocked") == 2
    assert obj.property("afterFloating") == 1
    # currentKey is the first docked tab's key after the middle tab was detached
    # (currentIndex was clamped or sync'd to a still-docked tab)
    assert obj.property("afterKey") in ("first", "third")


def test_detachable_tab_detach_and_dock_round_trip() -> None:
    engine = _load(_DETACH_AND_DOCK)
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("afterDetachFloating") == 1
    assert obj.property("afterDockFloating") == 0
    assert obj.property("afterDockDocked") == 2


def test_detachable_tab_permanent_cannot_detach() -> None:
    engine = _load(_PERMANENT_CANNOT_DETACH)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("floatingAfter") == 0


def test_detachable_tab_non_detachable_cannot_detach() -> None:
    engine = _load(_NON_DETACHABLE_CANNOT_DETACH)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("floatingAfter") == 0


def test_detachable_tab_close_all_floating() -> None:
    engine = _load(_CLOSE_ALL_FLOATING)
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("afterDetachCount") == 2
    assert obj.property("afterCloseCount") == 0
    assert obj.property("afterCloseDocked") == 3


def test_detachable_tab_disabled_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"DetachableTabView { enabled: false; width: 400; height: 300;"
        b' DetachableTab { title: "x"; stackKey: "x" } }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False
