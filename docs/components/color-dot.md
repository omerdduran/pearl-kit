# ColorDot

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=color-dot"
        title="Live ColorDot demo"
        loading="lazy"
        width="100%" height="220"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 22×22 circular color swatch with a 2 px white inner border and a 1 px
outer ring. Used in the DALI settings for the crosshair-color pickers
(axial / coronal / sagittal).

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
    P.ColorDot { color: "#3B82F6"; onClicked: console.log("axial") }
    P.ColorDot { color: "#F87171"; onClicked: console.log("coronal") }
    P.ColorDot { color: "#34D399"; onClicked: console.log("sagittal") }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `color` | `color` | `#2563EB` | Fill color of the inner disc. |
| `size` | `int` | `22` | Outer width / height. |
| `ringColor` | `color` | `#E2E8F0` | Outer ring color. |
| `innerBorderColor` | `color` | `#FFFFFF` | Ring between fill and outer ring. |

## Signals

- `clicked()` — emitted when the swatch is pressed.

## Notes

- Source: `settings.jsx:185-190` in the DALI settings handoff.
