# pearl-kit

> Pixel-craft PySide6/QML component kit — macOS first.
> **Status:** alpha, infrastructure only. No public components yet.

## Install

```bash
pip install pearl-kit
```

## Use

```python
import sys
from PySide6.QtCore import QCoreApplication
from PySide6.QtQml import QQmlApplicationEngine
import pearl_kit

app = QCoreApplication(sys.argv)
engine = QQmlApplicationEngine()
pearl_kit.register_qml(engine)
engine.loadData(b"""
import QtQuick
import PearlKit 1.0 as P
QtObject { property color c: P.Tokens.background }
""")
```

## Docs

<https://omerdduran.github.io/pearl-kit>

## License

MIT
