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


def test_subject_row_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSubjectRow { }\n")
    roots = engine.rootObjects()
    assert roots, "default SubjectRow failed to load"
    assert roots[0].property("identifier") == "I1"
    assert roots[0].property("status") == "neutral"
    assert roots[0].property("selected") is False


def test_subject_row_all_statuses_load() -> None:
    for s in ("ok", "warn", "info", "neutral"):
        qml = (
            b"import QtQuick\nimport PearlKit 1.0\n" + f'SubjectRow {{ status: "{s}" }}\n'.encode()
        )
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots, f"status={s} failed to load"
        assert roots[0].property("status") == s


def test_subject_row_selected_and_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'SubjectRow { identifier: "I2"; title: "#23 Straumann"; caption: "dia 3.3 x 10 mm"; selected: true }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("identifier") == "I2"
    assert roots[0].property("selected") is True
