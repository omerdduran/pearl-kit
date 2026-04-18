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


def test_safety_row_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSafetyRow { }\n")
    roots = engine.rootObjects()
    assert roots, "default SafetyRow failed to load"
    assert roots[0].property("unit") == "mm"


def test_safety_row_ok_state() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSafetyRow { label: "IAN"; value: 3.2; min: 2.0 }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("value") == 3.2
    assert roots[0].property("min") == 2.0


def test_safety_row_warn_state() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSafetyRow { label: "IAN"; value: 1.0; min: 2.0 }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("value") == 1.0
