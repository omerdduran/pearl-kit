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


def test_connection_status_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nConnectionStatus { }\n")
    roots = engine.rootObjects()
    assert roots, "default ConnectionStatus failed to load"
    assert roots[0].property("state") == "online"


def test_connection_status_all_states_load() -> None:
    for s in ("online", "offline", "error"):
        qml = (
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'ConnectionStatus {{ state: "{s}" }}\n'.encode()
        )
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots, f"state={s} failed to load"
        assert roots[0].property("state") == s


def test_connection_status_custom_label() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'ConnectionStatus { state: "online"; label: "LIVE"; caption: "last echo 2s ago" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("label") == "LIVE"
    assert roots[0].property("caption") == "last echo 2s ago"
