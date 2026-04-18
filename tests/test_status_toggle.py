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


def test_status_toggle_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStatusToggle { }\n")
    roots = engine.rootObjects()
    assert roots, "default StatusToggle failed to load"
    assert roots[0].property("checked") is False
    assert roots[0].property("labelOn") == "ON"
    assert roots[0].property("labelOff") == "OFF"


def test_status_toggle_checked_roundtrip() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStatusToggle { checked: true }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("checked") is True


def test_status_toggle_custom_labels() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'StatusToggle { labelOn: "Enabled"; labelOff: "Disabled" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("labelOn") == "Enabled"
    assert roots[0].property("labelOff") == "Disabled"
