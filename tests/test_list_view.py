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


_DEFAULT = b"import QtQuick\nimport PearlKit 1.0\nListView {\n    width: 240; height: 240\n}\n"

_STRING_MODEL = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ListView {\n"
    b"    width: 240; height: 240\n"
    b'    model: ["Alpha", "Bravo", "Charlie"]\n'
    b"}\n"
)

_OBJECT_MODEL = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ListView {\n"
    b"    width: 240; height: 240\n"
    b"    model: [\n"
    b'        { label: "Implant #1", trailing: "4.2 x 11 mm" },\n'
    b'        { label: "Implant #2", trailing: "3.8 x 10 mm" }\n'
    b"    ]\n"
    b"}\n"
)

_WITH_INDEX = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ListView {\n"
    b"    width: 240; height: 240\n"
    b'    model: ["a", "b", "c"]\n'
    b"    currentIndex: 2\n"
    b"}\n"
)

_FLUSH = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ListView {\n"
    b"    width: 240; height: 240\n"
    b'    variant: "flush"\n'
    b'    model: ["one", "two"]\n'
    b"}\n"
)

_EMPTY_TEXT = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ListView {\n"
    b"    width: 240; height: 240\n"
    b'    emptyText: "No items yet"\n'
    b"}\n"
)

_SEPARATORS = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ListView {\n"
    b"    width: 240; height: 240\n"
    b"    showSeparators: true\n"
    b'    model: ["row 1", "row 2", "row 3"]\n'
    b"}\n"
)

_CUSTOM_DELEGATE = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ListView {\n"
    b"    width: 240; height: 240\n"
    b'    model: ["x", "y"]\n'
    b"    delegate: Rectangle {\n"
    b"        width: ListView.view ? ListView.view.width : 100\n"
    b"        height: 48\n"
    b'        color: "transparent"\n'
    b"    }\n"
    b"}\n"
)

_DISABLED = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ListView {\n"
    b"    width: 240; height: 240\n"
    b"    enabled: false\n"
    b'    model: ["a", "b"]\n'
    b"}\n"
)

_INSIDE_CARD = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"Card {\n"
    b"    width: 320; height: 280\n"
    b"    ListView {\n"
    b"        width: 288; height: 240\n"
    b'        variant: "flush"\n'
    b'        model: ["inside", "a", "card"]\n'
    b"    }\n"
    b"}\n"
)


def test_list_view_default_loads() -> None:
    engine = _load(_DEFAULT)
    roots = engine.rootObjects()
    assert roots, "default ListView failed to load"
    obj = roots[0]
    assert obj.property("variant") == "card"
    assert obj.property("count") == 0
    assert obj.property("currentIndex") == -1
    assert obj.property("rowHeight") == 36
    assert obj.property("showSeparators") is False
    assert obj.property("emptyText") == ""


def test_list_view_string_model_loads() -> None:
    engine = _load(_STRING_MODEL)
    roots = engine.rootObjects()
    assert roots, "string-model ListView failed to load"
    assert roots[0].property("count") == 3


def test_list_view_object_model_loads() -> None:
    engine = _load(_OBJECT_MODEL)
    roots = engine.rootObjects()
    assert roots, "object-model ListView failed to load"
    assert roots[0].property("count") == 2


def test_list_view_current_index_round_trips() -> None:
    engine = _load(_WITH_INDEX)
    roots = engine.rootObjects()
    assert roots, "ListView with currentIndex failed to load"
    assert roots[0].property("currentIndex") == 2


def test_list_view_flush_variant_loads() -> None:
    engine = _load(_FLUSH)
    roots = engine.rootObjects()
    assert roots, "flush ListView failed to load"
    assert roots[0].property("variant") == "flush"
    assert roots[0].property("count") == 2


def test_list_view_empty_text_property() -> None:
    engine = _load(_EMPTY_TEXT)
    roots = engine.rootObjects()
    assert roots, "ListView with emptyText failed to load"
    assert roots[0].property("emptyText") == "No items yet"
    assert roots[0].property("count") == 0


def test_list_view_show_separators_toggle() -> None:
    engine = _load(_SEPARATORS)
    roots = engine.rootObjects()
    assert roots, "ListView with separators failed to load"
    assert roots[0].property("showSeparators") is True
    assert roots[0].property("count") == 3


def test_list_view_custom_delegate_loads() -> None:
    engine = _load(_CUSTOM_DELEGATE)
    roots = engine.rootObjects()
    assert roots, "ListView with custom delegate failed to load"
    assert roots[0].property("count") == 2


def test_list_view_disabled_state() -> None:
    engine = _load(_DISABLED)
    roots = engine.rootObjects()
    assert roots, "disabled ListView failed to load"
    assert roots[0].property("enabled") is False


def test_list_view_inside_card_loads() -> None:
    engine = _load(_INSIDE_CARD)
    roots = engine.rootObjects()
    assert roots, "ListView inside Card failed to load"
