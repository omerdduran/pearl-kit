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


def test_checklist_item_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nChecklistItem { }\n")
    roots = engine.rootObjects()
    assert roots, "default ChecklistItem failed to load"
    assert roots[0].property("severity") == "info"
    assert roots[0].property("checked") is False


def test_checklist_item_all_severities_load() -> None:
    for sev in ("warn", "info", "note"):
        qml = (
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'ChecklistItem {{ severity: "{sev}" }}\n'.encode()
        )
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots, f"severity={sev} failed to load"
        assert roots[0].property("severity") == sev


def test_checklist_item_checked_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'ChecklistItem { text: "IAN proximity"; body: "Below threshold."; checked: true }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("checked") is True
    assert roots[0].property("text") == "IAN proximity"
    assert roots[0].property("body") == "Below threshold."
