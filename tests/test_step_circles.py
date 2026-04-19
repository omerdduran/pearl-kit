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


def test_step_circles_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStepCircles { }\n")
    roots = engine.rootObjects()
    assert roots, "default StepCircles failed to load"
    assert roots[0].property("currentIndex") == 0
    assert roots[0].property("labelMode") == "active"
    assert roots[0].property("circleSize") == 24


def test_step_circles_with_model() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"StepCircles {\n"
        b"  currentIndex: 2\n"
        b'  labelMode: "all"\n'
        b"  model: [\n"
        b'    { "n": "01", "label": "Welcome",  "sub": "Get started" },\n'
        b'    { "n": "02", "label": "Profile",  "sub": "Who you are" },\n'
        b'    { "n": "03", "label": "Clinical", "sub": "Defaults" },\n'
        b'    { "n": "04", "label": "AI",       "sub": "Privacy" },\n'
        b'    { "n": "05", "label": "Ready",    "sub": "Sample case" }\n'
        b"  ]\n"
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("currentIndex") == 2
    assert roots[0].property("labelMode") == "all"


def test_step_circles_label_modes() -> None:
    for mode in (b"active", b"all", b"none"):
        qml = b'import QtQuick\nimport PearlKit 1.0\nStepCircles { labelMode: "' + mode + b'" }\n'
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots
        assert roots[0].property("labelMode") == mode.decode()
