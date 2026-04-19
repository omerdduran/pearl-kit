# ReadoutSlider

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=readout-slider"
        title="Live ReadoutSlider demo"
        loading="lazy"
        width="100%" height="360"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 340 px slider with a track + blue fill + 14×14 white thumb and a
72 px right-aligned mono readout column (`value unit`). Used in the
DALI settings for safety thresholds (`mm`), torque targets (`Ncm`),
cache sizes (`GB`), session timeouts (`min`), and font scale (`×`).

Precision auto-selects: 1 decimal when `stepSize < 1`, integer otherwise.

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

Column {
    spacing: 14
    P.ReadoutSlider {
        value: 2.5; from: 1.0; to: 4.0; stepSize: 0.1; unit: "mm"
        onMoved: (v) => console.log("canal min", v)
    }
    P.ReadoutSlider { value: 55; from: 20; to: 80; stepSize: 5; unit: "Ncm" }
    P.ReadoutSlider { value: 64; from: 8;  to: 128; stepSize: 8; unit: "GB" }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `value` | `real` | `0` | Current value. |
| `from` | `real` | `0` | Lower bound. |
| `to` | `real` | `1` | Upper bound. |
| `stepSize` | `real` | `0.1` | Step between discrete values. Drives precision. |
| `unit` | `string` | `""` | Suffix on the readout (e.g. `mm`, `Ncm`). |
| `trackColor` | `color` | `#F1F5F9` | Unfilled track. |
| `fillColor` | `color` | `#2563EB` | Track fill. |
| `thumbColor` | `color` | `#FFFFFF` | Thumb fill. |
| `thumbBorderColor` | `color` | `#2563EB` | Thumb border. |
| `readoutColor` | `color` | `#1A202C` | Readout text color. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the readout. |

## Signals

- `moved(real value)` — emitted as the user drags.

## Notes

- Source: `settings.jsx:192-211` in the DALI settings handoff.
- Wraps `QtQuick.Templates.Slider`. Unlike the batch-1 `BipolarSlider`,
  this one is one-sided (from → to) and carries the mono readout.
