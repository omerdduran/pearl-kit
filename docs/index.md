# pearl-kit

Pixel-craft PySide6/QML component kit — macOS first. Shadcn/Linear-level attention to detail, designed as a curated component kit rather than a framework.

!!! warning "Alpha"
    Infrastructure is in place. Public components land in the next phase.

## Install

```bash
pip install pearl-kit
```

## Quick look

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

## What's in the box today

- `Tokens` QML singleton — shadcn taxonomy, three themes (Dark / DarkBlue / Light), radius/spacing/typography/shadow/motion scales.
- `PearlKit.internal` helper atoms (`PearlBackground`, `PearlBaseText`, `PearlFocusRing`, `PearlPopup`) — the substrate every future component composes from.
- `pearl_kit.register_qml(engine)` — one-line QML module registration.

## What's coming next

The five v0.1.0 components: Button, Input, Toggle, Select, Dialog. See [Getting Started](getting-started.md) for the current token API.
