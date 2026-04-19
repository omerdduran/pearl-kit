# ThemeTile

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=theme-tile"
        title="Live ThemeTile demo"
        loading="lazy"
        width="100%" height="280"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 120 px theme picker tile: 70 px preview box rendering a serif `Aa`
glyph on the theme's background, plus a mono label underneath. Active
state adds a 2 px blue border + 3 px outer glow and strengthens the
label.

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
    spacing: 10
    P.ThemeTile {
        label: "Light"
        previewBackground: "#FFFFFF"
        inkColor: "#1A202C"
        checked: true
    }
    P.ThemeTile {
        label: "Dark"
        previewBackground: "#0B1120"
        inkColor: "#F1F5F9"
    }
    P.ThemeTile {
        label: "Match system"
        previewBackground: "#EEF2F6"
        inkColor: "#2563EB"
    }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `string` | `""` | Mono caption under the preview; auto-uppercased. |
| `previewBackground` | `color` | `#FFFFFF` | Preview fill color. |
| `inkColor` | `color` | `#1A202C` | Serif glyph color. |
| `previewGlyph` | `string` | `"Aa"` | Glyph shown in the preview. |
| `checked` | `bool` | `false` | Active state. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the label. |
| `fontFamilySerif` | `string` | `"Times New Roman"` | Serif typeface for the glyph. |

## Signals

- `clicked()` — emitted when the tile is pressed.

## Notes

- Source: `settings.jsx:756-780` in the DALI settings handoff.
- The handoff uses a CSS linear-gradient for the "match system" tile's
  preview. Qt's `Rectangle.color` is a single color; for a split-fill
  preview you can layer two `Rectangle`s inside a wrapping `ThemeTile`.
  Not shipped as a built-in — keeps the API small.
