import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

VARIANTS = ["default", "destructive", "outline", "secondary", "ghost", "link"]
SIZES = {"default": 36, "xs": 24, "sm": 32, "lg": 40, "icon": 36}


def _load(qml: bytes) -> QQmlApplicationEngine:
    import pearl_kit

    _ = QGuiApplication.instance() or QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(qml)
    return engine


def test_button_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nButton { text: 'Hi' }\n")
    roots = engine.rootObjects()
    assert roots, "default Button failed to load"
    btn = roots[0]
    assert btn.property("implicitHeight") == 36
    assert btn.property("implicitWidth") > 0


def test_button_all_variants_load() -> None:
    for v in VARIANTS:
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'Button {{ text: "x"; variant: "{v}" }}\n'.encode()
        )
        assert engine.rootObjects(), f"variant={v} failed to load"


def test_button_all_sizes_have_correct_height() -> None:
    for sz, expected_h in SIZES.items():
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'Button {{ text: "x"; size: "{sz}" }}\n'.encode()
        )
        roots = engine.rootObjects()
        assert roots, f"size={sz} failed to load"
        actual = roots[0].property("implicitHeight")
        assert actual == expected_h, f"size={sz} expected h={expected_h}, got {actual}"


def test_button_icon_only_is_square() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nButton { size: "icon" }\n')
    roots = engine.rootObjects()
    assert roots, "icon button failed to load"
    btn = roots[0]
    assert btn.property("implicitWidth") == btn.property("implicitHeight") == 36
