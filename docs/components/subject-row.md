# SubjectRow

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=subject-row"
        title="Live SubjectRow demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A selectable list row with a colored ID square + two-line title / caption +
optional warn status dot. Used in the DALI plan rail for implant listings,
but generic enough for any `IDENT · title · caption` list. Emits `clicked`
and supports `selected` + `status` visual states.

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
    spacing: 4
    P.SubjectRow {
        identifier: "I1"
        title: "#22 · Straumann BLT"
        caption: "Ø 4.1 × 10 mm · 4°"
        status: "ok"
        selected: true
    }
    P.SubjectRow {
        identifier: "I2"
        title: "#23 · Straumann BLT"
        caption: "Ø 3.3 × 10 mm · 6°"
        status: "warn"
    }
}
```

## Statuses

- `neutral` / `ok` / `info` — blue ID square when selected.
- `warn` — amber ID square when selected + small glowing amber dot on the right.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `identifier` | `string` | `"I1"` | Two- or three-char identifier shown in the square. |
| `title` | `string` | `""` | Primary title line. |
| `caption` | `string` | `""` | Mono caption below the title. |
| `status` | `string` | `"neutral"` | `ok` / `warn` / `info` / `neutral`. |
| `selected` | `bool` | `false` | Highlight state. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for identifier + caption. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for title. |

## Signals

- `clicked()` — inherited from `AbstractButton`.

## Notes

- Source: `planning-viewer.jsx:349-378` in the DALI design handoff.
