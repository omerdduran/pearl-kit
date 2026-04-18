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


def test_density_bar_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nDensityBar { }\n")
    roots = engine.rootObjects()
    assert roots, "default DensityBar failed to load"
    assert roots[0].property("value") == 820
    assert roots[0].property("from") == -200
    assert roots[0].property("to") == 1600
    assert roots[0].property("unit") == "HU"


def test_density_bar_custom_range() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'DensityBar { value: 50; from: 0; to: 100; unit: "%" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("value") == 50
    assert roots[0].property("unit") == "%"
