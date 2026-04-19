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


def test_fact_grid_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nFactGrid { }\n")
    roots = engine.rootObjects()
    assert roots, "default FactGrid failed to load"
    assert roots[0].property("columns") == 2
    assert roots[0].property("cellPadding") == 14


def test_fact_grid_with_model() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"FactGrid {\n"
        b"  model: [\n"
        b'    { "key": "5 MIN", "value": "Typical setup",   "sub": "Skip anything optional" },\n'
        b'    { "key": "LOCAL", "value": "Data stays local","sub": "HIPAA / KVKK default" },\n'
        b'    { "key": "1,247", "value": "Clinicians",      "sub": "23 countries" },\n'
        b'    { "key": "3.2.1", "value": "Clinical build",  "sub": "Valid to 2027-04" }\n'
        b"  ]\n"
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots


def test_fact_grid_custom_columns() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nFactGrid { columns: 3 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("columns") == 3
