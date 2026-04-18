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


def test_ai_suggestion_card_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nAISuggestionCard { }\n")
    roots = engine.rootObjects()
    assert roots, "default AISuggestionCard failed to load"
    assert roots[0].property("title") == "AI suggests"


def test_ai_suggestion_card_full_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"AISuggestionCard {\n"
        b'  title: "AI suggests"\n'
        b'  modelTag: "dali-seg-v3.2"\n'
        b'  body: "Rotate -2 deg lingual to gain 0.6 mm clearance."\n'
        b'  actionLabel: "Apply suggestion"\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("modelTag") == "dali-seg-v3.2"
    assert roots[0].property("actionLabel") == "Apply suggestion"
