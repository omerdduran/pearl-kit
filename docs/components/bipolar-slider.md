# BipolarSlider

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=bipolar-slider"
        title="Live BipolarSlider demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A symmetric ±range slider with a visible center tick at 0 and mono
`−max · 0 · +max` labels below the track. Used in the DALI plan rail for
implant angulation (`-15° … +15°`), but the range and unit are arbitrary.

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

P.BipolarSlider {
    width: 220
    value: 4
    range: 15
    unit: "°"
    onMoved: (v) => console.log("angle", v)
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `value` | `real` | `0` | Current value; clamped internally to `[-range, +range]`. |
| `range` | `real` | `15` | Half-span — slider runs from `-range` to `+range`. |
| `unit` | `string` | `"°"` | Suffix appended to the −max / 0 / +max labels. |
| `thumbColor` | `color` | `#2563EB` | Thumb fill. |
| `trackColor` | `color` | `#F1F5F9` | Unfilled track. |
| `tickColor` | `color` | `#D1D5DB` | Center tick color. |
| `labelColor` | `color` | `#9CA3AF` | Min / 0 / max label color. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Label typeface. |

## Signals

- `moved(real value)` — emitted as the user drags the thumb.

## Notes

- Source: `planning-viewer.jsx:419-433` in the DALI design handoff.
- Wraps a `QtQuick.Templates.Slider` with `from: -range`, `to: +range`,
  and an overlaid center tick. Step size is `0.5`.
