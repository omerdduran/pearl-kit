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
    b"ScrollArea {\n"
    b"    width: 200; height: 160\n"
    b"    Rectangle { width: 400; height: 400; color: 'steelblue' }\n"
    b"}\n"
)

_WITH_CONTENT_SIZE = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ScrollArea {\n"
    b"    width: 200; height: 160\n"
    b"    contentWidth: 600\n"
    b"    contentHeight: 800\n"
    b"    Rectangle { anchors.fill: parent; color: 'indigo' }\n"
    b"}\n"
)

_AUTO_HIDE_OFF = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ScrollArea {\n"
    b"    autoHide: false\n"
    b"    width: 200; height: 160\n"
    b"    Rectangle { width: 400; height: 400; color: 'teal' }\n"
    b"}\n"
)

_DISABLED = (
    b"import QtQuick\n"
    b"import PearlKit 1.0\n"
    b"ScrollArea {\n"
    b"    enabled: false\n"
    b"    width: 200; height: 160\n"
    b"    Rectangle { width: 400; height: 400; color: 'maroon' }\n"
    b"}\n"
)

_EMPTY = b"import QtQuick\nimport PearlKit 1.0\nScrollArea { width: 200; height: 160 }\n"

_NESTED_IN_LAYOUT = (
    b"import QtQuick\n"
    b"import QtQuick.Layouts\n"
    b"import PearlKit 1.0\n"
    b"Item {\n"
    b"    width: 300; height: 300\n"
    b"    ColumnLayout {\n"
    b"        anchors.fill: parent\n"
    b"        ScrollArea {\n"
    b"            Layout.fillWidth: true\n"
    b"            Layout.fillHeight: true\n"
    b"            Rectangle { width: 800; height: 800; color: 'olive' }\n"
    b"        }\n"
    b"    }\n"
    b"}\n"
)


def test_scroll_area_default_loads() -> None:
    engine = _load(_DEFAULT)
    roots = engine.rootObjects()
    assert roots, "default ScrollArea failed to load"
    obj = roots[0]
    assert obj.property("autoHide") is True
    assert obj.property("clip") is True
    assert obj.property("hoverEnabled") is True


def test_scroll_area_explicit_content_size() -> None:
    engine = _load(_WITH_CONTENT_SIZE)
    roots = engine.rootObjects()
    assert roots, "ScrollArea with contentWidth/contentHeight failed to load"
    obj = roots[0]
    assert obj.property("contentWidth") == 600
    assert obj.property("contentHeight") == 800


def test_scroll_area_auto_hide_off_round_trips() -> None:
    engine = _load(_AUTO_HIDE_OFF)
    roots = engine.rootObjects()
    assert roots, "ScrollArea autoHide=false failed to load"
    assert roots[0].property("autoHide") is False


def test_scroll_area_disabled_state() -> None:
    engine = _load(_DISABLED)
    roots = engine.rootObjects()
    assert roots, "disabled ScrollArea failed to load"
    assert roots[0].property("enabled") is False


def test_scroll_area_empty_loads() -> None:
    engine = _load(_EMPTY)
    roots = engine.rootObjects()
    assert roots, "empty ScrollArea failed to load"


def test_scroll_area_inside_column_layout_loads() -> None:
    engine = _load(_NESTED_IN_LAYOUT)
    roots = engine.rootObjects()
    assert roots, "ScrollArea inside ColumnLayout failed to load"
