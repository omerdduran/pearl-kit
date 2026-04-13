"""Placeholder gallery. Will showcase the five v0.1.0 components in the next phase."""

from __future__ import annotations

import sys

from PySide6.QtCore import QCoreApplication
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit


def main() -> int:
    app = QCoreApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(
        b"import QtQuick\n"
        b"import PearlKit 1.0 as P\n"
        b'QtObject { Component.onCompleted: console.log("pearl-kit tokens loaded:",'
        b" P.Tokens.background) }\n"
    )
    if not engine.rootObjects():
        return 1
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
