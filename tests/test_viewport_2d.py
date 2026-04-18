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


def test_viewport_2d_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nViewport2D { }\n")
    roots = engine.rootObjects()
    assert roots, "default Viewport2D failed to load"
    assert roots[0].property("kind") == "axial"
    assert roots[0].property("showCrosshairs") is True


def test_viewport_2d_all_kinds_load() -> None:
    for kind in ("axial", "coronal", "sagittal"):
        qml = (
            b"import QtQuick\nimport PearlKit 1.0\n"
            + f'Viewport2D {{ kind: "{kind}"; title: "{kind.upper()}"; slice: 50; total: 200 }}\n'.encode()
        )
        engine = _load(qml)
        roots = engine.rootObjects()
        assert roots, f"kind={kind} failed to load"
        assert roots[0].property("kind") == kind


def test_viewport_2d_slice_meta_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'Viewport2D { kind: "axial"; slice: 142; total: 512; bottomInfo: "WL 400 \xc2\xb7 WW 2000" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("slice") == 142
    assert roots[0].property("total") == 512
