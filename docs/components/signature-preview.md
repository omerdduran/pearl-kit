# SignaturePreview

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=signature-preview"
        title="Live SignaturePreview demo"
        loading="lazy"
        width="100%" height="240"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 180×54 framed cursive signature preview + outline mono `REDRAW`
button. Used in the DALI settings Profile section; the frame displays
the surgeon's stored signature for embedding on reports, and the
button launches the redraw canvas flow.

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

P.SignaturePreview {
    text: "M.Kaya"
    fontFamilyCursive: "Dancing Script"
    onRedrawRequested: console.log("open canvas")
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `string` | `""` | Signature text to render. |
| `actionLabel` | `string` | `"REDRAW"` | Outline button label. |
| `fontFamilyCursive` | `string` | `"Dancing Script"` | Cursive typeface — set to a bundled font in production. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the action button. |
| `frameWidth` | `int` | `180` | Preview frame width. |
| `frameHeight` | `int` | `54` | Preview frame height. |

## Signals

- `redrawRequested()` — emitted when the `REDRAW` button is clicked.
  Wire to your canvas-capture modal.

## Notes

- Source: `settings.jsx:300-312` in the DALI settings handoff.
- The signature is a text-rendered preview only. Production should
  store the actual stroke capture (SVG / image) and render it through
  an `Image` source — swap the inner `Text` for an `Image` in that
  case.
