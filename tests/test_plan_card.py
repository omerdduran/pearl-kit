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


def test_plan_card_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nPlanCard { }\n")
    roots = engine.rootObjects()
    assert roots, "default PlanCard failed to load"
    assert roots[0].property("eyebrow") == "CURRENT"
    assert roots[0].property("actionLabel") == "UPGRADE"


def test_plan_card_full_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"PlanCard {\n"
        b'  title: "Solo Clinician"\n'
        b'  price: "EUR 180"\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("title") == "Solo Clinician"
    assert roots[0].property("price") == "EUR 180"
