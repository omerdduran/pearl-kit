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


def test_settings_toggle_card_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSettingsToggleCard { }\n")
    roots = engine.rootObjects()
    assert roots, "default SettingsToggleCard failed to load"
    assert roots[0].property("checked") is False
    assert roots[0].property("highlighted") is False
    assert roots[0].property("locked") is False


def test_settings_toggle_card_highlighted_with_badge() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"SettingsToggleCard {\n"
        b'  title: "HIPAA / KVKK compliance"\n'
        b'  description: "All DICOM stays on the workstation."\n'
        b'  badgeText: "RECOMMENDED"\n'
        b"  checked: true\n"
        b"  highlighted: true\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("title") == "HIPAA / KVKK compliance"
    assert roots[0].property("badgeText") == "RECOMMENDED"
    assert roots[0].property("checked") is True
    assert roots[0].property("highlighted") is True


def test_settings_toggle_card_locked() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSettingsToggleCard { locked: true; title: "Cloud" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("locked") is True
