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
    b'FloatingWindow { title: "Detached View"; width: 480; height: 320 }\n'
)


def test_floating_window_default_loads() -> None:
    engine = _load(_DEFAULT)
    roots = engine.rootObjects()
    assert roots, "default FloatingWindow failed to load"
    win = roots[0]
    assert win.property("title") == "Detached View"
    assert win.property("minWidth") == 400
    assert win.property("minHeight") == 300


def test_floating_window_title_round_trip() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nFloatingWindow { title: "Viewer"; width: 500; height: 400 }\n'
    )
    roots = engine.rootObjects()
    assert roots
    win = roots[0]
    win.setProperty("title", "Renamed")
    assert win.property("title") == "Renamed"


def test_floating_window_content_reparents() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Item {\n"
        b"    id: root\n"
        b"    width: 100; height: 100\n"
        b"    property Item reparented: null\n"
        b"    property bool matches: false\n"
        b'    FloatingWindow { id: win; title: "T"; width: 500; height: 400 }\n'
        b'    Rectangle { id: payload; objectName: "payload"; width: 50; height: 50 }\n'
        b"    Component.onCompleted: {\n"
        b"        win.content = payload\n"
        b"        reparented = payload.parent\n"
        b'        matches = (payload.parent && payload.parent.objectName === "contentArea")\n'
        b"    }\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("matches") is True


def test_floating_window_min_dimensions_round_trip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'FloatingWindow { title: "x"; width: 600; height: 500;'
        b" minWidth: 320; minHeight: 240 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    win = roots[0]
    assert win.property("minWidth") == 320
    assert win.property("minHeight") == 240
