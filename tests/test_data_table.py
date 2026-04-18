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


def test_data_table_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nDataTable { }\n")
    roots = engine.rootObjects()
    assert roots, "default DataTable failed to load"
    assert roots[0].property("headerHeight") == 30
    assert roots[0].property("rowHeight") == 32


def test_data_table_three_cols_four_rows() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"DataTable {\n"
        b"  columns: [\n"
        b'    { "key": "id",    "label": "ID" },\n'
        b'    { "key": "tooth", "label": "TOOTH" },\n'
        b'    { "key": "brand", "label": "BRAND", "mono": false }\n'
        b"  ]\n"
        b"  rows: [\n"
        b'    { "id": "I1", "tooth": "#22", "brand": "Straumann" },\n'
        b'    { "id": "I2", "tooth": "#23", "brand": "Straumann" },\n'
        b'    { "id": "I3", "tooth": "#24", "brand": "Nobel" },\n'
        b'    { "id": "I4", "tooth": "#25", "brand": "Nobel" }\n'
        b"  ]\n"
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots


def test_data_table_custom_heights() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nDataTable { headerHeight: 40; rowHeight: 44 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("headerHeight") == 40
    assert roots[0].property("rowHeight") == 44
