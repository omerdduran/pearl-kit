from __future__ import annotations

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


def test_menubar_default_loads() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
Item {
    width: 400; height: 40
    MenuBar {
        anchors.fill: parent
        Menu { title: "&File"; MenuItem { text: "&New" } }
        Menu { title: "&View" }
    }
}
"""
    )
    roots = engine.rootObjects()
    assert roots, "MenuBar failed to load"


def test_menubar_implicit_height() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuBar {
    Menu { title: "File"; MenuItem { text: "New" } }
}
"""
    )
    bar = engine.rootObjects()[0]
    assert bar.property("implicitHeight") == 36


def test_menu_default_loads() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
Menu {
    MenuItem { text: "Copy" }
    MenuItem { text: "Paste" }
}
"""
    )
    roots = engine.rootObjects()
    assert roots, "Menu failed to load"


def test_menu_minimum_width_default() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
Menu { MenuItem { text: "Item" } }
"""
    )
    m = engine.rootObjects()[0]
    assert m.property("minimumWidth") == 192


def test_menuitem_default_loads() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuItem { text: "Hello" }
"""
    )
    roots = engine.rootObjects()
    assert roots, "MenuItem failed to load"


def test_menuitem_implicit_height() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuItem { text: "Hello" }
"""
    )
    item = engine.rootObjects()[0]
    assert item.property("implicitHeight") == 32


def test_menuitem_shortcut_roundtrip() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuItem { text: "New File"; shortcut: "Cmd+N" }
"""
    )
    item = engine.rootObjects()[0]
    assert item.property("shortcut") == "Cmd+N"


def test_menuitem_variants_load() -> None:
    for variant in ("default", "destructive"):
        engine = _load(
            f"""
import QtQuick
import PearlKit 1.0
MenuItem {{ text: "T"; variant: "{variant}" }}
""".encode()
        )
        assert engine.rootObjects(), f"MenuItem variant={variant} failed"


def test_menuitem_checkable_roundtrip() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuItem { text: "Show Toolbar"; checkable: true; checked: true }
"""
    )
    item = engine.rootObjects()[0]
    assert item.property("checkable") is True
    assert item.property("checked") is True


def test_menuitem_radio_flag_roundtrip() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuItem { text: "List"; checkable: true; checked: true; radio: true }
"""
    )
    item = engine.rootObjects()[0]
    assert item.property("radio") is True


def test_menuitem_inset_roundtrip() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuItem { text: "Hello"; inset: true }
"""
    )
    item = engine.rootObjects()[0]
    assert item.property("inset") is True


def test_menuitem_icon_source_roundtrip() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuItem { text: "Open"; iconSource: "qrc:/icons/folder.svg" }
"""
    )
    item = engine.rootObjects()[0]
    assert item.property("iconSource").toString().endswith("folder.svg")


def test_menuitem_disabled_loads() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuItem { text: "Unavailable"; enabled: false }
"""
    )
    item = engine.rootObjects()[0]
    assert item.property("enabled") is False


def test_menuseparator_default_loads() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuSeparator {}
"""
    )
    roots = engine.rootObjects()
    assert roots, "MenuSeparator failed to load"


def test_menuseparator_padding() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
MenuSeparator {}
"""
    )
    sep = engine.rootObjects()[0]
    assert sep.property("topPadding") == 4
    assert sep.property("bottomPadding") == 4


def test_menu_with_submenu_loads() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
Menu {
    MenuItem { text: "Open" }
    MenuSeparator {}
    Menu {
        title: "Recent"
        MenuItem { text: "a.txt" }
        MenuItem { text: "b.txt" }
    }
    MenuItem { text: "Delete"; variant: "destructive" }
}
"""
    )
    assert engine.rootObjects(), "nested Menu with submenu failed"


def test_full_menubar_composition_loads() -> None:
    engine = _load(
        b"""
import QtQuick
import PearlKit 1.0
Item {
    width: 800; height: 40
    MenuBar {
        anchors.fill: parent
        Menu {
            title: "&File"
            MenuItem { text: "&New File"; shortcut: "Cmd+N" }
            MenuItem { text: "&Open..."; shortcut: "Cmd+O" }
            MenuSeparator {}
            MenuItem { text: "&Close"; shortcut: "Cmd+W" }
            MenuItem { text: "&Quit"; shortcut: "Cmd+Q"; variant: "destructive" }
        }
        Menu {
            title: "&View"
            MenuItem { text: "Show &Toolbar"; checkable: true; checked: true }
            MenuSeparator {}
            MenuItem { text: "&List";    checkable: true; checked: true; radio: true }
            MenuItem { text: "&Grid";    checkable: true; radio: true }
            MenuItem { text: "&Gallery"; checkable: true; radio: true }
        }
        Menu {
            title: "&Tools"
            MenuItem { text: "&Preferences"; shortcut: "Cmd+," }
            Menu {
                title: "&Export"
                MenuItem { text: "PDF" }
                MenuItem { text: "PNG" }
            }
        }
        Menu {
            title: "&Help"
            MenuItem { text: "&About" }
        }
    }
}
"""
    )
    assert engine.rootObjects(), "full menubar composition failed"
