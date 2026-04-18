# TopMetaStrip

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=top-meta-strip"
        title="Live TopMetaStrip demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A hairline top strip — thin bar with a left label and a right label, separated by a 1 px bottom border. For app-chrome metadata: scan IDs, timestamps, environment tags.

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

P.TopMetaStrip {
    width: 640
    leftText: "SCAN · A-0042"
    rightText: "2026-04-18 · 14:32"
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `leftText` | `string` | `""` | Left-aligned label. |
| `rightText` | `string` | `""` | Right-aligned label. |
| `textColor` | `color` | `#8A93A0` | Label color. |
| `borderColor` | `color` | `#ECEEF2` | Bottom hairline color. |
| `monoFontFamily` | `string` | `Tokens.font.mono` | Font. |
