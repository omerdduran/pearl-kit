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


def test_breadcrumb_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nBreadcrumb { }\n")
    roots = engine.rootObjects()
    assert roots, "default Breadcrumb failed to load"
    obj = roots[0]
    assert obj.property("separatorChar") == "/"
    assert obj.property("fontPixelSize") == 11


def test_breadcrumb_segments_smoke() -> None:
    # JS array properties come back as QJSValue which doesn't expose len();
    # smoke-load only — QML parse success is the assertion.
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"Breadcrumb {\n"
        b"  segments: [\n"
        b'    { "label": "Library" },\n'
        b'    { "label": "2041-04" },\n'
        b'    { "label": "Planning", "current": true }\n'
        b"  ]\n"
        b"}\n"
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots


def test_breadcrumb_custom_separator_roundtrips() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nBreadcrumb { separatorChar: ">" }\n')
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("separatorChar") == ">"
