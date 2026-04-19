from __future__ import annotations

from importlib.resources import as_file, files
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pathlib import Path

    from PySide6.QtQml import QQmlApplicationEngine, QQmlEngine

_qml_ctx = None
_types_registered = False


def qml_import_path() -> Path:
    global _qml_ctx
    traversable = files("pearl_kit") / "qml"
    ctx = as_file(traversable)
    path = ctx.__enter__()
    _qml_ctx = ctx
    return path


def _register_viewport_types() -> None:
    """Register the Python-backed viewport QQuickItems as QML types.

    Exposed as ``PearlKit.Viewports 1.0`` — separate module so callers who
    don't need VTK/Image hosting don't pay the import cost.
    """
    global _types_registered
    if _types_registered:
        return

    from PySide6.QtQml import qmlRegisterType

    from ._viewports import ImageViewportItem, VTKViewportItem

    qmlRegisterType(VTKViewportItem, "PearlKit.Viewports", 1, 0, "VTKViewportItem")  # pyright: ignore[reportCallIssue, reportArgumentType]
    qmlRegisterType(ImageViewportItem, "PearlKit.Viewports", 1, 0, "ImageViewportItem")  # pyright: ignore[reportCallIssue, reportArgumentType]

    _types_registered = True


def register_qml(engine: QQmlEngine | QQmlApplicationEngine) -> None:
    """Add PearlKit's QML module to the given engine's import path.

    Also registers Python-backed viewport item types under
    ``PearlKit.Viewports 1.0``. The registration is idempotent and happens
    once per process regardless of how many engines exist.
    """
    engine.addImportPath(str(qml_import_path()))
    _register_viewport_types()
