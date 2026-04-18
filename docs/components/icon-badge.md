# IconBadge

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=icon-badge"
        title="Live IconBadge demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A small (default 20×20) rounded square holding a centered icon. Two modes:
a diagonal gradient fill (matches the handoff's AI-suggestion icon badge)
or a solid tinted fill. Four tones: `info`, `warn`, `success`, `primary`.

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
    spacing: 8
    P.IconBadge { tone: "info"; iconSource: "qrc:/sparkles.svg" }
    P.IconBadge { tone: "warn"; gradient: false }
    P.IconBadge { tone: "success"; size: 28; iconSize: 14 }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `iconSource` | `url` | `""` | Icon URL rendered at `iconSize`. |
| `tone` | `string` | `"info"` | `info` / `warn` / `success` / `primary`. |
| `gradient` | `bool` | `true` | Toggle gradient vs solid tinted fill. |
| `size` | `int` | `20` | Outer square width / height. |
| `iconSize` | `int` | `11` | Inner icon width / height. |

## Notes

- Source: `planning-viewer.jsx:461-464` in the DALI design handoff.
- No click interactivity — wrap in `MouseArea` or pair with a `Button` if
  you need it to act like an affordance.
