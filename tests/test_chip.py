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


def test_chip_default_loads() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nChip { text: "Soft" }\n')
    roots = engine.rootObjects()
    assert roots, "default Chip failed to load"
    assert roots[0].property("variant") == "soft"
    assert roots[0].property("implicitHeight") == 22


def test_chip_outline_is_taller() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nChip { variant: "outline"; text: "APPLY" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("variant") == "outline"
    assert roots[0].property("implicitHeight") == 26


def test_chip_text_roundtrip() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nChip { text: "Risk summary" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "Risk summary"
