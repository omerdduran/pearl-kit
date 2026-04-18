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


def test_orientation_cube_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nOrientationCube { }\n")
    roots = engine.rootObjects()
    assert roots, "default OrientationCube failed to load"
    assert roots[0].property("implicitWidth") == 52
    assert roots[0].property("implicitHeight") == 52
    assert roots[0].property("rLabel") == "R"
    assert roots[0].property("lLabel") == "L"
    assert roots[0].property("sLabel") == "S"
    assert roots[0].property("iLabel") == "I"


def test_orientation_cube_custom_labels() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nOrientationCube { rLabel: "X"; lLabel: "Y" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("rLabel") == "X"
    assert roots[0].property("lLabel") == "Y"
