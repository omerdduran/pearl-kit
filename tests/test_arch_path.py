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


def test_arch_path_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nArchPath { }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("editing") is False


def test_arch_path_with_points_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"ArchPath { points: [ { x: 10, y: 20 }, { x: 50, y: 40 }, { x: 100, y: 30 } ]; editing: true }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("editing") is True
    pts = roots[0].property("points")
    # QJSValue property → toVariant for concrete value; tests only assert load.
    assert pts is not None
