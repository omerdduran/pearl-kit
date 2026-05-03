"""Tests for CollapsibleNavGroup primitive — collapsible sidebar grouping for the showcase shell."""

from __future__ import annotations

import sys

from PySide6.QtCore import QSettings
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def _load(qml: bytes) -> QQmlApplicationEngine:
    import pearl_kit

    _ = QGuiApplication.instance() or QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(qml)
    return engine


def test_collapsible_nav_group_default_loads() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        CollapsibleNavGroup {
            width: 240
            header: "FOUNDATIONS"
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    grp = objs[0]
    assert grp.property("header") == "FOUNDATIONS"
    assert grp.property("expanded") is True


def test_collapsible_nav_group_with_children() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        CollapsibleNavGroup {
            width: 240
            header: "FORM PRIMITIVES"
            NavItem { text: "Buttons" }
            NavItem { text: "Inputs" }
        }
        """
    )
    assert engine.rootObjects()


def test_collapsible_nav_group_collapsed_state() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        CollapsibleNavGroup {
            width: 240
            header: "NAV"
            expanded: false
            NavItem { text: "A" }
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    assert objs[0].property("expanded") is False


def test_collapsible_nav_group_expanded_property_round_trip() -> None:
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        CollapsibleNavGroup {
            id: grp
            width: 240
            header: "ROUNDTRIP"
            NavItem { text: "X" }
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    grp = objs[0]
    assert grp.property("expanded") is True
    grp.setProperty("expanded", False)
    assert grp.property("expanded") is False
    grp.setProperty("expanded", True)
    assert grp.property("expanded") is True


def test_collapsible_nav_group_no_persist_key_makes_no_settings_writes(tmp_path) -> None:
    """Without persistKey, the group must not touch QSettings.

    We verify this by writing a sentinel value beforehand and confirming it
    survives unchanged after constructing the group.
    """
    QSettings.setPath(QSettings.Format.IniFormat, QSettings.Scope.UserScope, str(tmp_path))
    QSettings.setDefaultFormat(QSettings.Format.IniFormat)

    sentinel_settings = QSettings("pearl-kit-test", "showcase")
    sentinel_settings.beginGroup("PearlKit.CollapsibleNavGroup.unrelated")
    sentinel_settings.setValue("expandedState", "sentinel")
    sentinel_settings.endGroup()
    sentinel_settings.sync()

    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        CollapsibleNavGroup {
            width: 240
            header: "NoPersist"
        }
        """
    )
    assert engine.rootObjects()
    # Sentinel must remain — confirms group did not mass-rewrite the settings file.
    sentinel_settings.beginGroup("PearlKit.CollapsibleNavGroup.unrelated")
    assert sentinel_settings.value("expandedState") == "sentinel"
    sentinel_settings.endGroup()


def test_collapsible_nav_group_persist_key_is_string_property() -> None:
    """persistKey property exists and accepts strings.

    Full round-trip across instance recreation depends on Qt.labs.settings
    behavior which is exercised at runtime by the showcase shell; here we
    just verify the API surface.
    """
    engine = _load(
        b"""
        import QtQuick
        import PearlKit 1.0
        CollapsibleNavGroup {
            width: 240
            header: "PERSIST"
            persistKey: "showcase.foundations"
            NavItem { text: "Tokens" }
        }
        """
    )
    objs = engine.rootObjects()
    assert objs
    assert objs[0].property("persistKey") == "showcase.foundations"
