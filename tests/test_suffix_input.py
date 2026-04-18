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


def test_suffix_input_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSuffixInput { }\n")
    roots = engine.rootObjects()
    assert roots, "default SuffixInput failed to load"
    assert roots[0].property("implicitHeight") == 32
    assert roots[0].property("mono") is False
    assert roots[0].property("suffix") == ""


def test_suffix_input_with_suffix() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nSuffixInput { suffix: "MM" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("suffix") == "MM"


def test_suffix_input_mono_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'SuffixInput { mono: true; text: "DALI-WORKSTATION" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("mono") is True
    assert roots[0].property("text") == "DALI-WORKSTATION"
