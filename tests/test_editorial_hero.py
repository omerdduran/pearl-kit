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


def test_editorial_hero_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nEditorialHero { }\n")
    roots = engine.rootObjects()
    assert roots, "default EditorialHero failed to load"
    assert roots[0].property("padTop") == 40
    assert roots[0].property("padLeft") == 60


def test_editorial_hero_full_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"EditorialHero {\n"
        b'  eyebrow: "REPORT - 2041-04"\n'
        b'  headline: "A dual-implant plan for the upper left quadrant."\n'
        b'  subLine: "One planned restoration, one flagged risk."\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("eyebrow") == "REPORT - 2041-04"
    assert roots[0].property("headline").startswith("A dual-implant")
