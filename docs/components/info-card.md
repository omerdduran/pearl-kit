# InfoCard

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=info-card"
        title="Live InfoCard demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A tinted informational card — four tones (`info` / `warning` / `success` / `neutral`) over a muted background with a matching border. For pre-flight messages, warnings, and helper callouts inside panels.

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

P.InfoCard {
    tone: "warning"
    Text {
        text: "Low bone density region — review before placing implants."
        wrapMode: Text.WordWrap
        width: 280
    }
}
```

Children go into the default content slot (`Column`) — text, icons, sub-components, all flow vertically.

## Tones

| Tone | Use for |
|------|---------|
| `info` | Neutral informational callouts. |
| `warning` | Non-blocking warnings. |
| `success` | Completion / confirmation. |
| `neutral` | Documentation-style hints. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `tone` | `string` | `"info"` | One of `info` / `warning` / `success` / `neutral`. |
| `padding` | `int` | `12` | Inner padding around the content slot. |
| `radius` | `int` | `6` | Corner radius. |
