# ToolButton

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=tool-button"
        title="Live ToolButton demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 32×32 icon-only palette button used in clinical tool palettes (pan, zoom,
crosshair, measure, place implant, etc.). Toggles via `checked`; active state
uses a blue-tinted fill + border + icon tint. Native tooltip renders the
label and hotkey.

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
    spacing: 2
    P.ToolButton { label: "Pan";       hotkey: "V"; iconSource: "qrc:/pan.svg" }
    P.ToolButton { label: "Zoom";      hotkey: "Z"; iconSource: "qrc:/zoom.svg" }
    P.ToolButton { label: "Crosshair"; hotkey: "X"; iconSource: "qrc:/crosshair.svg"; checked: true }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `iconSource` | `url` | `""` | Icon source, rendered at 16×16. |
| `label` | `string` | `""` | Tooltip label. |
| `hotkey` | `string` | `""` | Hotkey suffix appended to the tooltip, e.g. "Pan (V)". |
| `checked` | `bool` | `false` | Active state. |

## Signals

- `toggled()` — emitted when the button is clicked (after `checked` flips).

## Notes

- Source: `planning-viewer.jsx:18-28` in the DALI design handoff.
- The handoff tints the icon color itself (`color: #6B7280` / `#2563EB`).
  In QML, `Image` doesn't re-color SVG fills — consumers should either
  supply two icon variants (active / inactive) or use a shader. The
  background + border affordance carry the active state.
