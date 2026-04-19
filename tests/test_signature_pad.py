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


def test_signature_pad_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSignaturePad { }\n")
    roots = engine.rootObjects()
    assert roots, "default SignaturePad failed to load"
    assert roots[0].property("signed") is False
    assert roots[0].property("placeholder") == "DRAW SIGNATURE"
    assert roots[0].property("drawLabel") == "OPEN CANVAS"
    assert roots[0].property("redrawLabel") == "REDRAW"


def test_signature_pad_signed_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'SignaturePad { signed: true; signatureText: "M.K. Kaya" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("signed") is True
    assert roots[0].property("signatureText") == "M.K. Kaya"


def test_signature_pad_signed_round_trip() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSignaturePad { }\n")
    roots = engine.rootObjects()
    assert roots
    roots[0].setProperty("signed", True)
    assert roots[0].property("signed") is True
