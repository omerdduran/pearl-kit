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


def test_feature_bullet_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nFeatureBullet { }\n")
    roots = engine.rootObjects()
    assert roots, "default FeatureBullet failed to load"
    assert roots[0].property("iconSize") == 32


def test_feature_bullet_with_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"FeatureBullet {\n"
        b'  title: "AI segmentation"\n'
        b'  description: "Bones, nerves, sinuses auto-detected."\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("title") == "AI segmentation"
    assert roots[0].property("description") == "Bones, nerves, sinuses auto-detected."


def test_feature_bullet_title_only() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nFeatureBullet { title: "Safety thresholds" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("title") == "Safety thresholds"
    assert roots[0].property("description") == ""
