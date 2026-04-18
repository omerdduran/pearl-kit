# StatusPill

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=status-pill"
        title="Live StatusPill demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A compact tonal pill showing a clinical status — a tinted dot plus a short monospace label. Designed for list items, case rows, and any surface that needs a quick "where is this thing" chip.

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

P.StatusPill {
    text: "Reviewed"
    state: "reviewed"
}
```

## States

```qml
Row {
    spacing: 8
    P.StatusPill { text: "Ready";      state: "ready" }
    P.StatusPill { text: "Processing"; state: "processing" }
    P.StatusPill { text: "Reviewed";   state: "reviewed" }
    P.StatusPill { text: "Neutral";    state: "neutral" }
}
```

- `ready` — green dot + light green fill (default)
- `processing` — amber dot + tinted amber fill
- `reviewed` — blue dot + tinted blue fill
- `neutral` — grey dot + muted fill

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `string` | `""` | Label text. |
| `state` | `string` | `"ready"` | One of `ready` / `processing` / `reviewed` / `neutral`. |
| `fontFamily` | `string` | `Tokens.font.mono` | Override the label typeface. |
