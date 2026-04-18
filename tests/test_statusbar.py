import sys

from PySide6.QtGui import QColor, QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def _load(qml: bytes) -> QQmlApplicationEngine:
    import pearl_kit

    _ = QGuiApplication.instance() or QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(qml)
    return engine


def test_statusbar_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStatusBar { }\n")
    roots = engine.rootObjects()
    assert roots, "default StatusBar failed to load"
    obj = roots[0]
    assert obj.property("implicitHeight") == 28
    assert obj.property("implicitWidth") == 480
    assert obj.property("statusKind") == "default"
    assert obj.property("hpad") == 12
    assert obj.property("enabled") is True


def test_statusbar_all_status_kinds_load() -> None:
    for kind in ("default", "success", "warning", "error"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'StatusBar {{ statusKind: "{kind}" }}\n'.encode(),
        )
        roots = engine.rootObjects()
        assert roots, f"statusKind={kind} failed to load"
        assert roots[0].property("statusKind") == kind


def test_statusbar_status_color_mapping() -> None:
    # Each statusKind must resolve to a distinct non-transparent color.
    colors: dict[str, QColor] = {}
    for kind in ("default", "success", "warning", "error"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'StatusBar {{ statusKind: "{kind}" }}\n'.encode(),
        )
        c = engine.rootObjects()[0].property("statusColor")
        assert isinstance(c, QColor)
        assert c.alpha() > 0
        colors[kind] = c

    # success / warning / error must differ from default and from each other.
    assert colors["default"] != colors["success"]
    assert colors["success"] != colors["warning"]
    assert colors["warning"] != colors["error"]
    assert colors["error"] != colors["default"]


def test_statusbar_content_slots_populate() -> None:
    engine = _load(
        b"import QtQuick\n"
        b"import PearlKit 1.0\n"
        b"StatusBar {\n"
        b'    leftContent: PearlText { text: "ready" }\n'
        b'    centerContent: PearlText { text: "14.2 px" }\n'
        b'    rightContent: PearlText { text: "saved" }\n'
        b"}\n",
    )
    roots = engine.rootObjects()
    assert roots, "StatusBar with three Component slots failed to load"


def test_statusbar_hpad_override() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nStatusBar { hpad: 20 }\n",
    )
    obj = engine.rootObjects()[0]
    assert obj.property("hpad") == 20


def test_statusbar_disabled_state() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nStatusBar { enabled: false }\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False
