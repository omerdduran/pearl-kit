# StatusToggle

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 34×18 pill toggle with a 14×14 white thumb plus a mono uppercase
status label to the right. Used throughout the DALI settings form for
binary preferences; `labelOn` / `labelOff` let callers customize the
label text (default `ON` / `OFF`; security section uses
`Enabled` / `Disabled`).

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
    spacing: 12
    P.StatusToggle { checked: true }
    P.StatusToggle {
        checked: true
        labelOn: "Enabled"
        labelOff: "Disabled"
    }
    P.StatusToggle { checked: false }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `checked` | `bool` | `false` | Toggle state. |
| `labelOn` | `string` | `"ON"` | Label text when checked; auto-uppercased. |
| `labelOff` | `string` | `"OFF"` | Label text when unchecked; auto-uppercased. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Label typeface. |

## Signals

- `toggled()` — emitted after `checked` flips on click.

## Notes

- Source: `settings.jsx:145-165` in the DALI settings handoff.
- Kept separate from the stable `Toggle` since its label affordance is
  distinct.
