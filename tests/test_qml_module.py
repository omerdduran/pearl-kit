import sys

from PySide6.QtCore import QCoreApplication
from PySide6.QtQml import QQmlApplicationEngine


def test_tokens_singleton_loads() -> None:
    import pearl_kit

    app = QCoreApplication.instance() or QCoreApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(
        b"import QtQuick\n"
        b"import PearlKit 1.0 as P\n"
        b"QtObject { property color c: P.Tokens.background }\n"
    )
    assert engine.rootObjects(), "PearlKit.Tokens failed to load"
    _ = app
