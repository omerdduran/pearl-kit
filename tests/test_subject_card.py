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


def test_subject_card_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSubjectCard { }\n")
    roots = engine.rootObjects()
    assert roots, "default SubjectCard failed to load"
    assert roots[0].property("status") == "ok"


def test_subject_card_full_payload() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"SubjectCard {\n"
        b'  identifier: "I1"\n'
        b'  tooth: "#22"\n'
        b'  brand: "Straumann BLT"\n'
        b'  status: "ok"\n'
        b"  parameters: [\n"
        b'    { "key": "Dia",    "value": "4.1" },\n'
        b'    { "key": "Length", "value": "10 mm" },\n'
        b'    { "key": "Angle",  "value": "4" },\n'
        b'    { "key": "Bone",   "value": "D2" }\n'
        b"  ]\n"
        b"  metrics: [\n"
        b'    { "key": "IAN",   "value": "3.2 mm", "tone": "ok" },\n'
        b'    { "key": "Sinus", "value": "4.8 mm", "tone": "ok" }\n'
        b"  ]\n"
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("identifier") == "I1"
    assert roots[0].property("brand") == "Straumann BLT"


def test_subject_card_warn_status() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nSubjectCard { status: "warn" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("status") == "warn"
