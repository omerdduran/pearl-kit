import sys

from PySide6.QtCore import QObject
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def _load(qml: bytes) -> QQmlApplicationEngine:
    import pearl_kit

    _ = QGuiApplication.instance() or QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(qml)
    return engine


def test_tabbar_default_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"TabBar {\n"
        b'  TabButton { text: "One" }\n'
        b'  TabButton { text: "Two" }\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots, "default TabBar failed to load"
    bar = roots[0]
    assert bar.property("implicitHeight") == 36
    assert bar.property("count") == 2
    assert bar.property("variant") == "default"
    assert bar.property("expanding") is True


def test_tabbar_variants_load() -> None:
    for variant in ("default", "line"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'TabBar {{ variant: "{variant}"; TabButton {{ text: "t" }} }}\n'.encode()
        )
        roots = engine.rootObjects()
        assert roots, f"variant={variant} failed to load"
        assert roots[0].property("variant") == variant


def test_tabbar_expanding_toggle() -> None:
    for flag in ("true", "false"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'TabBar {{ expanding: {flag}; TabButton {{ text: "x" }} }}\n'.encode()
        )
        roots = engine.rootObjects()
        assert roots, f"expanding={flag} failed to load"
        assert roots[0].property("expanding") == (flag == "true")


def test_tabbutton_closable_property_round_trip() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nTabButton { text: "A"; closable: true }\n'
    )
    roots = engine.rootObjects()
    assert roots
    btn = roots[0]
    assert btn.property("closable") is True
    assert btn.property("text") == "A"


def test_tabbutton_default_not_closable() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nTabButton { text: "A" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("closable") is False


def test_tabbutton_icon_source_round_trip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'TabButton { text: "Home"; iconSource: "qrc:/does-not-exist.svg" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("text") == "Home"


def test_tabbar_closable_child_via_findchild() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"TabBar {\n"
        b'  TabButton { objectName: "closableTab"; text: "A"; closable: true }\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    btn = roots[0].findChild(QObject, "closableTab")
    assert btn is not None
    assert btn.property("closable") is True


def test_tabbar_current_index_round_trip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"TabBar {\n"
        b"  currentIndex: 1\n"
        b'  TabButton { text: "One" }\n'
        b'  TabButton { text: "Two" }\n'
        b'  TabButton { text: "Three" }\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("currentIndex") == 1


def test_tabbar_disabled_state() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nTabBar { enabled: false; TabButton { text: "x" } }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False
