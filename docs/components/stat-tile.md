# StatTile

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=stat-tile"
        title="Live StatTile demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A three-line summary tile used in report strips and editorial spreads: a mono
uppercase eyebrow, a large serif value, and a mono subtitle. Supports three
sizes (`sm` / `md` / `lg`) and three tones (`neutral` / `warn` / `success`)
to reflect the flagged risk or success state of the metric.

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

P.StatTile {
    eyebrow: "RISKS FLAGGED"
    value: "1"
    subtitle: "canal proximity · action required"
    tone: "warn"
    size: "lg"
}
```

## Sizes

- `sm` — compact 20 px serif value (dense layouts).
- `md` — balanced 26 px serif value (default).
- `lg` — editorial 54 px serif value for magazine-style stat spreads.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `eyebrow` | `string` | `""` | Mono uppercase caption above the value. |
| `value` | `string` | `""` | The primary serif numeral / word. |
| `subtitle` | `string` | `""` | Mono subtitle below; hidden when empty. |
| `tone` | `string` | `"neutral"` | `neutral` / `warn` (amber value) / `success` (green value). |
| `size` | `string` | `"md"` | `sm` / `md` / `lg`. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |
| `fontFamilySerif` | `string` | `"Times New Roman"` | Serif typeface — set this to the project's display serif (DALI uses DM Serif Display). |

## Notes

- Source: `report-tab.jsx:387-398` (balanced) + `report-tab.jsx:497-509`
  (editorial) in the DALI design handoff.
