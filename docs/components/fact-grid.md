# FactGrid

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=fact-grid"
        title="Live FactGrid demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Welcome-step N-column stat grid: bordered container with 1 px hairlines
between cells. Each cell renders mono uppercase key + medium value +
optional small sub-line. Used for the `5 MIN / LOCAL / 1,247 / 3.2.1`
splash on the onboarding welcome step.

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

P.FactGrid {
    width: 540
    columns: 2
    model: [
        { key: "5 MIN",  value: "Typical setup",        sub: "Skip anything optional" },
        { key: "LOCAL",  value: "Data stays local",     sub: "HIPAA / KVKK default" },
        { key: "1,247",  value: "Clinicians onboarded", sub: "23 countries" },
        { key: "3.2.1",  value: "Clinical build",       sub: "License valid to 2027-04" }
    ]
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `model` | `var` | `[]` | Array of `{ key, value, sub }` per cell. `sub` is optional. |
| `columns` | `int` | `2` | Number of grid columns. Cells flow row-major. |
| `cellPadding` | `int` | `14` | Padding inside each cell. |
| `background` | `color` | `#E2E8F0` | Container background — shows through the 1 px gaps as the hairline. |
| `cellBackground` | `color` | `#FFFFFF` | Per-cell fill. |
| `borderColor` | `color` | `#E2E8F0` | Outer 1 px border. |
| `keyColor` | `color` | `#9CA3AF` | Mono uppercase key color. |
| `valueColor` | `color` | `#1A202C` | Medium value color. |
| `subColor` | `color` | `#6B7280` | Small sub-line color. |
| `radius` | `int` | `5` | Container corner radius. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the key. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for value + sub. |

## Notes

- Source: `onboarding.jsx:164-181` in the DALI onboarding handoff.
- The "1 px hairline" trick uses the parent rectangle's background bleeding through 1 px row/column gaps inside a `GridLayout` — no per-cell border needed.
- Distinct from [`StatTile`](stat-tile.md), which uses a serif numeral and three different font sizes per cell.
