# Toggle

An iOS-style switch — animated rounded-full track with a thumb that slides between on and off states. Ports [shadcn/ui v4 Switch](https://ui.shadcn.com/docs/components/switch) with shadcn-accurate geometry, named `Toggle` for pearl-kit roadmap and DALI migration consistency.

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

Inside your QML:

```qml
import QtQuick
import PearlKit 1.0 as P

P.Toggle {
    checked: true
}
```

## Basic usage

`Toggle` derives from `QtQuick.Templates.Switch`, so the `checked` property is built in and flips on click, Space, or Return. Hook into `onToggled` (or bind `checked` to a model) to react to state changes.

```qml
P.Toggle {
    checked: settings.notificationsEnabled
    onToggled: settings.notificationsEnabled = checked
}
```

## Sizes

Two sizes, matching shadcn/ui exactly.

| Size | Track | Thumb |
|---|---|---|
| `default` | 32 × 18 | 16 × 16 |
| `sm` | 24 × 14 | 12 × 12 |

```qml
Row {
    spacing: 16
    P.Toggle { size: "default" }
    P.Toggle { size: "sm" }
}
```

## States

| State | Trigger | Visual |
|---|---|---|
| Unchecked | `checked: false` | Track = `Tokens.input`, thumb = `Tokens.foreground`, thumb at left inset |
| Checked | `checked: true` | Track = `Tokens.primary`, thumb = `Tokens.primaryForeground`, thumb at right inset |
| Focus (keyboard) | Tab | 3 px ring at `Tokens.ring / 50%`, offset 0, wraps rounded-full track |
| Disabled | `enabled: false` | Track opacity 50% (cascades to thumb); focus ring unaffected |

Hover and pressed states do not change the track color — shadcn/ui has no hover delta on `Switch`, and pearl-kit follows suit.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `checked` | `bool` | `false` | On/off state (inherited from `T.Switch`) |
| `size` | `string` | `"default"` | `default` or `sm` |
| `enabled` | `bool` | `true` | Disables interaction; visually fades the track and thumb |

Everything else is whatever `QtQuick.Templates.Switch` exposes — `onToggled`, `onClicked`, `pressed`, `hovered`, etc.

## Animation

- `Behavior on x` on the thumb uses `NumberAnimation` with `Tokens.motion.fast` (150 ms) and `Easing.OutCubic` — the same duration shadcn uses via Tailwind's default `transition-transform`.
- `Behavior on color` on both the track and the thumb handles the checked/unchecked color transition.

## Accessibility

- `focusPolicy: Qt.StrongFocus` — focusable via Tab and click.
- Space / Return toggles `checked` (inherited from `T.Switch`).
- Focus ring appears only on keyboard focus (`visualFocus`), matching shadcn's `focus-visible:` selector — clicking doesn't leave a visual ring, per Apple HIG convention.
- Disabled state sets `enabled: false` on the root control, which Qt's a11y layer exposes to screen readers.

## Under the hood

`Toggle` is a `QtQuick.Templates.Switch` with a custom `indicator` slot:

- The `indicator` is a rounded-full `Rectangle` (the track). Its `color` is bound to `control.checked`.
- The thumb is a child `Rectangle` of the track. Its `x` position is bound to `control.checked` via a ternary, and animated with `Behavior on x`.
- Disabled state applies `opacity: 0.5` only to the track; the thumb, being a child, inherits the fade.
- The focus ring uses `PearlFocusRing` with `target: control.indicator` (not `target: control`). This is important — `PearlFocusRing` reads `target.radius` to match the target shape, and the track's `radius: height / 2` (rounded-full) must be used. Targeting `control` directly would fall back to `Tokens.radius.md` (6 px) and draw a mismatched rectangular ring around the pill track.
- The focus ring is declared as a child of `control`, not of the indicator, so `indicator.opacity: 0.5` (disabled) does not fade the ring. `PearlFocusRing` uses `anchors.fill: target` to wrap the indicator visually without being its child.

## Deliberate differences from shadcn

1. **Name**: shadcn calls this `Switch`; pearl-kit calls it `Toggle` to match the DALI migration checklist and the pearl-kit v0.1.0 roadmap.
2. **Thumb color formula**: shadcn's light-mode thumb is always `bg-background` (white); pearl-kit uses `Tokens.foreground` (dark) for the unchecked thumb across all themes. In Light mode this produces higher contrast against the pale `Tokens.input` track than shadcn's white-on-white approach.
3. **Track unchecked background**: shadcn applies `dark:bg-input/80` (80% alpha in dark modes); pearl-kit uses full-alpha `Tokens.input` across all modes. The DarkBlue palette's `Tokens.input` is already sufficiently distinct from the background without alpha compositing.
4. **No `shadow-xs`**: shadcn applies a subtle 1-layer shadow to the track; pearl-kit skips it. The control is small enough that the shadow adds little visual signal, and `Tokens.shadow.*` is a two-layer system that's overkill here.

## Related

- [Button](button.md) — for triggering actions rather than representing state
- [Input](input.md) — for text entry
