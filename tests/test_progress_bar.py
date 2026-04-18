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


def test_progress_bar_default_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nProgressBar { }\n",
    )
    roots = engine.rootObjects()
    assert roots, "default ProgressBar failed to load"
    obj = roots[0]
    assert obj.property("implicitHeight") == 8
    assert obj.property("implicitWidth") == 200
    assert obj.property("from") == 0
    assert obj.property("to") == 100
    assert obj.property("value") == 0
    assert obj.property("indeterminate") is False


def test_progress_bar_value_round_trips() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nProgressBar { value: 42 }\n",
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("value") == 42
    obj.setProperty("value", 75)
    assert obj.property("value") == 75


def test_progress_bar_full_value_visual_position() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nProgressBar { value: 100 }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("visualPosition") == 1.0


def test_progress_bar_indeterminate_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nProgressBar { indeterminate: true }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("indeterminate") is True


def test_progress_bar_custom_range() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nProgressBar { from: 0; to: 1024; value: 256 }\n",
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("from") == 0
    assert obj.property("to") == 1024
    assert obj.property("value") == 256
    assert abs(obj.property("visualPosition") - 0.25) < 1e-6


def test_progress_bar_disabled_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nProgressBar { enabled: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False
