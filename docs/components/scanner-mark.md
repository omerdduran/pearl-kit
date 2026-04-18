# ScannerMark

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=scanner-mark"
        title="Live ScannerMark demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

An animated splash mark — a dashed outer ring, a solid middle ring, a sweeping arc, and a centered white tile with the tooth glyph. Designed for app-start splash screens and long-running scan indicators where a plain spinner feels undersized.

## Import

```python
import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
import pearl_kit

app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
pearl_kit.register_qml(engine)
```

```qml
import QtQuick
import PearlKit 1.0 as P

P.ScannerMark { diameter: 180 }
```

The rotating dashed ring, sweep arc, and solid ring all animate continuously; there is no `running` flag — use `visible: false` to pause.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `diameter` | `int` | `150` | Outer diameter. |
| `centerSize` | `int` | `68` | Inner white-tile size. |
| `iconSize` | `int` | `36` | Tooth glyph size inside the tile. |
| `dashedRingColor` | `color` | `#D8E4F5` | Dashed outer ring. |
| `solidRingColor` | `color` | `#B9CCE7` | Solid middle ring. |
| `sweepColor` | `color` | `#2563EB` | Rotating arc color. |
| `centerBg` | `color` | `#FFFFFF` | Center tile fill. |
| `centerBorder` | `color` | `#DDE2EA` | Center tile border. |
| `toothStroke` | `color` | `#1A202C` | Tooth glyph stroke. |
