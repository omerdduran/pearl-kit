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


def test_spinner_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSpinner { }\n")
    roots = engine.rootObjects()
    assert roots, "default Spinner failed to load"
    spinner = roots[0]
    assert spinner.property("implicitWidth") == 16
    assert spinner.property("implicitHeight") == 16
    assert spinner.property("running") is True
    assert spinner.property("duration") == 1000
    assert spinner.property("strokeWidth") == 2


def test_spinner_running_round_trips() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSpinner { running: false }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("running") is False


def test_spinner_custom_duration() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSpinner { duration: 500 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("duration") == 500


def test_spinner_stroke_width() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSpinner { strokeWidth: 3 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("strokeWidth") == 3


def test_spinner_explicit_size_respected() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSpinner { width: 32; height: 32 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("width") == 32
    assert roots[0].property("height") == 32


def test_spinner_color_property_exists() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSpinner { color: "#ff0000" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    color = roots[0].property("color")
    assert color is not None
    assert color.name().lower() == "#ff0000"
