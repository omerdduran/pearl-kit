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


def test_summary_grid_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSummaryGrid { }\n")
    roots = engine.rootObjects()
    assert roots, "default SummaryGrid failed to load"
    assert roots[0].property("eyebrow") == "YOUR SETUP"
    assert roots[0].property("columns") == 2


def test_summary_grid_with_model() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"SummaryGrid {\n"
        b'  eyebrow: "YOUR SETUP"\n'
        b"  model: [\n"
        b'    { "key": "NAME",       "value": "Dr. Kaya" },\n'
        b'    { "key": "LICENSE",    "value": "TR-DDS-21487" },\n'
        b'    { "key": "BRAND",      "value": "STRAUMANN BLT" },\n'
        b'    { "key": "CANAL MIN",  "value": "2.5 mm" },\n'
        b'    { "key": "COMPLIANCE", "value": "HIPAA/KVKK ON", "valueColor": "#047857" },\n'
        b'    { "key": "REGION",     "value": "EU-CENTRAL" }\n'
        b"  ]\n"
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots


def test_summary_grid_custom_eyebrow() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nSummaryGrid { eyebrow: "REVIEW" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("eyebrow") == "REVIEW"
