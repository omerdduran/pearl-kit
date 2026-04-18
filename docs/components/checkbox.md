# CheckBox

A two- or three-state checkbox — 16×16 rounded square with an animated check or dash glyph. Ports [shadcn/ui v4 Checkbox](https://ui.shadcn.com/docs/components/checkbox) with a pearl-kit extension for the `tristate` / indeterminate state.

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

Inside QML:

```qml
import QtQuick
import PearlKit 1.0 as P

P.CheckBox {
    checked: true
}
```

## Basic usage

`CheckBox` derives from `QtQuick.Templates.CheckBox`. Click or Space toggles `checked`. Bind `checked` to a model or wire `onCheckedChanged` for side effects.

```qml
P.CheckBox {
    checked: settings.notifications
    onCheckedChanged: settings.notifications = checked
}
```

## Composition with a label

shadcn and pearl-kit both leave label composition to the consumer — wire a `MouseArea` on the label text that calls `toggle()` on the checkbox:

```qml
Row {
    spacing: 8
    P.CheckBox { id: cb }
    P.PearlText {
        text: "Accept terms"
        variant: "body"
        anchors.verticalCenter: parent.verticalCenter
        MouseArea { anchors.fill: parent; onClicked: cb.toggle() }
    }
}
```

## Tristate (indeterminate)

Set `tristate: true` to enable the third state (`Qt.PartiallyChecked`). Rendered as a horizontal dash — useful for "select all" group headers when only some children are checked.

```qml
P.CheckBox {
    tristate: true
    checkState: Qt.PartiallyChecked
}
```

Click cycles `Unchecked → PartiallyChecked → Checked → Unchecked` via `T.CheckBox.nextCheckState()`. Override `nextCheckState` for a custom order.

## States

| State | Trigger | Visual |
|---|---|---|
| Unchecked | `checked: false` | Transparent bg (light), `input @ 30 %` (dark); `Tokens.input` border |
| Checked | `checked: true` | `Tokens.primary` bg + border, check glyph in `primaryForeground` |
| Indeterminate | `tristate: true; checkState: Qt.PartiallyChecked` | `Tokens.primary` bg + border, dash glyph in `primaryForeground` |
| Focus (keyboard) | Tab | 3 px ring at `Tokens.ring / 50 %`, offset 0, radius matches box (4 px) |
| Error | `error: true` | Border `destructive`; focus ring `destructive / 20 %` (light) or `/ 40 %` (dark) |
| Disabled | `enabled: false` | Indicator opacity 50 %; focus ring unaffected |

State transitions snap instantly (no `Behavior on color`) — matches shadcn's `transition-none` on the indicator. Pointer hover and keyboard Space-down do not produce a visual delta.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `checked` | `bool` | `false` | On / off state (inherited from `T.CheckBox`) |
| `checkState` | enum | `Qt.Unchecked` | `Qt.Unchecked` / `Qt.Checked` / `Qt.PartiallyChecked` (inherited) |
| `tristate` | `bool` | `false` | Enables `Qt.PartiallyChecked` (inherited) |
| `error` | `bool` | `false` | Switches border + focus ring to `destructive` |
| `enabled` | `bool` | `true` | Disables interaction; fades the box |

Everything else is whatever `QtQuick.Templates.CheckBox` exposes — `toggle()`, `onToggled`, `pressed`, `hovered`, etc.

## Accessibility

- `focusPolicy: Qt.StrongFocus` — focusable via Tab and click.
- Space toggles `checked` (or advances `checkState` in tristate mode).
- Focus ring appears only on keyboard focus (`visualFocus`), matching shadcn's `focus-visible:` selector — mouse clicks do not leave a visible ring.
- `enabled: false` propagates to Qt's accessibility layer.

## Under the hood

`CheckBox` is a `QtQuick.Templates.CheckBox` with:

- **`indicator`**: a `Rectangle` (16×16, `Tokens.radius.sm`, 1 px border) centered with `y: (control.height - height) / 2`. Its color and border resolve from `checkState` + `error` via `_bgColor` / `_borderColor` resolver properties.
- **Check glyph**: a `PearlCheckIcon` (internal Canvas atom) centered inside the indicator at 14×14. `mode: "check"` draws the lucide-style checkmark; `mode: "dash"` draws a horizontal bar for `Qt.PartiallyChecked`.
- **`contentItem`**: a zero-sized `Item` to force indicator-only rendering — `T.CheckBox.text` is deliberately not rendered.
- **Focus ring**: a `PearlFocusRing` with `target: control.indicator` so the ring's radius matches the box's 4 px corner.
- **Disabled strategy**: `indicator.opacity: 0.5` (not root `control.opacity` — the focus ring is a sibling of `indicator` and would inherit the fade).

## Deliberate differences from shadcn

1. **Indeterminate (tristate) state** — shadcn stylizes only checked / unchecked, but the Radix primitive supports `indeterminate`, and pearl-kit implements it as a dash glyph. Useful for "select all" group headers.
2. **No label slot** — shadcn composes labels externally via `<Label>`. Pearl-kit mirrors this; `T.CheckBox.text` is not rendered. Compose with a `MouseArea`-wrapped `PearlText` sibling.
3. **No color transition** — shadcn's indicator has `transition-none`. Pearl-kit does not add `Behavior on color` to the indicator, even though `Input` and `Select` do. The state change is discrete; animation would feel laggy.
4. **Focus ring trigger** — `visualFocus` (keyboard-only), matching shadcn's `focus-visible:`. Mouse clicks don't show a visible ring.

## Related

- [Toggle](toggle.md) — for binary on/off state where a sliding switch fits better
- [Button](button.md) — for actions rather than state
