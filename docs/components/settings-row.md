# SettingsRow

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=settings-row"
        title="Live SettingsRow demo"
        loading="lazy"
        width="100%" height="420"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A settings form row: a 200 px label column (with optional hint) on the
left and a single control slot on the right, separated by a 1 px bottom
hairline. When `inline: false`, the label stacks above the control —
useful for long controls that need full-width. Taller and more
opinionated than the stable `FormRow` (which is for compact validation-
driven forms).

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
    P.SettingsRow {
        label: "Full name"
        width: parent.width
        P.Input { placeholderText: "Dr. Mehmet Kaya" }
    }
    P.SettingsRow {
        label: "License number"
        hint: "Shown on reports and the audit trail."
        width: parent.width
        P.SuffixInput { mono: true; text: "TR-DDS-21487" }
    }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `string` | `""` | 13 px `#1A202C` 500 left-column title. |
| `hint` | `string` | `""` | 12 px `#6B7280` description under the label. |
| `inline` | `bool` | `true` | When `false`, label stacks above the control. |
| `labelWidth` | `int` | `200` | Width of the label column (inline mode). |
| `columnGap` | `int` | `24` | Gap between label column and control slot. |
| `verticalPadding` | `int` | `16` | Top & bottom padding around the content. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | Label / hint typeface. |

The default property slot accepts a single control (Input, Select,
Toggle, StatusToggle, ReadoutSlider, etc.).

## Notes

- Source: `settings.jsx:97-111` in the DALI settings handoff.
