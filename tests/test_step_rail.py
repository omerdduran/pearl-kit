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


def test_step_rail_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStepRail { }\n")
    roots = engine.rootObjects()
    assert roots, "default StepRail failed to load"
    assert roots[0].property("currentIndex") == 0
    assert roots[0].property("circleSize") == 24
    assert roots[0].property("implicitWidth") == 280


def test_step_rail_with_model() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"StepRail {\n"
        b"  currentIndex: 1\n"
        b"  model: [\n"
        b'    { "n": "01", "label": "Welcome",  "sub": "Get started"   },\n'
        b'    { "n": "02", "label": "Profile",  "sub": "Who you are"   },\n'
        b'    { "n": "03", "label": "Clinical", "sub": "Your defaults" }\n'
        b"  ]\n"
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("currentIndex") == 1


def test_step_rail_empty_model() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStepRail { model: [] }\n")
    roots = engine.rootObjects()
    assert roots
