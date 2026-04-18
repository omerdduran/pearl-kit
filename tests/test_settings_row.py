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


def test_settings_row_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSettingsRow { }\n")
    roots = engine.rootObjects()
    assert roots, "default SettingsRow failed to load"
    assert roots[0].property("inline") is True
    assert roots[0].property("labelWidth") == 200


def test_settings_row_with_label_and_hint() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'SettingsRow { label: "Full name"; hint: "Shown in reports" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("label") == "Full name"
    assert roots[0].property("hint") == "Shown in reports"


def test_settings_row_non_inline() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSettingsRow { inline: false; label: "Notes" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("inline") is False
