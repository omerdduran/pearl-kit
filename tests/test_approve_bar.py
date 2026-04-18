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


def test_approve_bar_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nApproveBar { }\n")
    roots = engine.rootObjects()
    assert roots, "default ApproveBar failed to load"
    assert roots[0].property("implicitHeight") == 56
    assert roots[0].property("signed") is False


def test_approve_bar_progress_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nApproveBar { acknowledged: 3; total: 5 }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("acknowledged") == 3
    assert roots[0].property("total") == 5


def test_approve_bar_signed_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"ApproveBar { acknowledged: 5; total: 5; signed: true }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("signed") is True
