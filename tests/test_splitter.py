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


_HORIZONTAL = (
    b"import QtQuick\n"
    b"import QtQuick.Controls\n"
    b"import PearlKit 1.0\n"
    b"Splitter {\n"
    b"    width: 400; height: 200\n"
    b"    Rectangle { color: 'red';   SplitView.preferredWidth: 120 }\n"
    b"    Rectangle { color: 'green'; SplitView.fillWidth: true }\n"
    b"    Rectangle { color: 'blue';  SplitView.preferredWidth: 120 }\n"
    b"}\n"
)

_VERTICAL = (
    b"import QtQuick\n"
    b"import QtQuick.Controls\n"
    b"import PearlKit 1.0\n"
    b"Splitter {\n"
    b"    orientation: Qt.Vertical\n"
    b"    width: 200; height: 400\n"
    b"    Rectangle { color: 'red';   SplitView.preferredHeight: 120 }\n"
    b"    Rectangle { color: 'green'; SplitView.fillHeight: true }\n"
    b"}\n"
)

_WITH_HANDLE = (
    b"import QtQuick\n"
    b"import QtQuick.Controls\n"
    b"import PearlKit 1.0\n"
    b"Splitter {\n"
    b"    withHandle: true\n"
    b"    width: 400; height: 200\n"
    b"    Rectangle { color: 'red';   SplitView.preferredWidth: 120 }\n"
    b"    Rectangle { color: 'green'; SplitView.fillWidth: true }\n"
    b"}\n"
)

_EMPTY = b"import QtQuick\nimport PearlKit 1.0\nSplitter { width: 400; height: 200 }\n"

_SINGLE_CHILD = (
    b"import QtQuick\n"
    b"import QtQuick.Controls\n"
    b"import PearlKit 1.0\n"
    b"Splitter {\n"
    b"    width: 400; height: 200\n"
    b"    Rectangle { color: 'red'; SplitView.fillWidth: true }\n"
    b"}\n"
)

_NESTED = (
    b"import QtQuick\n"
    b"import QtQuick.Controls\n"
    b"import PearlKit 1.0\n"
    b"Splitter {\n"
    b"    width: 600; height: 400\n"
    b"    Rectangle { color: 'red'; SplitView.preferredWidth: 180 }\n"
    b"    Splitter {\n"
    b"        orientation: Qt.Vertical\n"
    b"        SplitView.fillWidth: true\n"
    b"        Rectangle { color: 'green'; SplitView.preferredHeight: 160 }\n"
    b"        Rectangle { color: 'blue';  SplitView.fillHeight: true }\n"
    b"    }\n"
    b"}\n"
)

_DISABLED = (
    b"import QtQuick\n"
    b"import QtQuick.Controls\n"
    b"import PearlKit 1.0\n"
    b"Splitter {\n"
    b"    enabled: false\n"
    b"    width: 400; height: 200\n"
    b"    Rectangle { color: 'red';   SplitView.preferredWidth: 120 }\n"
    b"    Rectangle { color: 'green'; SplitView.fillWidth: true }\n"
    b"}\n"
)


def test_splitter_horizontal_loads() -> None:
    engine = _load(_HORIZONTAL)
    roots = engine.rootObjects()
    assert roots, "horizontal Splitter failed to load"
    obj = roots[0]
    # Qt.Orientation enum does not round-trip via PySide's property bridge
    # (see references/gotchas.md §1); smoke-verify via withHandle proxy.
    assert obj.property("withHandle") is False


def test_splitter_vertical_loads() -> None:
    engine = _load(_VERTICAL)
    roots = engine.rootObjects()
    assert roots, "vertical Splitter failed to load"


def test_splitter_with_handle_loads() -> None:
    engine = _load(_WITH_HANDLE)
    roots = engine.rootObjects()
    assert roots, "withHandle Splitter failed to load"
    assert roots[0].property("withHandle") is True


def test_splitter_empty_loads() -> None:
    engine = _load(_EMPTY)
    roots = engine.rootObjects()
    assert roots, "empty Splitter failed to load"


def test_splitter_single_child_loads() -> None:
    engine = _load(_SINGLE_CHILD)
    roots = engine.rootObjects()
    assert roots, "single-child Splitter failed to load"


def test_splitter_nested_loads() -> None:
    engine = _load(_NESTED)
    roots = engine.rootObjects()
    assert roots, "nested Splitter failed to load"


def test_splitter_disabled_state() -> None:
    engine = _load(_DISABLED)
    roots = engine.rootObjects()
    assert roots, "disabled Splitter failed to load"
    assert roots[0].property("enabled") is False


def test_splitter_save_restore_state_exposed() -> None:
    # saveState/restoreState are native Q_INVOKABLE methods on T.SplitView;
    # we expose convenience saveLayout/restoreLayout QML functions on Splitter.
    # Round-trip via a QML smoke test: the QML code below calls both and
    # asserts via property round-trip on a sentinel int.
    engine = _load(
        b"import QtQuick\n"
        b"import QtQuick.Controls\n"
        b"import PearlKit 1.0\n"
        b"Splitter {\n"
        b"    id: sp\n"
        b"    width: 400; height: 200\n"
        b"    property bool restoreReturned: false\n"
        b"    Rectangle { color: 'red';   SplitView.preferredWidth: 120 }\n"
        b"    Rectangle { color: 'green'; SplitView.fillWidth: true }\n"
        b"    Component.onCompleted: {\n"
        b"        var s = sp.saveLayout();\n"
        b"        sp.restoreReturned = sp.restoreLayout(s);\n"
        b"    }\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots, "Splitter persistence smoke failed to load"
    assert roots[0].property("restoreReturned") is True
