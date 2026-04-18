"""pearl-kit clinical launch flow example — splash -> case library.

Uses the new clinical primitives/composites shipped alongside the
default pearl-kit components: ScannerMark, Thumb, Render3D, BrandTile,
FilterRow, InfoCard, StatusPill, SearchField, MetaRow, SectionLabel,
SystemInfoGrid, TopMetaStrip, ProgressLine.
"""

from __future__ import annotations

import sys
from pathlib import Path

from PySide6.QtCore import QUrl
from PySide6.QtGui import QFontDatabase, QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit

_EXAMPLES_DIR = Path(__file__).resolve().parent
_FONTS_DIR = _EXAMPLES_DIR / "fonts"
_FONT_FILES = (
    "DMSerifDisplay-Regular.ttf",
    "PlusJakartaSans-Regular.ttf",
    "PlusJakartaSans-Bold.ttf",
    "PlusJakartaSans-Light.ttf",
    "JetBrainsMono-Regular.ttf",
)


def _load_fonts() -> None:
    missing: list[str] = []
    for name in _FONT_FILES:
        path = _FONTS_DIR / name
        if not path.exists():
            missing.append(name)
            continue
        if QFontDatabase.addApplicationFont(str(path)) < 0:
            missing.append(name)
    if missing:
        print(f"[splash_library] fonts not loaded: {', '.join(missing)}", file=sys.stderr)


def main() -> int:
    app = QGuiApplication.instance() or QGuiApplication(sys.argv)
    _load_fonts()

    engine = QQmlApplicationEngine()
    engine.addImportPath(str(_EXAMPLES_DIR))
    pearl_kit.register_qml(engine)

    engine.load(QUrl.fromLocalFile(str(_EXAMPLES_DIR / "App.qml")))
    if not engine.rootObjects():
        print("[splash_library] QML failed to load", file=sys.stderr)
        return 1
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
