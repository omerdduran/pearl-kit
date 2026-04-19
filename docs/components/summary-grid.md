# SummaryGrid

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=summary-grid"
        title="Live SummaryGrid demo"
        loading="lazy"
        width="100%" height="380"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Ready-step "YOUR SETUP" card: grey-surface bordered rectangle with a mono
uppercase eyebrow on top and an N-column mono key-value grid below. Each
entry can override its value color via `valueColor` for OK / warn coloring.

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

P.SummaryGrid {
    width: 540
    eyebrow: "YOUR SETUP"
    model: [
        { key: "NAME",       value: "Dr. Mehmet Kaya" },
        { key: "LICENSE",    value: "TR-DDS-21487" },
        { key: "BRAND",      value: "STRAUMANN BLT" },
        { key: "CANAL MIN",  value: "2.5 mm" },
        { key: "COMPLIANCE", value: "HIPAA/KVKK ON", valueColor: "#047857" },
        { key: "REGION",     value: "EU-CENTRAL" }
    ]
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `eyebrow` | `string` | `"YOUR SETUP"` | Top mono uppercase eyebrow. Hidden when empty. |
| `model` | `var` | `[]` | Array of `{ key, value, valueColor? }`. Per-entry `valueColor` overrides the default value color. |
| `columns` | `int` | `2` | Number of grid columns. |
| `background` | `color` | `#F7F8FA` | Card surface. |
| `borderColor` | `color` | `#E2E8F0` | Card 1 px border. |
| `eyebrowColor` | `color` | `#9CA3AF` | Eyebrow text color. |
| `keyColor` | `color` | `#9CA3AF` | Default per-entry key color. |
| `valueColor` | `color` | `#1A202C` | Default per-entry value color (overridden by `model[i].valueColor`). |
| `radius` | `int` | `5` | Card corner radius. |
| `padding` | `int` | `16` | Inner padding. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for everything. |

## Notes

- Source: `onboarding.jsx:423-438` in the DALI onboarding handoff.
- Long values elide right within their column.
- Use the `valueColor` override to flag OK (`#047857`) / warn (`#B45309`) / accent (`#2563EB`) values inline.
