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


def test_settings_header_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSettingsHeader { }\n")
    roots = engine.rootObjects()
    assert roots, "default SettingsHeader failed to load"


def test_settings_header_full_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"SettingsHeader {\n"
        b'  eyebrow: "02 - CLINICAL"\n'
        b'  title: "Clinical preferences"\n'
        b'  description: "Defaults applied to every new case."\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("eyebrow") == "02 - CLINICAL"
    assert roots[0].property("title") == "Clinical preferences"
    assert roots[0].property("description") == "Defaults applied to every new case."
