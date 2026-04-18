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


def test_icon_badge_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nIconBadge { }\n")
    roots = engine.rootObjects()
    assert roots, "default IconBadge failed to load"
    assert roots[0].property("implicitWidth") == 20
    assert roots[0].property("implicitHeight") == 20
    assert roots[0].property("tone") == "info"
    assert roots[0].property("gradient") is True


def test_icon_badge_all_tones_load() -> None:
    for tone in ("info", "warn", "success", "primary"):
        qml = (
            b"import QtQuick\nimport PearlKit 1.0\n" + f'IconBadge {{ tone: "{tone}" }}\n'.encode()
        )
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots, f"tone={tone} failed to load"
        assert roots[0].property("tone") == tone


def test_icon_badge_solid_variant() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nIconBadge { gradient: false }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("gradient") is False


def test_icon_badge_custom_size() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nIconBadge { size: 32; iconSize: 18 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("size") == 32
    assert roots[0].property("iconSize") == 18
