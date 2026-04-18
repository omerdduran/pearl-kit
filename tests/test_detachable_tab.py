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


def test_detachable_tab_default_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'Item { width: 200; height: 200; DetachableTab { title: "x"; stackKey: "x" } }\n'
    )
    roots = engine.rootObjects()
    assert roots


def test_detachable_tab_properties_round_trip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Item {\n"
        b"    width: 200; height: 200\n"
        b"    DetachableTab {\n"
        b'        objectName: "tab"\n'
        b'        title: "Viewer"\n'
        b'        stackKey: "viewer"\n'
        b'        iconSource: "qrc:/icons/viewer.svg"\n'
        b"        permanent: true\n"
        b"    }\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    from PySide6.QtCore import QObject

    tab = roots[0].findChild(QObject, "tab")
    assert tab is not None
    assert tab.property("title") == "Viewer"
    assert tab.property("stackKey") == "viewer"
    assert tab.property("permanent") is True
    assert tab.property("nonDetachable") is False
    assert tab.property("isCurrent") is False
    assert tab.property("isFloating") is False


def test_detachable_tab_non_detachable_flag() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Item { width: 200; height: 200;"
        b' DetachableTab { objectName: "t"; title: "x"; stackKey: "x"; nonDetachable: true } }\n'
    )
    roots = engine.rootObjects()
    assert roots
    from PySide6.QtCore import QObject

    tab = roots[0].findChild(QObject, "t")
    assert tab is not None
    assert tab.property("nonDetachable") is True
