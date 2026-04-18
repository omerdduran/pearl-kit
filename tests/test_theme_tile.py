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


def test_theme_tile_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nThemeTile { }\n")
    roots = engine.rootObjects()
    assert roots, "default ThemeTile failed to load"
    assert roots[0].property("implicitWidth") == 120
    assert roots[0].property("previewGlyph") == "Aa"


def test_theme_tile_checked_and_label() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nThemeTile { label: "Light"; checked: true }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("label") == "Light"
    assert roots[0].property("checked") is True


def test_theme_tile_custom_glyph() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nThemeTile { previewGlyph: "Ab" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("previewGlyph") == "Ab"
