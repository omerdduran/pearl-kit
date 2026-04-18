# ProgressBar

A thin, pill-shaped horizontal progress indicator. Ports [shadcn/ui v4 Progress](https://ui.shadcn.com/docs/components/progress) with an added `indeterminate` mode for operations of unknown duration.

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

P.ProgressBar {
    width: 240
    value: 42
}
```

## Basic usage

`ProgressBar` derives from `QtQuick.Templates.ProgressBar`, so `from`, `to`,
`value`, and `visualPosition` are the native Qt properties you already know. By
default `from = 0`, `to = 100`, `value = 0` — pass a percent-style int directly
and you're done.

```qml
P.ProgressBar {
    width: 320
    value: downloadedPercent
}
```

Any valid Qt `value` binding animates smoothly — changes transition at
`Tokens.motion.fast` (150 ms) with `Easing.OutCubic`, matching shadcn's
`transition-all` default.

## Indeterminate

When the duration of the operation is unknown (background worker running,
network stream opening, unbounded process), set `indeterminate: true`. A 40%-
wide bar slides across the track on a 1800 ms infinite loop, using
`Easing.InOutCubic` so it accelerates into and decelerates out of each pass.

```qml
P.ProgressBar {
    width: 320
    indeterminate: true
}
```

Flip `indeterminate` back to `false` (and optionally bind a real `value`) once
the operation becomes bounded. The two indicators are visibility-gated, so
there's no cross-animation during the switch — the sliding bar disappears
instantly and the determinate bar takes over.

## Custom ranges

`from` and `to` accept any real values, not just the 0–100 default. The
built-in `visualPosition` (read-only, always `0..1`) does the normalization
internally — your fill width scales correctly regardless of the value units.

```qml
P.ProgressBar {
    width: 320
    from: 0
    to: 8388608          // 8 MiB
    value: bytesReceived
}
```

## States

| State | Trigger | Visual |
|---|---|---|
| Empty | `value == from` | Track only, indicator at `x = -width` |
| Partial | `from < value < to` | Indicator translated by `-(1 - visualPosition) * width` |
| Full | `value == to` | Indicator flush with track, `x == 0` |
| Indeterminate | `indeterminate: true` | 40% bar sliding left→right on 1800 ms loop |
| Disabled | `enabled: false` | Track + indicator at 50% opacity |

There is no hover, pressed, or focus state — `ProgressBar` is read-only and
non-interactive. `focusPolicy: Qt.NoFocus` explicitly excludes it from Tab
order.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `from` | `real` | `0` | Minimum of the value range (inherited from `T.ProgressBar`) |
| `to` | `real` | `100` | Maximum of the value range (pearl-kit default; `T.ProgressBar` defaults to `1`) |
| `value` | `real` | `0` | Current progress value (inherited from `T.ProgressBar`) |
| `visualPosition` | `real` (read-only) | `0` | Normalized 0..1 position; `(value − from) / (to − from)` |
| `indeterminate` | `bool` | `false` | When `true`, shows the 40%-wide sliding animation (pearl-kit extension) |
| `enabled` | `bool` | `true` | When `false`, fades to 50% opacity |

Everything else is whatever `QtQuick.Templates.ProgressBar` exposes.

## Accessibility

`T.ProgressBar` sets the appropriate `Accessible.role` (ProgressBar) and
exposes `value`, `from`, `to` to assistive technology automatically. When
`indeterminate: true`, the role remains ProgressBar but the value reads as
indeterminate — Qt forwards this to the platform a11y layer for you.

Since ProgressBar is read-only there is no focus ring, no keyboard activation,
and no hover target — consistent with HTML `<progress>` semantics.

## Under the hood

`ProgressBar` is a `QtQuick.Templates.ProgressBar` with two slots overridden:

- **`background`** — a pill `Rectangle` (`radius: height / 2`) painted at
  `Tokens.primary @ 20% alpha` (shadcn `bg-primary/20`). `clip: true` mirrors
  shadcn's `overflow-hidden` so indicator bleeds get trimmed at the track
  radius.
- **`contentItem`** — zeroed (`Item { }`) because the fill is painted inside
  `background` so a single clip region covers both indicator modes cleanly.

Inside the background, two indicator rectangles live:

- **Determinate indicator** — same width as the track, translated left by
  `-(1 - visualPosition) * width`. At `value == to`, `x == 0`; at `value ==
  from`, `x == -width`. This mirrors shadcn's `translateX(-${100 - value}%)`
  technique exactly and gives free radius rounding on the right edge because
  the track's clip mask handles the shape. `Behavior on x` uses `Tokens.motion.fast`
  (150 ms) `Easing.OutCubic`.
- **Indeterminate indicator** — 40% of track width, animated from
  `-indicator.width` to `track.width` on a 1800 ms `Easing.InOutCubic`
  infinite-loop `NumberAnimation`. The `running:` gate turns the animation on
  only when `indeterminate && visible` so CPU stays quiet in the default case.

Disabled state applies `opacity: 0.5` to the `background` rectangle (the track
plus its indicator children inherit), never to the root control. There's no
focus ring to preserve here, but the rule is kept consistent with the rest of
the kit.

## Deliberate differences from shadcn

1. **`indeterminate` mode** — shadcn's Progress only supports determinate state
   (`value || 0` defaults undefined to 0, which renders as empty). pearl-kit
   adds a 40%-wide sliding bar on a 1800 ms InOutCubic loop because DALI's
   worker-status call sites have no known completion target.
2. **Default `to: 100`** — `T.ProgressBar`'s native default is `to: 1` (so
   `value: 0.5` means 50%). pearl-kit overrides to `to: 100` to match shadcn's
   0..100 value convention, which is more user-friendly for UI code ("50" reads
   clearly as 50%).
3. **`implicitWidth: 200`** — shadcn is `w-full`; QML doesn't have a direct
   equivalent, so pearl-kit sets 200 px as a sensible default. Consumers pass
   `Layout.fillWidth: true` or an explicit `width` for responsive sizing.

## Related

- [Splitter](splitter.md) — for resizable panel layouts
- [ScrollArea](scroll-area.md) — for scrollable content with indicators
- [Card](card.md) — a common container for status dashboards that pair with progress indicators
