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


def test_group_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nGroup { }\n")
    roots = engine.rootObjects()
    assert roots, "default Group failed to load"


def test_group_with_title() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nGroup { title: "CLINICAL EVENTS" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("title") == "CLINICAL EVENTS"
