# BrandTile

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=brand-tile"
        title="Live BrandTile demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A small gradient tile with a centered tooth glyph and a gloss overlay — the pearl-kit brand mark in compact form. For nav bars, splash chrome, and empty-state illustrations.

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

P.BrandTile { tileSize: 32; iconSize: 18 }
```

## Size variants

```qml
Row {
    spacing: 12
    P.BrandTile { tileSize: 28; iconSize: 16 }
    P.BrandTile { tileSize: 40; iconSize: 22 }
    P.BrandTile { tileSize: 56; iconSize: 32 }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `tileSize` | `int` | `28` | Outer square size. |
| `iconSize` | `int` | `16` | Inner tooth glyph size. |
| `gradientStart` | `color` | `#DBEAFE` | Top-left gradient stop. |
| `gradientEnd` | `color` | `#93C5FD` | Bottom-right gradient stop. |
| `toothStroke` | `color` | `#1E3A8A` | Glyph stroke color. |
| `toothStrokeWidth` | `real` | `1.6` | Glyph stroke weight. |
| `radius` | `int` | `6` | Corner radius. |
