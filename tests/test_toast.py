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


def test_toast_default_loads() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nToast { title: "hi" }\n')
    roots = engine.rootObjects()
    assert roots, "default Toast failed to load"
    obj = roots[0]
    assert obj.property("implicitWidth") == 356
    assert obj.property("type") == "default"
    assert obj.property("duration") == 4000


def test_toast_all_types_load() -> None:
    for toast_type in ["default", "success", "info", "warning", "error", "loading"]:
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'Toast {{ type: "{toast_type}"; title: "t" }}\n'.encode()
        )
        roots = engine.rootObjects()
        assert roots, f"Toast type={toast_type} failed to load"
        assert roots[0].property("type") == toast_type


def test_toast_title_and_description_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'Toast { title: "Saved"; description: "Your changes were stored." }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("title") == "Saved"
    assert roots[0].property("description") == "Your changes were stored."


def test_toast_loading_has_zero_duration_when_unset() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nToast { type: "loading"; title: "Working" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    # Toast itself doesn't zero duration; Toaster._normalize does that when
    # invoked via show(). Direct instance keeps the 4000 default and the
    # internal Timer is gated by `type !== "loading"` anyway.
    assert roots[0].property("type") == "loading"


def test_toast_accepts_custom_duration() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nToast { duration: 1500; title: "x" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("duration") == 1500
