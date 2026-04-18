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


def test_numbered_nav_item_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nNumberedNavItem { }\n")
    roots = engine.rootObjects()
    assert roots, "default NumberedNavItem failed to load"
    assert roots[0].property("implicitHeight") == 48
    assert roots[0].property("checked") is False


def test_numbered_nav_item_full_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'NumberedNavItem { index: "03"; label: "Viewer"; subtitle: "Layout - tools"; checked: true }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("index") == "03"
    assert roots[0].property("label") == "Viewer"
    assert roots[0].property("subtitle") == "Layout - tools"
    assert roots[0].property("checked") is True
