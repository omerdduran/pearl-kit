import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

SIZES = {"default": 32, "sm": 28, "lg": 48}


def _load(qml: bytes) -> QQmlApplicationEngine:
    import pearl_kit

    _ = QGuiApplication.instance() or QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(qml)
    return engine


def test_nav_item_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nNavItem { text: 'General' }\n")
    roots = engine.rootObjects()
    assert roots, "default NavItem failed to load"
    item = roots[0]
    assert item.property("implicitHeight") == 32
    assert item.property("implicitWidth") > 0
    assert item.property("active") is False


def test_nav_item_all_sizes_have_correct_height() -> None:
    for sz, expected_h in SIZES.items():
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'NavItem {{ text: "x"; size: "{sz}" }}\n'.encode()
        )
        roots = engine.rootObjects()
        assert roots, f"size={sz} failed to load"
        actual = roots[0].property("implicitHeight")
        assert actual == expected_h, f"size={sz} expected h={expected_h}, got {actual}"


def test_nav_item_active_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nNavItem { text: 'Appearance'; active: true }\n"
    )
    roots = engine.rootObjects()
    assert roots, "active NavItem failed to load"
    assert roots[0].property("active") is True


def test_nav_item_disabled_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nNavItem { text: 'Off'; enabled: false }\n"
    )
    roots = engine.rootObjects()
    assert roots, "disabled NavItem failed to load"
    assert roots[0].property("enabled") is False


def test_nav_item_with_icons_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"NavItem { text: 'Files'; iconLeft: 'icon:/dummy.svg'; iconRight: 'icon:/chev.svg' }\n"
    )
    roots = engine.rootObjects()
    assert roots, "NavItem with icons failed to load"
    item = roots[0]
    assert item.property("iconLeft").toString().endswith("dummy.svg")
    assert item.property("iconRight").toString().endswith("chev.svg")


def test_nav_item_text_only_no_icons_still_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nNavItem { text: 'Plain' }\n")
    roots = engine.rootObjects()
    assert roots, "plain NavItem failed to load"
