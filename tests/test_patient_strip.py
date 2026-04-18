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


def test_patient_strip_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nPatientStrip { }\n")
    roots = engine.rootObjects()
    assert roots, "default PatientStrip failed to load"
    assert roots[0].property("implicitHeight") == 48
    assert roots[0].property("showBackButton") is True


def test_patient_strip_full_payload() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"PatientStrip {\n"
        b'  name: "Yilmaz, Ayse"\n'
        b'  meta: "F 54 \xc2\xb7 #22 Single implant"\n'
        b'  segments: [{ "label": "Library" }, { "label": "Planning", "current": true }]\n'
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("name") == "Yilmaz, Ayse"


def test_patient_strip_back_hidden() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nPatientStrip { showBackButton: false }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("showBackButton") is False
