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


def test_separator_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSeparator { }\n")
    roots = engine.rootObjects()
    assert roots, "default Separator failed to load"
    sep = roots[0]
    assert sep.property("orientation") == "horizontal"
    assert sep.property("decorative") is True
    assert sep.property("implicitHeight") == 1
    assert sep.property("implicitWidth") == 0


def test_separator_vertical_swaps_implicit_dimensions() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nSeparator { orientation: "vertical" }\n')
    roots = engine.rootObjects()
    assert roots, "vertical Separator failed to load"
    sep = roots[0]
    assert sep.property("orientation") == "vertical"
    assert sep.property("implicitHeight") == 0
    assert sep.property("implicitWidth") == 1


def test_separator_decorative_false_round_trips() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSeparator { decorative: false }\n")
    roots = engine.rootObjects()
    assert roots, "decorative=false Separator failed to load"
    assert roots[0].property("decorative") is False


def test_separator_explicit_width_respected() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSeparator { width: 240 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("width") == 240
    assert roots[0].property("height") == 1
