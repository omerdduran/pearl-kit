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


def test_storage_bar_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStorageBar { }\n")
    roots = engine.rootObjects()
    assert roots, "default StorageBar failed to load"
    assert roots[0].property("implicitWidth") == 340
    assert roots[0].property("unit") == "GB"


def test_storage_bar_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"StorageBar {\n"
        b"  used: 412\n"
        b"  total: 1247\n"
        b'  topLabel: "412 GB used"\n'
        b'  bottomLabel: "876 GB available"\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("used") == 412
    assert roots[0].property("total") == 1247


def test_storage_bar_zero_total_doesnt_crash() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStorageBar { used: 10; total: 0 }\n")
    roots = engine.rootObjects()
    assert roots
