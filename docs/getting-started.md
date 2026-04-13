# Getting Started

## Requirements

- Python ≥ 3.11
- PySide6 ≥ 6.8
- macOS (primary), Linux (tested)

## Install

```bash
pip install pearl-kit
```

Or with uv:

```bash
uv add pearl-kit
```

## Boot a QML engine with pearl-kit registered

```python
import sys

from PySide6.QtCore import QCoreApplication
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit


def main() -> int:
    app = QCoreApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)

    engine.loadData(b"""
    import QtQuick
    import PearlKit 1.0 as P

    QtObject {
        Component.onCompleted: console.log("background:", P.Tokens.background)
    }
    """)

    if not engine.rootObjects():
        return 1
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
```

`register_qml()` adds the bundled QML directory to the engine's import path, so `import PearlKit 1.0` resolves correctly.

## Switch themes

```qml
import QtQuick
import PearlKit 1.0 as P

QtObject {
    Component.onCompleted: P.Tokens.mode = P.Tokens.Light
}
```

All token bindings re-evaluate automatically.
