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


def test_audit_log_row_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nAuditLogRow { }\n")
    roots = engine.rootObjects()
    assert roots, "default AuditLogRow failed to load"
    assert roots[0].property("implicitHeight") == 36
    assert roots[0].property("severity") == "info"


def test_audit_log_row_all_severities_load() -> None:
    for s in ("ok", "info", "warn"):
        qml = (
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'AuditLogRow {{ severity: "{s}" }}\n'.encode()
        )
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots, f"severity={s} failed to load"
        assert roots[0].property("severity") == s


def test_audit_log_row_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'AuditLogRow { time: "14:32"; date: "Today"; event: "Signed plan" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("time") == "14:32"
    assert roots[0].property("date") == "Today"
    assert roots[0].property("event") == "Signed plan"
