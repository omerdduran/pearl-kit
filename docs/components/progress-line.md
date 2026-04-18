# ProgressLine

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=progress-line"
        title="Live ProgressLine demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A 3 px gradient progress line — thinner and more decorative than `ProgressBar`, with a linear-gradient fill and a short ease on width changes. For splash-screen loaders and below-the-fold sync indicators.

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

P.ProgressLine {
    width: 360
    value: 65
}
```

## Custom range and color

```qml
P.ProgressLine {
    width: 360
    from: 0
    to: 1024
    value: 640
    fillStart: "#16A34A"
    fillEnd:   "#22C55E"
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `value` | `real` | `0` | Current value. |
| `from` | `real` | `0` | Range minimum. |
| `to` | `real` | `100` | Range maximum. |
| `trackColor` | `color` | `#E6EAF0` | Unfilled track color. |
| `fillStart` | `color` | `#2563EB` | Gradient start (left edge of the fill). |
| `fillEnd` | `color` | `#3B82F6` | Gradient end (right edge of the fill). |
| `lineHeight` | `int` | `3` | Bar height. |

## vs. ProgressBar

Pick **[`ProgressBar`](progress-bar.md)** for standard-weight shadcn-parity loaders with indeterminate mode. Pick **`ProgressLine`** when you want a subtler, single-purpose decorative strip — splash-style loaders, sync hints.
