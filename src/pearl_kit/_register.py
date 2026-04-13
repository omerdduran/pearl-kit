from __future__ import annotations

from importlib.resources import as_file, files
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pathlib import Path

    from PySide6.QtQml import QQmlApplicationEngine, QQmlEngine

_qml_ctx = None


def qml_import_path() -> Path:
    global _qml_ctx
    traversable = files("pearl_kit") / "qml"
    ctx = as_file(traversable)
    path = ctx.__enter__()
    _qml_ctx = ctx
    return path


def register_qml(engine: QQmlEngine | QQmlApplicationEngine) -> None:
    """Add PearlKit's QML module to the given engine's import path."""
    engine.addImportPath(str(qml_import_path()))
