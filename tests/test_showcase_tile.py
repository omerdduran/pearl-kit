"""Tests for ShowcaseTile primitive — Card-based sample container for the categorized showcase."""

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


def test_showcase_tile_default_loads() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcaseTile {
            width: 280
            label: "Primary"
        }
        """
    )
    assert engine.rootObjects()


def test_showcase_tile_with_sample_and_description() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcaseTile {
            width: 280
            label: "Primary"
            description: "Default click-through call to action"
            Rectangle { width: 100; height: 32; color: "red" }
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    tile = objs[0]
    assert tile.property("label") == "Primary"
    assert tile.property("description") == "Default click-through call to action"


def test_showcase_tile_empty_description_is_silent() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcaseTile {
            width: 280
            label: "Only Label"
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    tile = objs[0]
    assert tile.property("description") == ""


def test_showcase_tile_apply_theme_runtime_override_does_not_crash() -> None:
    """Overriding Tokens at runtime should re-render the tile without crashing.

    This pre-validates the DALI integration path where applyTheme() is called
    after register_qml() to swap in Penpot-sourced values.
    """
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        Item {
            width: 320
            height: 200
            ShowcaseTile {
                anchors.fill: parent
                label: "Primary"
                description: "Token override smoke"
            }
            Component.onCompleted: {
                Tokens.applyTheme({ radius: { md: 16 }, space: { x5: 24 } })
            }
        }
        """
    )
    assert engine.rootObjects()
