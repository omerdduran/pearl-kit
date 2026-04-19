# NumberedNavItem

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=numbered-nav-item"
        title="Live NumberedNavItem demo"
        loading="lazy"
        width="100%" height="320"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 2-column sidebar nav row: a 28 px mono index column (e.g. `01`–`09`)
and a title + subtitle column. Active state paints the whole tile blue
(`#EFF6FF` bg, `#BFDBFE` border) and strengthens the title. Used in the
DALI settings sidebar to list the nine sections.

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
    width: 240; spacing: 1
    P.NumberedNavItem {
        index: "01"; label: "Profile"; subtitle: "Name · signature"
        width: parent.width
    }
    P.NumberedNavItem {
        index: "02"; label: "Clinical preferences"; subtitle: "Brands · safety"
        checked: true
        width: parent.width
    }
    P.NumberedNavItem {
        index: "03"; label: "Viewer"; subtitle: "Layout · tools"
        width: parent.width
    }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `index` | `string` | `""` | Mono index text (e.g. `"01"`). |
| `label` | `string` | `""` | 13 px title. |
| `subtitle` | `string` | `""` | 11 px sub-title; hidden when empty. |
| `checked` | `bool` | `false` | Active state. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the index. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for title / subtitle. |

## Signals

- `clicked()` — emitted on press.

## Notes

- Source: `settings.jsx:963-987` in the DALI settings handoff.
- Distinct from the stable `NavItem` (which has a count pill + left
  strip) and the experimental `FilterRow`. This is the numbered-list
  pattern specifically.
