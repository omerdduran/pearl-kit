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


def test_sample_case_card_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSampleCaseCard { }\n")
    roots = engine.rootObjects()
    assert roots, "default SampleCaseCard failed to load"
    assert roots[0].property("previewMarkerCount") == 2
    assert roots[0].property("previewHeight") == 140


def test_sample_case_card_full_payload() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"SampleCaseCard {\n"
        b'  title: "Demo - Yilmaz, Ayse"\n'
        b'  caseId: "#0000-00"\n'
        b'  metaText: "MANDIBLE - TOOTH 36/37 - 2 IMPLANTS - STRAUMANN BLT"\n'
        b'  previewTopRightLabel: "142 / 512"\n'
        b"  metrics: [\n"
        b'    { "key": "SAFETY",  "value": "5 / 5 OK", "valueColor": "#047857" },\n'
        b'    { "key": "CANAL",   "value": "3.2 mm" },\n'
        b'    { "key": "AI TOUR", "value": "Enabled",  "valueColor": "#2563EB" }\n'
        b"  ]\n"
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("caseId") == "#0000-00"
    assert roots[0].property("previewTopRightLabel") == "142 / 512"
