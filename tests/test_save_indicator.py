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


def test_save_indicator_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSaveIndicator { }\n")
    roots = engine.rootObjects()
    assert roots, "default SaveIndicator failed to load"
    assert roots[0].property("state") == "saved"


def test_save_indicator_all_states_load() -> None:
    for s in ("saved", "saving", "error", "offline"):
        qml = (
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'SaveIndicator {{ state: "{s}"; text: "Saved" }}\n'.encode()
        )
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots, f"state={s} failed to load"
        assert roots[0].property("state") == s


def test_save_indicator_text_roundtrips() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSaveIndicator { text: "Saved \xc2\xb7 14:32" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "Saved \u00b7 14:32"
