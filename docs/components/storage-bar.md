# StorageBar

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=storage-bar"
        title="Live StorageBar demo"
        loading="lazy"
        width="100%" height="320"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 3-row disk usage meter: a mono top row with the usage label and a
right-aligned percentage, a 6 px progress bar, and a mono muted bottom
caption. Used in the DALI settings "Disk usage" field.

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

P.StorageBar {
    width: 340
    used: 412
    total: 1247
    topLabel: "412 GB used · 1,247 cases"
    bottomLabel: "876 GB available · 1.2 TB total"
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `used` | `real` | `0` | Current usage. |
| `total` | `real` | `1` | Capacity. |
| `unit` | `string` | `"GB"` | Unit label (currently informational — labels are pre-formatted by the consumer). |
| `topLabel` | `string` | `""` | Left side of the top row. |
| `bottomLabel` | `string` | `""` | Mono muted caption under the bar. |
| `trackColor` | `color` | `#F1F5F9` | Unfilled track. |
| `fillColor` | `color` | `#2563EB` | Fill color. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Typeface for all labels. |

## Notes

- Source: `settings.jsx:571-584` in the DALI settings handoff.
- The percentage readout on the right is computed from
  `used / total`, rounded to the nearest whole percent.
