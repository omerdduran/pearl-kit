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


def test_toggle_default_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nToggle { }\n",
    )
    roots = engine.rootObjects()
    assert roots, "default Toggle failed to load"
    obj = roots[0]
    assert obj.property("implicitWidth") == 32
    assert obj.property("implicitHeight") == 18
    assert obj.property("checked") is False


def test_toggle_sm_size() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nToggle { size: "sm" }\n',
    )
    roots = engine.rootObjects()
    assert roots, "sm Toggle failed to load"
    obj = roots[0]
    assert obj.property("implicitWidth") == 24
    assert obj.property("implicitHeight") == 14


def test_toggle_checked_state_toggle() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nToggle { checked: true }\n",
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("checked") is True
    obj.setProperty("checked", False)
    assert obj.property("checked") is False


def test_toggle_disabled_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nToggle { enabled: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_toggle_all_sizes_load() -> None:
    for s in ("sm", "default"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n" + f'Toggle {{ size: "{s}" }}\n'.encode(),
        )
        assert engine.rootObjects(), f"size={s} failed to load"
