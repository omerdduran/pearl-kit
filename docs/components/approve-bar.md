# ApproveBar

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=approve-bar"
        title="Live ApproveBar demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Footer strip for approval flows: count label + progress bar + outline
export button + primary approve button. The approve button is disabled
until `acknowledged >= total`; once `signed: true`, it flips to green and
shows the signed-sent label (default `✓ SIGNED · SENT TO FAB`).

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

P.ApproveBar {
    width: 720
    acknowledged: 3
    total: 5
    onExportRequested: console.log("export pdf")
    onSignRequested: signed = true
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `acknowledged` | `int` | `0` | Number of completed items. |
| `total` | `int` | `0` | Total required items. |
| `signed` | `bool` | `false` | Terminal state — turns sign button green. |
| `signLabel` | `string` | `"SIGN & APPROVE →"` | Pre-sign button label. |
| `signedLabel` | `string` | `"✓ SIGNED · SENT TO FAB"` | Post-sign button label. |
| `exportLabel` | `string` | `"EXPORT PDF"` | Export outline button label. |
| `countLabel` | `string` | `"CHECKLIST"` | Prefix of the count line. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |

## Signals

- `exportRequested()` — emitted when the export button is clicked.
- `signRequested()` — emitted when the sign button is clicked **and**
  `acknowledged >= total` **and** `signed` is still `false`. Consumer sets
  `signed = true` after confirming.

## Notes

- Source: `report-tab.jsx:203-230` in the DALI design handoff.
- No built-in PDF pipeline. Wire `exportRequested()` to your own export
  implementation.
