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


def test_pull_quote_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nPullQuote { }\n")
    roots = engine.rootObjects()
    assert roots, "default PullQuote failed to load"
    assert roots[0].property("maxWidth") == 720
    assert roots[0].property("quoteGlyph") == "\u201c"


def test_pull_quote_text_roundtrips() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'PullQuote { text: "Both fixtures seat in D2 bone." }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "Both fixtures seat in D2 bone."


def test_pull_quote_custom_glyph() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nPullQuote { quoteGlyph: "*" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("quoteGlyph") == "*"
