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


def test_sample_case_preview_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSampleCasePreview { }\n")
    roots = engine.rootObjects()
    assert roots, "default SampleCasePreview failed to load"
    assert roots[0].property("topLeftLabel") == "SAMPLE \u00b7 3D VOLUMETRIC"
    assert roots[0].property("markerCount") == 2
    assert roots[0].property("previewHeight") == 140


def test_sample_case_preview_with_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"SampleCasePreview {\n"
        b'  topLeftLabel: "DEMO"\n'
        b'  topRightLabel: "142 / 512"\n'
        b"  markerCount: 3\n"
        b"  previewHeight: 180\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("topLeftLabel") == "DEMO"
    assert roots[0].property("topRightLabel") == "142 / 512"
    assert roots[0].property("markerCount") == 3
    assert roots[0].property("previewHeight") == 180


def test_sample_case_preview_no_markers() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSampleCasePreview { markerCount: 0 }\n")
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("markerCount") == 0
