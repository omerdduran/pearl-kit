# Group

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=group"
        title="Live Group demo"
        loading="lazy"
        width="100%" height="280"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A sub-section container: a mono uppercase title with a 1 px bottom
border, followed by a content slot. 32 px outer bottom margin provides
vertical rhythm when multiple groups stack in a section. Used
throughout the DALI settings page to chunk fields (`SAFETY THRESHOLDS`,
`PLANNING DEFAULTS`, etc.).

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

Column {
    width: 640
    P.Group {
        title: "IMPLANT BRANDS"
        width: parent.width
        Column {
            width: parent.width
            P.SettingsRow { label: "Primary brand"; width: parent.width; P.Select { } }
            P.SettingsRow { label: "Secondary brand"; width: parent.width; P.Select { } }
        }
    }
    P.Group {
        title: "PLANNING DEFAULTS"
        width: parent.width
        Column {
            width: parent.width
            P.SettingsRow {
                label: "Measurement units"
                width: parent.width
                P.SegmentedControl {
                    variant: "pill"
                    current: "metric"
                    options: [
                        { key: "metric",   label: "Metric" },
                        { key: "imperial", label: "Imperial" }
                    ]
                }
            }
        }
    }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `string` | `""` | Mono uppercase group title; hidden when empty. |
| `titleFontSize` | `int` | `10` | Title pixel size. |
| `titleBottomPadding` | `int` | `8` | Gap between title and the border. |
| `outerBottomMargin` | `int` | `32` | Bottom margin for section rhythm. |
| `titleColor` | `color` | `#9CA3AF` | Title color. |
| `borderColor` | `color` | `#E2E8F0` | Bottom hairline color. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Title typeface. |

The default property slot accepts any number of children rendered beneath
the title rule.

## Notes

- Source: `settings.jsx:229-238` in the DALI settings handoff.
- Kept distinct from `SectionLabel` (a bare mono uppercase `Text` without
  the border / slot structure) since `Group` is a container, not a label.
