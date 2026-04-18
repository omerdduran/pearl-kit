# SaveIndicator

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=save-indicator"
        title="Live SaveIndicator demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 6×6 colored dot followed by a muted mono label. Meant for the "Saved · 14:32"
status in app top-bars. The dot color is driven by `state`.

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

P.SaveIndicator {
    state: "saved"
    text: "Saved · 14:32"
}
```

## States

- `saved` — green `#10B981` (default)
- `saving` — amber `#F59E0B`
- `error` — red `#DC2626`
- `offline` — grey `#9CA3AF`

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `state` | `string` | `"saved"` | One of `saved`, `saving`, `error`, `offline`. |
| `text` | `string` | `""` | Label text beside the dot. |
| `textColor` | `color` | `#6B7280` | Label color. |
| `fontFamily` | `string` | `Tokens.font.mono` | Label typeface. |

## Notes

- Source: `planning-viewer.jsx:258-261` in the DALI design handoff.
