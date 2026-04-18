# AvatarStack

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A horizontal row of overlapping circular avatars with an optional
trailing `+` add button. Each avatar is a mono initials chip in a
configurable background / foreground color. Used in the DALI settings
"Team" field.

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

P.AvatarStack {
    avatars: [
        { initials: "MK", background: "#DBEAFE", foreground: "#1E3A8A" },
        { initials: "AS", background: "#FEF3C7", foreground: "#92400E" },
        { initials: "EK", background: "#D1FAE5", foreground: "#065F46" }
    ]
    showAddButton: true
    onAddRequested: console.log("add member")
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `avatars` | `var` | `[]` | Array of `{ initials, background, foreground }`. |
| `showAddButton` | `bool` | `true` | Show trailing `+` affordance. |
| `avatarSize` | `int` | `34` | Circle diameter. |
| `overlap` | `int` | `8` | Horizontal overlap between neighbors. |
| `addSpacing` | `int` | `8` | Gap between last avatar and the add button. |
| `addBorderColor` | `color` | `#CBD5E1` | Add button border color. |
| `addTextColor` | `color` | `#6B7280` | Add button `+` color. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for initials. |

## Signals

- `addRequested()` — emitted when the `+` button is clicked.

## Notes

- Source: `settings.jsx:635-650` in the DALI settings handoff.
- Qt does not natively dash `Rectangle.border`; the handoff uses a
  dashed outline for the add button, but pearl-kit renders it solid at
  2 px for simplicity.
