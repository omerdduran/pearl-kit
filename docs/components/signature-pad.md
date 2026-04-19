# SignaturePad

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=signature-pad"
        title="Live SignaturePad demo"
        loading="lazy"
        width="100%" height="280"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Profile-step "Tap to sign" affordance: 64 px tall dashed rectangle that
renders a mono `DRAW SIGNATURE` placeholder when unsigned and cursive ink
(Dancing Script by default) when signed, with a side outline button
(`OPEN CANVAS` / `REDRAW`).

**This is visual-only.** Actual stroke capture is the consumer's
responsibility — wire `requestRedraw()` to your canvas modal and toggle
`signed` from the captured payload.

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

P.SignaturePad {
    width: 480
    signed: surgeonProfile.hasSignature
    signatureText: surgeonProfile.cursiveText
    onRequestRedraw: signatureCanvas.open()
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `signed` | `bool` | `false` | Toggles between unsigned (mono placeholder, dashed grey border) and signed (cursive text, accent dashed border, accent-tinted bg). |
| `signatureText` | `string` | `""` | Cursive text rendered when `signed` is true. |
| `placeholder` | `string` | `"DRAW SIGNATURE"` | Mono placeholder shown when unsigned. |
| `drawLabel` | `string` | `"OPEN CANVAS"` | Button label when unsigned. |
| `redrawLabel` | `string` | `"REDRAW"` | Button label when signed. |
| `accentColor` | `color` | `#2563EB` | Border + fill tint when signed. |
| `signedTextColor` | `color` | `#1E3A8A` | Cursive text color when signed. |
| `padHeight` | `int` | `64` | Pad rectangle height. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for placeholder + button. |
| `fontFamilyCursive` | `string` | `"Dancing Script"` | Cursive typeface — bundle Dancing Script (or substitute) in production. |

## Signals

- `requestRedraw()` — emitted when the side button is clicked, in both signed and unsigned states. Open your signature-capture modal here.

## Notes

- Source: `onboarding.jsx:219-239` in the DALI onboarding handoff.
- For a smaller settings-page preview frame see [`SignaturePreview`](signature-preview.md).
- The dashed border is rendered via a `Canvas` element so the dash pattern is consistent across platforms.
