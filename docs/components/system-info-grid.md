# SystemInfoGrid

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=system-info-grid"
        title="Live SystemInfoGrid demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 4-column footer grid — label + value per cell, with an optional colored status dot. Designed for system/case footers and telemetry strips where the user needs a one-line summary of four or five datapoints.

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

P.SystemInfoGrid {
    width: 640
    items: [
        { label: "HOST",   value: "MacBook Pro", dot: "#10B981" },
        { label: "RAM",    value: "32 GB" },
        { label: "GPU",    value: "M3 Max" },
        { label: "UPTIME", value: "4h 12m" }
    ]
}
```

Each item is an object with `label`, `value`, and an optional `dot` color (hex). Cells without a `dot` key render just label + value.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `items` | `array` | `[]` | Array of `{label, value, dot?}` objects. |
| `labelColor` | `color` | `#8A93A0` | Label text color. |
| `valueColor` | `color` | `#1A202C` | Value text color. |
| `borderColor` | `color` | `#ECEEF2` | Top hairline color. |
| `background` | `color` | `#FFFFFF` | Strip fill color. |
| `monoFontFamily` | `string` | `Tokens.font.mono` | Font for labels and values. |
