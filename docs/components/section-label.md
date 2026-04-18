# SectionLabel

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=section-label"
        title="Live SectionLabel demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A mono-uppercase section header, sized for sidebar groups and sub-panel titles. Opinionated — muted foreground, small `xs` size, slight letter-spacing. Drop-in for any place where a plain `Text` would feel too loud.

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

P.SectionLabel { text: "ANALYSIS RESULTS" }
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `string` | — | Inherited from `Text`; the label content. |
| `fontFamily` | `string` | `Tokens.font.mono` | Override the typeface (defaults to mono). |

All other `Text` properties (e.g. `color`, `elide`, `horizontalAlignment`) are available via the base `Text` element.
