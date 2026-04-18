# SafetyRow

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=safety-row"
        title="Live SafetyRow demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A per-structure safety-distance row: label + value + threshold bar + min
caption. The value and fill color flip from green to amber when `value < min`.
Used in the DALI plan rail to show implant-to-anatomy clearances (canal,
sinus floor, adjacent roots, cortical bone), but the row is generic.

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
    spacing: 0
    P.SafetyRow { label: "Inferior alveolar canal"; value: 3.2; min: 2.0 }
    P.SafetyRow { label: "Maxillary sinus floor";   value: 4.8; min: 1.5 }
    P.SafetyRow { label: "Adjacent root (#21)";     value: 2.3; min: 1.5 }
    P.SafetyRow { label: "Buccal cortex";           value: 1.8; min: 1.0 }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `string` | `""` | Structure name. |
| `value` | `real` | `0` | Measured distance. |
| `min` | `real` | `1.0` | Safety threshold. |
| `unit` | `string` | `"mm"` | Unit suffix. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the value readout. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for the label. |

## Notes

- Source: `planning-viewer.jsx:169-193` in the DALI design handoff.
- The threshold mark at 50 % of the track visualizes "min × 2" as the
  chart's implicit max — a green fill that spans past center means safe
  headroom. This mirrors the handoff's `min safety · X mm` caption.
