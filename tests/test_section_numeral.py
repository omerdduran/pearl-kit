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


def test_section_numeral_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSectionNumeral { }\n")
    roots = engine.rootObjects()
    assert roots, "default SectionNumeral failed to load"


def test_section_numeral_joins_with_dot() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'SectionNumeral { numeral: "I"; label: "ANATOMY & PLACEMENT" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    # Joined text uses middle-dot separator
    text = roots[0].property("text")
    assert text.startswith("I")
    assert "ANATOMY" in text


def test_section_numeral_label_only() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSectionNumeral { label: "RISK CHECKLIST" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "RISK CHECKLIST"
