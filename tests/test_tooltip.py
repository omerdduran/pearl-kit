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


def test_tooltip_default_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nTooltip { }\n",
    )
    roots = engine.rootObjects()
    assert roots, "default Tooltip failed to load"
    obj = roots[0]
    assert obj.property("placement") == "top"
    assert obj.property("maxWidth") == 320
    assert obj.property("delay") == 0
    assert obj.property("timeout") == -1
    assert obj.property("focus") is False


def test_tooltip_text_propagation() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nTooltip { text: "Save file" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "Save file"


def test_tooltip_all_placements_load() -> None:
    for placement in ("top", "bottom", "left", "right"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'Tooltip {{ placement: "{placement}" }}\n'.encode()
        )
        roots = engine.rootObjects()
        assert roots, f"placement={placement} failed to load"
        assert roots[0].property("placement") == placement


def test_tooltip_delay_override() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nTooltip { delay: 500 }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("delay") == 500


def test_tooltip_max_width_override() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nTooltip { maxWidth: 200 }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("maxWidth") == 200


def test_tooltip_inside_button_scenario() -> None:
    engine = _load(
        b"import QtQuick\n"
        b"import QtQuick.Controls\n"
        b"import PearlKit 1.0\n"
        b"ApplicationWindow {\n"
        b"  width: 300; height: 200; visible: true\n"
        b"  Button {\n"
        b"    id: btn; text: 'Save'\n"
        b'    Tooltip { id: tt; parent: btn; text: "Save file"; visible: btn.hovered }\n'
        b"  }\n"
        b"}\n",
    )
    roots = engine.rootObjects()
    assert roots


def test_tooltip_disabled_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nTooltip { enabled: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False
