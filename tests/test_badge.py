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


def test_badge_default_loads() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nBadge { text: "New" }\n')
    roots = engine.rootObjects()
    assert roots, "default Badge failed to load"
    obj = roots[0]
    assert obj.property("variant") == "default"
    assert obj.property("text") == "New"
    assert obj.property("enabled") is True


def test_badge_all_variants_load() -> None:
    for v in ("default", "secondary", "destructive", "outline", "ghost", "link"):
        engine = _load(
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'Badge {{ variant: "{v}"; text: "x" }}\n'.encode(),
        )
        roots = engine.rootObjects()
        assert roots, f"variant={v} failed to load"
        assert roots[0].property("variant") == v


def test_badge_implicit_height_matches_spec() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nBadge { text: "Label" }\n')
    obj = engine.rootObjects()[0]
    assert obj.property("implicitHeight") >= 20


def test_badge_empty_text_still_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nBadge { }\n")
    roots = engine.rootObjects()
    assert roots, "empty Badge failed to load"
    assert roots[0].property("text") == ""


def test_badge_icon_slots_load() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'Badge { text: "Tagged"; iconLeft: "qrc:/no-op.svg"; iconRight: "qrc:/no-op.svg" }\n',
    )
    roots = engine.rootObjects()
    assert roots


def test_badge_disabled_state() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nBadge { text: "off"; enabled: false }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_badge_implicit_width_reflects_text() -> None:
    short_engine = _load(b'import QtQuick\nimport PearlKit 1.0\nBadge { text: "A" }\n')
    short_width = short_engine.rootObjects()[0].property("implicitWidth")
    long_engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nBadge { text: "much longer label" }\n',
    )
    long_width = long_engine.rootObjects()[0].property("implicitWidth")
    assert long_width > short_width
