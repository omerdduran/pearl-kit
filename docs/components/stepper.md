# Stepper

A numeric input with dedicated decrement / increment buttons — `[−]  value  [+]`. Supports integer and floating-point values, custom suffixes (`%`, `px`, `mm`), and a `specialValueText` shown when the value is at its minimum.

Pearl-kit's first deliberate derivative — shadcn/ui does not ship a stepper primitive. The visual language is composed from pearl-kit's `Input` (36 px track, rounded-md, 1 px border) and ghost `Button` (hover accent tint). Behavior mirrors the DALI desktop app's `DaliStepper` / `DaliDoubleStepper`: auto-repeat on hold, clamped at edges, special "Auto" text at the minimum.

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

P.Stepper {
    from: 0
    to: 100
    value: 50
    stepSize: 5
    suffix: "%"
}
```

## Basic usage

`Stepper` is driven by its `value` property. Bind `onValueChanged` or bind `value` to a model.

```qml
P.Stepper {
    from: 0
    to: 10
    value: settings.zoomLevel
    onValueChanged: settings.zoomLevel = value
}
```

## Integer vs floating-point

Set `decimals` to `0` (default) for integer values, `1..3` for floating-point.

```qml
// integer 0..100, step 1
P.Stepper {
    from: 0; to: 100; value: 50
}

// float 0..10 with 2 decimals, step 0.1
P.Stepper {
    from: 0; to: 10; decimals: 2; stepSize: 0.1
    value: 2.5
}
```

`decimals` is capped at 3 internally — beyond that, integer scaling for `T.SpinBox` risks 32-bit overflow when combined with a large `to`. If you need very high precision, consider representing the value in smaller units (e.g. millimeters instead of meters).

## Suffix and specialValueText

```qml
P.Stepper {
    from: 0; to: 100
    value: 50
    suffix: "%"
}
// renders: [−]  50%  [+]

P.Stepper {
    from: 0; to: 1000
    specialValueText: "Auto"
}
// at value 0: renders: [−]  Auto  [+]
// at any other value: renders the number + suffix
```

While editing (the line edit has focus), the suffix is stripped so the user types a plain number. On blur, the format is re-applied.

## States

| State | Trigger | Visual |
|---|---|---|
| Default | nothing | 1 px `Tokens.border`; transparent bg (light) or `Tokens.input @ 30%` (dark) |
| Focus | line edit focused | 3 px ring at `Tokens.ring / 50%`, border → `Tokens.ring` |
| Hover on button | pointer over `[−]` or `[+]` | That button tinted `Tokens.accent @ 40%`; pressed deepens to `60%` |
| At edge | `value == from` or `value == to` | That edge's button disabled, opacity 40% |
| Error | `error: true` | Border → `Tokens.destructive`; focus ring → `destructive / 20%` (light) or `/ 40%` (dark) |
| Disabled | `enabled: false` | Background opacity 50% |

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `from` | `real` | `0` | Minimum value |
| `to` | `real` | `100` | Maximum value |
| `value` | `real` | `0` | Current value; always clamped to `[from, to]` |
| `stepSize` | `real` | `1` | Amount added / subtracted per button press or arrow keypress |
| `decimals` | `int` | `0` | Number of decimal digits (`0` = integer, `1..3` = float) |
| `suffix` | `string` | `""` | Appended to the displayed value (e.g. `"%"`, `"px"`) |
| `specialValueText` | `string` | `""` | Shown instead of the number when `value == from` |
| `editable` | `bool` | `true` | Whether the line edit accepts typing |
| `error` | `bool` | `false` | Switches border + focus ring to `destructive` |
| `enabled` | `bool` | `true` | Disables interaction; fades the whole control |

## Keyboard

- **Up / Down**: step once in the corresponding direction.
- **Hold Up / Down on a button**: auto-repeat via the native `T.SpinBox` pressed signal, Qt's platform style delay and interval.
- **Escape**: while editing, reverts to the previous display value and blurs.
- **Enter / Return**: while editing, commits the typed value (runs `valueFromText`, clamps, and re-formats).

## Accessibility

- `activeFocusOnTab: true` — the whole stepper is Tab-focusable.
- Focus ring appears on any focus source (`activeFocus`), matching pearl-kit's `Input` pattern — text inputs need caret feedback whether focused via click or keyboard.
- `enabled: false` propagates to Qt's accessibility layer.

## Under the hood

`Stepper` is an `Item` wrapper around a `QtQuick.Templates.SpinBox`. The wrapper exists because:

- `T.SpinBox.value` is an `int`. To expose a single `value: real` with floating-point support, the wrapper hides an internal integer-scaling layer — `decimals: 2` stores `Math.round(value * 100)` as the SpinBox's native int value.
- User edits (button press, arrow key, typing) fire `T.SpinBox.onValueModified`, and the handler pushes the unscaled float back into the public `value` property. Declarative bindings on `value` only flow one-way (public → internal), preventing infinite loops.
- `up.indicator` and `down.indicator` are overridden as plain `Rectangle`s at fixed 32 px width, docked to the right and left edges via manual `x` positioning (`T.SpinBox` does not auto-layout its indicators like `T.CheckBox` does).
- The background and contentItem are styled like `Input.qml` — 1 px border, `Tokens.radius.md`, 14 px text, centered horizontally.
- `textFromValue` / `valueFromText` hooks handle format round-trip: `textFromValue` applies `toFixed(decimals) + suffix`, and checks `specialValueText` for the minimum-value override; `valueFromText` strips the suffix and parses via `Number.fromLocaleString` so European decimal separators work.

## Deliberate differences from shadcn

shadcn/ui has no stepper primitive — this component is a pearl-kit derivative composed from shadcn-language primitives. Design choices:

1. **Single `value: real` API** — Qt's native `SpinBox.value` is `int`. Pearl-kit wraps it with integer scaling so consumers always work in the natural units of their domain (`2.5` not `250`). `decimals == 0` behaves like an integer value transparently.
2. **`decimals` capped at 3** — `Math.pow(10, 4) * to > INT_MAX` at modest maximum values. Three decimals covers every DALI use case (zoom levels, thresholds, dimensions).
3. **Ghost-button hover tint** — `Tokens.accent` at 40% / 60% for hover / press, mirroring the Button `ghost` variant. CheckBox deliberately skips hover affordance (state, not action); Stepper's buttons are action targets, so they need it.
4. **No wrap-around** — at the edges, buttons disable (DALI default). Qt's `wrap: true` is not exposed.

## Related

- [Input](input.md) — for free-form text input
- [Button](button.md) — the ghost variant is the visual source for the stepper's edge buttons
- [Select](select.md) — for picking from a discrete set instead of a continuous range
