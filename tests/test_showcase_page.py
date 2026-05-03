"""Tests for ShowcasePage primitive — abstract base for showcase category pages."""

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


def test_showcase_page_default_loads() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcasePage {
            width: 800
            height: 600
            title: "Buttons"
            subtitle: "Primary actions across the app"
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    page = objs[0]
    assert page.property("title") == "Buttons"
    assert page.property("subtitle") == "Primary actions across the app"
    assert page.property("gridPreset") == "single-col"


def test_showcase_page_preset_single_col() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcasePage {
            width: 800
            height: 600
            title: "Typography"
            gridPreset: "single-col"
            ShowcaseTile { label: "A" }
            ShowcaseTile { label: "B" }
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    assert objs[0].property("gridPreset") == "single-col"


def test_showcase_page_preset_two_col() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcasePage {
            width: 800
            height: 600
            gridPreset: "two-col"
            ShowcaseTile { label: "L" }
            ShowcaseTile { label: "R" }
        }
        """
    )
    assert engine.rootObjects()


def test_showcase_page_preset_four_col() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcasePage {
            width: 1440
            height: 800
            gridPreset: "four-col"
            ShowcaseTile { label: "1" }
            ShowcaseTile { label: "2" }
            ShowcaseTile { label: "3" }
            ShowcaseTile { label: "4" }
        }
        """
    )
    assert engine.rootObjects()


def test_showcase_page_preset_flow() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcasePage {
            width: 1200
            height: 600
            gridPreset: "flow"
            ShowcaseTile { label: "a" }
            ShowcaseTile { label: "b" }
            ShowcaseTile { label: "c" }
            ShowcaseTile { label: "d" }
            ShowcaseTile { label: "e" }
        }
        """
    )
    assert engine.rootObjects()


def test_showcase_page_invalid_preset_falls_back() -> None:
    """Invalid gridPreset must fall back to single-col with a console warning, not crash."""
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcasePage {
            width: 800
            height: 600
            title: "Bad preset"
            gridPreset: "diagonal"
            ShowcaseTile { label: "A" }
        }
        """
    )
    assert engine.rootObjects()


def test_showcase_page_subtitle_optional() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcasePage {
            width: 800
            height: 600
            title: "No subtitle"
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    assert objs[0].property("subtitle") == ""


def test_showcase_page_code_snippet_slot_exists_but_default_empty() -> None:
    """codeSnippet property exists in the API surface (future-proof for v2) but defaults to empty
    and renders nothing in v1."""
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcasePage {
            width: 800
            height: 600
            title: "Buttons"
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    assert objs[0].property("codeSnippet") == ""


def test_showcase_page_apply_theme_runtime_override_does_not_crash() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        ShowcasePage {
            width: 1024
            height: 600
            title: "Theme override"
            gridPreset: "two-col"
            ShowcaseTile { label: "A" }
            ShowcaseTile { label: "B" }
            Component.onCompleted: {
                Tokens.applyTheme({ space: { x6: 32 }, radius: { md: 12 } })
            }
        }
        """
    )
    assert engine.rootObjects()
