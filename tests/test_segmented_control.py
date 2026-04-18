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


def test_segmented_control_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nSegmentedControl { }\n")
    roots = engine.rootObjects()
    assert roots, "default SegmentedControl failed to load"
    assert roots[0].property("variant") == "pill"
    assert roots[0].property("columns") == 0


def test_segmented_control_all_variants_load() -> None:
    for variant in ("pill", "bordered", "solid"):
        qml = (
            b"import QtQuick\nimport PearlKit 1.0\n"
            b"SegmentedControl {\n"
            + f'  variant: "{variant}"\n'.encode()
            + b'  options: [{ "key": "a", "label": "A" }, { "key": "b", "label": "B" }]\n'
            b'  current: "a"\n'
            b"}\n"
        )
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots, f"variant={variant} failed to load"
        assert roots[0].property("variant") == variant
        assert roots[0].property("current") == "a"


def test_segmented_control_current_roundtrips() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"SegmentedControl {\n"
        b'  options: [{ "key": "plan", "label": "Plan" }, { "key": "report", "label": "Report" }]\n'
        b'  current: "report"\n'
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("current") == "report"


def test_segmented_control_columns_grid() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"SegmentedControl {\n"
        b'  variant: "solid"\n'
        b"  columns: 6\n"
        b"  options: [\n"
        b'    { "key": "6",  "label": "6" },\n'
        b'    { "key": "8",  "label": "8" },\n'
        b'    { "key": "10", "label": "10" },\n'
        b'    { "key": "13", "label": "13" }\n'
        b"  ]\n"
        b'  current: "10"\n'
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("columns") == 6
