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


def test_text_annotation_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nTextAnnotation { }\n")
    roots = engine.rootObjects()
    assert roots, "default TextAnnotation failed to load"
    assert roots[0].property("editing") is False


def test_text_annotation_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'TextAnnotation { x_pos: 20; y_pos: 30; text: "IAN" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("x_pos") == 20
    assert roots[0].property("text") == "IAN"


def test_text_annotation_editing_mode_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nTextAnnotation { editing: true }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("editing") is True
