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
    b"StackedView {\n"
    b"    width: 400; height: 300\n"
    b"    Rectangle { color: 'red' }\n"
    b"    Rectangle { color: 'green' }\n"
    b"    Rectangle { color: 'blue' }\n"
    b"}\n"
)

_WITH_INDEX = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"StackedView {\n"
    b"    currentIndex: 2\n"
    b"    width: 400; height: 300\n"
    b"    Rectangle { color: 'red' }\n"
    b"    Rectangle { color: 'green' }\n"
    b"    Rectangle { color: 'blue' }\n"
    b"}\n"
)

_ANIMATED = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"StackedView {\n"
    b"    animated: true\n"
    b"    width: 400; height: 300\n"
    b"    Rectangle { color: 'red' }\n"
    b"    Rectangle { color: 'green' }\n"
    b"}\n"
)

_KEYED = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"StackedView {\n"
    b"    id: sv\n"
    b"    currentKey: 'settings'\n"
    b"    width: 400; height: 300\n"
    b"    Rectangle { property string stackKey: 'home';     color: 'red' }\n"
    b"    Rectangle { property string stackKey: 'settings'; color: 'green' }\n"
    b"    Rectangle { property string stackKey: 'about';    color: 'blue' }\n"
    b"}\n"
)

_KEY_LATE_SWITCH = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"StackedView {\n"
    b"    id: sv\n"
    b"    width: 400; height: 300\n"
    b"    property int resolvedIndex: -1\n"
    b"    Rectangle { property string stackKey: 'home';     color: 'red' }\n"
    b"    Rectangle { property string stackKey: 'settings'; color: 'green' }\n"
    b"    Rectangle { property string stackKey: 'about';    color: 'blue' }\n"
    b"    Component.onCompleted: {\n"
    b"        sv.currentKey = 'about'\n"
    b"        sv.resolvedIndex = sv.currentIndex\n"
    b"    }\n"
    b"}\n"
)

_UNKNOWN_KEY = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"StackedView {\n"
    b"    id: sv\n"
    b"    currentKey: 'does-not-exist'\n"
    b"    width: 400; height: 300\n"
    b"    Rectangle { property string stackKey: 'home';  color: 'red' }\n"
    b"    Rectangle { property string stackKey: 'about'; color: 'blue' }\n"
    b"}\n"
)

_INDEX_UPDATES_KEY = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"StackedView {\n"
    b"    id: sv\n"
    b"    width: 400; height: 300\n"
    b"    property string observedKey: ''\n"
    b"    Rectangle { property string stackKey: 'home';     color: 'red' }\n"
    b"    Rectangle { property string stackKey: 'settings'; color: 'green' }\n"
    b"    Rectangle { property string stackKey: 'about';    color: 'blue' }\n"
    b"    Component.onCompleted: {\n"
    b"        sv.currentIndex = 1\n"
    b"        sv.observedKey = sv.currentKey\n"
    b"    }\n"
    b"}\n"
)

_EMPTY = b"import QtQuick\nimport PearlKit 1.0\nStackedView { width: 400; height: 300 }\n"

_DISABLED = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"StackedView {\n"
    b"    enabled: false\n"
    b"    width: 400; height: 300\n"
    b"    Rectangle { color: 'red' }\n"
    b"    Rectangle { color: 'green' }\n"
    b"}\n"
)

_NESTED_IN_SPLITTER = (
    b"import QtQuick\n"
    b"import QtQuick.Controls\n"
    b"import PearlKit 1.0\n"
    b"Splitter {\n"
    b"    width: 600; height: 400\n"
    b"    Rectangle { color: 'navy'; SplitView.preferredWidth: 160 }\n"
    b"    StackedView {\n"
    b"        SplitView.fillWidth: true\n"
    b"        Rectangle { color: 'red' }\n"
    b"        Rectangle { color: 'green' }\n"
    b"    }\n"
    b"}\n"
)


def test_stacked_view_default_loads() -> None:
    engine = _load(_DEFAULT)
    roots = engine.rootObjects()
    assert roots, "default StackedView failed to load"
    obj = roots[0]
    assert obj.property("animated") is False
    assert obj.property("currentIndex") == 0
    assert obj.property("currentKey") == ""


def test_stacked_view_explicit_index() -> None:
    engine = _load(_WITH_INDEX)
    roots = engine.rootObjects()
    assert roots, "StackedView with currentIndex failed to load"
    assert roots[0].property("currentIndex") == 2


def test_stacked_view_animated_flag_round_trips() -> None:
    engine = _load(_ANIMATED)
    roots = engine.rootObjects()
    assert roots, "animated StackedView failed to load"
    assert roots[0].property("animated") is True


def test_stacked_view_initial_current_key_resolves_to_index() -> None:
    engine = _load(_KEYED)
    roots = engine.rootObjects()
    assert roots, "keyed StackedView failed to load"
    obj = roots[0]
    assert obj.property("currentKey") == "settings"
    assert obj.property("currentIndex") == 1


def test_stacked_view_runtime_key_switch() -> None:
    engine = _load(_KEY_LATE_SWITCH)
    roots = engine.rootObjects()
    assert roots, "late-switch StackedView failed to load"
    assert roots[0].property("resolvedIndex") == 2
    assert roots[0].property("currentKey") == "about"


def test_stacked_view_unknown_key_is_no_op() -> None:
    engine = _load(_UNKNOWN_KEY)
    roots = engine.rootObjects()
    assert roots, "unknown-key StackedView failed to load"
    # Unknown key leaves currentIndex at default 0 and surfaces the child's
    # actual key via the index->key sync at Component.onCompleted.
    assert roots[0].property("currentIndex") == 0
    assert roots[0].property("currentKey") == "home"


def test_stacked_view_index_change_updates_key() -> None:
    engine = _load(_INDEX_UPDATES_KEY)
    roots = engine.rootObjects()
    assert roots, "index->key sync StackedView failed to load"
    assert roots[0].property("observedKey") == "settings"
    assert roots[0].property("currentKey") == "settings"


def test_stacked_view_empty_loads() -> None:
    engine = _load(_EMPTY)
    roots = engine.rootObjects()
    assert roots, "empty StackedView failed to load"


def test_stacked_view_disabled_state() -> None:
    engine = _load(_DISABLED)
    roots = engine.rootObjects()
    assert roots, "disabled StackedView failed to load"
    assert roots[0].property("enabled") is False


def test_stacked_view_inside_splitter_loads() -> None:
    engine = _load(_NESTED_IN_SPLITTER)
    roots = engine.rootObjects()
    assert roots, "StackedView inside Splitter failed to load"
