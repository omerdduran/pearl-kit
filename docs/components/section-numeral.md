# SectionNumeral

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=section-numeral"
        title="Live SectionNumeral demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A mono uppercase section header with an optional numeral prefix joined by
` · `, e.g. `"I · ANATOMY & PLACEMENT"`. Sibling of `SectionLabel` but
preformats a roman / arabic numeral slot so you do not hand-concatenate
per call site.

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
    spacing: 24
    P.SectionNumeral { numeral: "I";   label: "ANATOMY & PLACEMENT" }
    P.SectionNumeral { numeral: "II";  label: "IMPLANT DETAIL" }
    P.SectionNumeral { numeral: "III"; label: "ACKNOWLEDGEMENT" }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `numeral` | `string` | `""` | Prefix numeral — typically `I`, `II`, `III`, or an arabic number. |
| `label` | `string` | `""` | Section name; joined to `numeral` with ` · `. |
| `fontFamily` | `string` | `Tokens.font.mono` | Label typeface. |

All other `Text` properties are accessible via the base element.

## Notes

- Source: `report-tab.jsx:513-515` / `:538-540` / `:577-579` in the DALI
  design handoff.
