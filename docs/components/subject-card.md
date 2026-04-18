# SubjectCard

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=subject-card"
        title="Live SubjectCard demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A balanced-variant spec card: header row (identifier + tooth meta + serif
brand + status chip) + 4-column parameter grid + safety strip with
tone-colored metrics. Ported from the DALI guide-review report's Balanced
implant card.

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

P.SubjectCard {
    width: 320
    identifier: "I1"
    tooth: "#22"
    brand: "Straumann BLT"
    status: "ok"
    parameters: [
        { key: "Ø mm",   value: "4.1" },
        { key: "Length", value: "10" },
        { key: "Angle",  value: "4°" },
        { key: "Bone",   value: "D2" }
    ]
    metrics: [
        { key: "IAN",    value: "3.2 mm", tone: "ok" },
        { key: "Sinus",  value: "4.8 mm", tone: "ok" },
        { key: "Torque", value: "58 Ncm", tone: "neutral" }
    ]
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `identifier` | `string` | `""` | Short ID shown in the mono meta line (e.g. `I1`). |
| `tooth` | `string` | `""` | Tooth reference appended to the meta line (e.g. `#22`). |
| `brand` | `string` | `""` | Brand / model — rendered in serif 18 px. |
| `status` | `string` | `"ok"` | `ok` (green `✓ OK`) or `warn` (amber `⚠ REVIEW`). |
| `parameters` | `var` | `[]` | Array of `{ key, value }` for the 4-column grid. |
| `metrics` | `var` | `[]` | Array of `{ key, value, tone }` for the safety strip; `tone: "ok"`/`"warn"`/`"neutral"`. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface. |
| `fontFamilySerif` | `string` | `"Times New Roman"` | Serif typeface for the brand line. |

## Notes

- Source: `report-tab.jsx:419-459` in the DALI design handoff.
