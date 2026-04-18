# SegmentedControl

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=segmented-control"
        title="Live SegmentedControl demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A grouped button bar for picking one of N mutually exclusive options. Ships
three visual variants extracted from the DALI planning workspace: `pill`
(mode tabs), `bordered` (variant switcher), and `solid` (length grid).

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

P.SegmentedControl {
    variant: "pill"
    current: "plan"
    options: [
        { key: "plan",   label: "Plan" },
        { key: "guide",  label: "Guide" },
        { key: "review", label: "Review" },
        { key: "report", label: "Report" }
    ]
    onChanged: (key) => console.log("picked", key)
}
```

## Variants

- `pill` — light muted background (`#F1F5F9`), active tab on white with blue
  label + soft shadow. Matches the mode-tab style.
- `bordered` — hairline border with 1px dividers between cells; active cell
  filled with the dark ink (`#1A202C`). Matches the variant switcher.
- `solid` — tiles of soft muted with 3px gap; active cell filled primary
  blue. Matches the length-grid used in parameter sliders.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `options` | `var` | `[]` | Array of `{ key, label }`. |
| `current` | `string` | `""` | The `key` of the active option. |
| `variant` | `string` | `"pill"` | One of `pill`, `bordered`, `solid`. |
| `columns` | `int` | `0` | `0` auto-flows; `>0` lays out as a grid with that many columns. |
| `fontFamily` | `string` | `Tokens.font.mono` | Label typeface. |
| `fontPixelSize` | `int` | `11` | Label size. |
| `letterSpacing` | `real` | `0.04 * fontPixelSize` | Matches the handoff's mono letter-spacing. |

## Signals

- `changed(string key)` — emitted when the user picks a different option.

## Notes

- Source: `planning-viewer.jsx:231-254` (pill), `report-tab.jsx:51-72` (bordered),
  `planning-viewer.jsx:407-416` (solid) in the DALI design handoff.
- No keyboard navigation wired yet; consumers requiring keyboard roving
  focus should wrap each cell in an explicit `Item` focus chain.
