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


def test_signature_preview_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSignaturePreview { }\n")
    roots = engine.rootObjects()
    assert roots, "default SignaturePreview failed to load"
    assert roots[0].property("actionLabel") == "REDRAW"


def test_signature_preview_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'SignaturePreview { text: "M.Kaya"; actionLabel: "CHANGE" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "M.Kaya"
    assert roots[0].property("actionLabel") == "CHANGE"
