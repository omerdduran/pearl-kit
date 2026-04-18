# AISuggestionCard

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=ai-suggestion-card"
        title="Live AISuggestionCard demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A tinted info card advertising an AI-generated recommendation: `IconBadge`
+ bold title + model tag + wrapped body + primary action `Button`. Compound
of pearl-kit atoms. Background `#EFF6FF` with border `#DBEAFE` — a tighter
match to the DALI design than the generic `InfoCard` info variant.

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

P.AISuggestionCard {
    width: 280
    title: "AI suggests"
    modelTag: "dali-seg-v3.2"
    body: "Rotate −2° lingual to gain 0.6 mm canal clearance while preserving emergence."
    actionLabel: "Apply suggestion"
    iconSource: "qrc:/sparkles.svg"
    onApplied: console.log("apply")
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `string` | `"AI suggests"` | Bold heading next to the badge. |
| `modelTag` | `string` | `""` | Mono model ID pinned to the top-right. |
| `body` | `string` | `""` | Wrapped suggestion text. |
| `actionLabel` | `string` | `""` | Label for the apply button. When empty, the button is hidden. |
| `iconSource` | `url` | `""` | Icon inside the `IconBadge`. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface. |

## Signals

- `applied()` — emitted when the action button is clicked.

## Notes

- Source: `planning-viewer.jsx:456-473` in the DALI design handoff.
