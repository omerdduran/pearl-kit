# DensityBar

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=density-bar"
        title="Live DensityBar demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A horizontal spectrum bar — red → yellow → green → blue gradient with a thin
vertical needle marking the current value. Used in the DALI plan rail to
show bone density (Hounsfield Units) at the implant's seated depth, but
the component is generic and accepts any `[from, to]` range and unit.

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

P.DensityBar {
    width: 220
    value: 820
    from: -200
    to: 1600
    unit: "HU"
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `value` | `real` | `820` | Current marker position. |
| `from` | `real` | `-200` | Left-edge value. |
| `to` | `real` | `1600` | Right-edge value. |
| `unit` | `string` | `"HU"` | Unit suffix in the center readout. |
| `labelColor` | `color` | `#6B7280` | Color for the min / max labels. |
| `valueColor` | `color` | `#1A202C` | Color for the center value readout. |
| `markerColor` | `color` | `#1A202C` | Color of the needle marker. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Typeface for labels and readout. |

## Notes

- Source: `planning-viewer.jsx:154-166` in the DALI design handoff.
- The gradient stops are fixed (red → yellow → green → blue). If you need
  a different gradient palette, subclass or wrap.
