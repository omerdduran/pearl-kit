# Chip

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=chip"
        title="Live Chip demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A small clickable mono pill. Two variants: `soft` (tinted muted background —
suggested-prompt chips) and `outline` (transparent background with ink-black
border — compact action chips like "APPLY TO PLAN →"). Unlike `Badge`, Chip
is interactive — it's a `T.AbstractButton` and emits `clicked`.

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

Row {
    spacing: 6
    P.Chip { text: "Compare similar cases"; onClicked: console.log("fill input") }
    P.Chip { text: "Risk summary" }
    P.Chip { text: "APPLY TO PLAN →"; variant: "outline" }
}
```

## Variants

- `soft` — muted `#F7F8FA` background + `#E2E8F0` border, mono 10.5 px text
  in `#4A5568`. 22 px tall. Matches the handoff's suggested-prompt chips.
- `outline` — transparent background + `#1A202C` border, mono 11 px text
  in `#1A202C`. 26 px tall. Matches the `APPLY TO PLAN →` action chip.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `string` | `""` | Chip label. |
| `variant` | `string` | `"soft"` | `soft` or `outline`. |
| `fontFamily` | `string` | `Tokens.font.mono` | Label typeface. |

Plus everything inherited from `AbstractButton` (`enabled`, `clicked`, etc.).

## Notes

- Source: `report-tab.jsx:128-136` (soft) + `report-tab.jsx:115-122`
  (outline) in the DALI design handoff.
- Adds a subtle tinted hover on both variants so pointer users get feedback
  — the handoff is static on hover, but pearl-kit treats interactive
  controls as deserving of hover states.
