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


def test_toaster_host_loads_inside_application_window() -> None:
    engine = _load(
        b"""
import QtQuick
import QtQuick.Controls
import PearlKit 1.0

ApplicationWindow {
    width: 400
    height: 300
    ToasterHost { }
}
"""
    )
    roots = engine.rootObjects()
    assert roots, "ToasterHost inside ApplicationWindow failed to load"


def test_toaster_host_bare_item_warns_gracefully() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0

Item {
    ToasterHost { }
}
"""
    )
    roots = engine.rootObjects()
    assert roots, "ToasterHost without overlay must still not crash"
