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


def test_stat_tile_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nStatTile { }\n")
    roots = engine.rootObjects()
    assert roots, "default StatTile failed to load"
    assert roots[0].property("tone") == "neutral"
    assert roots[0].property("size") == "md"


def test_stat_tile_tone_x_size_matrix() -> None:
    for tone in ("neutral", "warn", "success"):
        for size in ("sm", "md", "lg"):
            qml = (
                b"import QtQuick\nimport PearlKit 1.0\n"
                + f'StatTile {{ tone: "{tone}"; size: "{size}"; '.encode()
                + b'eyebrow: "IMPLANTS"; value: "2"; subtitle: "#22, #23" }\n'
            )
            engine = _load(qml)
            roots = engine.rootObjects()
            assert roots, f"tone={tone} size={size} failed to load"
            assert roots[0].property("tone") == tone
            assert roots[0].property("size") == size


def test_stat_tile_values_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'StatTile { eyebrow: "RISKS"; value: "1"; subtitle: "canal proximity" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("eyebrow") == "RISKS"
    assert roots[0].property("value") == "1"
    assert roots[0].property("subtitle") == "canal proximity"
