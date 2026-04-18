# ChecklistItem

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=checklist-item"
        title="Live ChecklistItem demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A tap-to-acknowledge checklist row with a 16×16 checkbox, a severity dot +
uppercase label, the title (single line), and the body (wrapped multi-line).
When acknowledged, the entire row fades to 60 % opacity and the checkbox
fills with green `#10B981`. Used in the DALI guide-review report's risk
checklist.

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
    width: 540; spacing: 0
    P.ChecklistItem {
        severity: "warn"
        text: "Implant #23 · IAN proximity 2.1 mm"
        body: "Below 2.5 mm institutional threshold. Recommend −2° lingual."
        width: parent.width
    }
    P.ChecklistItem {
        severity: "info"
        text: "Implant #22 · D2 bone, no concerns"
        body: "Primary stability projected 58 Ncm."
        width: parent.width
    }
    P.ChecklistItem {
        severity: "note"
        text: "Restorative access · #22, #23"
        body: "Screw-retained crowns feasible."
        width: parent.width
    }
}
```

## Severities

- `warn` → dot + label `#B45309`, ACTION.
- `info` → dot + label `#2563EB`, CONFIRM (default).
- `note` → dot + label `#6B7280`, NOTE.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `string` | `""` | Inherited from `AbstractButton`; the row title. |
| `body` | `string` | `""` | Wrapped multi-line description under the title. |
| `severity` | `string` | `"info"` | `warn` / `info` / `note`. |
| `checked` | `bool` | `false` | Acknowledged state. |
| `showBody` | `bool` | `true` | Hide the body while keeping the title. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the severity label. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for title + body. |

## Signals

- `toggled()` — emitted after `checked` flips on click.

## Notes

- Source: `report-tab.jsx:162-200` in the DALI design handoff.
- Persistence is the consumer's job — `checked` is a plain bool.
