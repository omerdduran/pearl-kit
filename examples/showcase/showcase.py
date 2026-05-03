"""Pearl-kit categorized showcase — minimal QQmlApplicationEngine boot.

Run:
    uv run python examples/showcase/showcase.py

The showcase mirrors the Penpot ``PK Showcase`` page set 1:1: same 21
categories, same ordering inside each, same tile chrome. Use this surface
side-by-side with Penpot to verify visual parity.
"""

from __future__ import annotations

import sys
from pathlib import Path

from PySide6.QtCore import QCoreApplication, QUrl
from PySide6.QtGui import QFontDatabase, QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit


def _load_fonts() -> None:
    """Load the SF Pro fonts shipped with the examples directory.

    Pearl-kit's tokens default to SF Pro Display + SF Mono; on systems where
    those are not installed, the example fonts ensure the showcase renders
    consistently.
    """
    fonts_dir = Path(__file__).resolve().parent.parent / "fonts"
    if not fonts_dir.is_dir():
        return
    for font_file in sorted(fonts_dir.glob("*.otf")):
        QFontDatabase.addApplicationFont(str(font_file))
    for font_file in sorted(fonts_dir.glob("*.ttf")):
        QFontDatabase.addApplicationFont(str(font_file))


def main() -> int:
    QCoreApplication.setOrganizationName("pearl-kit")
    QCoreApplication.setOrganizationDomain("pearl-kit.local")
    QCoreApplication.setApplicationName("Showcase")

    app = QGuiApplication(sys.argv)
    _load_fonts()

    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)

    here = Path(__file__).resolve().parent
    engine.addImportPath(str(here))

    qml_url = QUrl.fromLocalFile(str(here / "Showcase.qml"))
    engine.load(qml_url)

    if not engine.rootObjects():
        return 1
    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
