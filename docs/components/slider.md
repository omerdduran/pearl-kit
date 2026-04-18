# Slider

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=slider"
        title="Live Slider demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A port of [shadcn/ui](https://ui.shadcn.com/docs/components/slider)'s Slider — single-thumb continuous value selection with horizontal + vertical orientation and optional tick marks.

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

P.Slider {
    from: 0
    to: 100
    value: 50
    onValueChanged: console.log("value:", value)
}
```

## Basic usage

```qml
P.Slider {
    from: 0
    to: 100
    value: 40
    stepSize: 1
}
```

Width defaults to 200 px. In layouts, prefer setting `Layout.preferredWidth` (horizontal) or `Layout.preferredHeight` (vertical) explicitly.

## Orientation

```qml
P.Slider {
    orientation: Qt.Horizontal   // default
    from: 0; to: 100; value: 50
}

P.Slider {
    orientation: Qt.Vertical
    from: 0; to: 100; value: 50
}
```

Vertical sliders fill **bottom-to-top** — lower values render near the bottom of the track, higher values toward the top. This matches iOS / macOS volume controls and is the natural expectation for medical imaging window/level scales.

Default sizes:

| Orientation | Implicit width | Implicit height |
|---|---|---|
| `Qt.Horizontal` | `200` | `20` |
| `Qt.Vertical` | `20` | `176` |

176 px matches shadcn's `min-h-44` minimum vertical length.

## Wide ranges

Pearl-kit Slider supports large numeric ranges without special handling. The classic use case is medical window/level:

```qml
P.Slider {
    from: 0
    to: 6000
    value: 2048
    stepSize: 50
}
```

No `decimals` property is needed — `stepSize` accepts reals, so `0.01` works for opacity-style 0..1 sliders.

## Tick marks

Ticks are opt-in.

```qml
P.Slider {
    from: 0; to: 100
    stepSize: 10
    showTicks: true
}
```

When `showTicks: true` and `tickCount === 0`, pearl-kit computes the count from `(to - from) / stepSize + 1`, capped at 21. Set `tickCount` explicitly to override:

```qml
P.Slider {
    from: 0; to: 6000
    showTicks: true
    tickCount: 7           // 0, 1000, 2000, ..., 6000
}
```

Ticks render 1 × 4 px in `Tokens.mutedForeground`, 4 px off the far side of the track (below horizontal, right of vertical).

## Disabled

```qml
P.Slider {
    from: 0; to: 100
    value: 25
    enabled: false
}
```

50 % opacity on track + handle. Drag, hover, keyboard interaction all suppressed. Focus ring stays crisp.

## States

| State | Trigger | Visual |
|---|---|---|
| Default | Idle | Track `Tokens.muted`, range `Tokens.primary`, 16 × 16 white thumb with `Tokens.primary` border |
| Pressed | Pointer down or keyboard Space | Thumb scales to 1.05× |
| Focused (keyboard) | Tab | 4 px ring @ `ring/50` around the thumb |
| Focused (pointer) | Mouse click | No ring — matches Button / Toggle convention |
| Disabled | `enabled: false` | 50 % opacity, all input suppressed |

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `from` | `real` | `0` | Lower bound |
| `to` | `real` | `100` | Upper bound |
| `value` | `real` | `0` | Current value |
| `stepSize` | `real` | `0` | Step increment (0 = continuous) |
| `snapMode` | `enum` | `Slider.SnapOnRelease` | Where snapping happens |
| `orientation` | `enum` | `Qt.Horizontal` | `Qt.Horizontal` or `Qt.Vertical` |
| `enabled` | `bool` | `true` | Toggles disabled visuals |
| `showTicks` | `bool` | `false` | Renders tick marks on the far side of the track |
| `tickCount` | `int` | `0` | Explicit tick count. `0` = auto from `stepSize` (max 21) |

### Inherited signals

| Signal | When |
|---|---|
| `valueChanged()` | Value property changes (drag, keyboard, programmatic) |
| `moved()` | User-initiated value change only (not programmatic) |
| `pressedChanged()` | Pointer press state flips |

## Accessibility

- **Keyboard** — `Left` / `Right` (horizontal) or `Up` / `Down` (vertical) step by `stepSize` (or 1 if `stepSize === 0`). `PageUp` / `PageDown` step by 10 × `stepSize`. `Home` / `End` jump to `from` / `to`.
- **Focus** — Tab navigable. Ring appears only on keyboard focus (`visualFocus`), matching Button and Toggle.
- **Screen reader** — `Accessible.role: Accessible.Slider`, `Accessible.focusable: true`. Value is auto-published by `QtQuick.Templates.Slider` — no manual `Accessible.value` binding.

## Under the hood

`QtQuick.Templates.Slider` base. The `contentItem` is untouched (unused by `T.Slider`). Two slots overridden:

- **`background`** — a `Rectangle` that acts as the track. Inside it: a second `Rectangle` bound to `control.position` renders the filled range, and an optional `Repeater` draws tick marks. Orientation-aware bindings swap the thin / long axes without relying on T.Slider (which does **not** swap geometry automatically on orientation flip).
- **`handle`** — a 16 × 16 white `Rectangle` with a 1 px `Tokens.primary` border and `radius: width / 2` for a perfect circle. `x` and `y` are bound to `control.visualPosition`, computed manually (T.Slider does not set handle position automatically).

Focus ring is a sibling `PearlFocusRing` targeting `control.handle` — as the thumb moves, the ring follows via `anchors.fill: target`. Ring width 4 px matches shadcn's `ring-4`, color is `Tokens.ring @ 50%`.

Vertical fill direction is **bottom-to-top**. T.Slider's `position` is monotonic 0..1 from `from` to `to`; for vertical orientation the range `Rectangle` anchors its `y` to `parent.height - height` and binds `height: position * parent.height` to invert the draw direction.
