# Tooltip

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/tooltip)'s Tooltip. A small, transient overlay that appears on hover to describe an action or element — inverted surface (`bg-foreground`), 12 px `text-xs` inverted text, 6 × 12 px padding, 6 px radius.

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

P.Button {
    id: btn
    text: "Save"

    P.Tooltip {
        parent: btn
        text: "Save the current file"
        visible: btn.hovered && btn.enabled
    }
}
```

## Basic usage

Tooltip is a standalone popup. Place it as a child of the trigger, set `parent` to the trigger, and bind `visible` to the trigger's `hovered` state:

```qml
P.Button {
    id: saveBtn
    text: "Save"
    P.Tooltip {
        parent: saveBtn
        text: "Save file (⌘S)"
        visible: saveBtn.hovered && saveBtn.enabled
    }
}
```

The `&& saveBtn.enabled` guard suppresses the tooltip on disabled controls — shadcn/HTML convention (disabled elements don't fire events).

## Placement

Tooltip supports four fixed placements via the `placement` property:

```qml
P.Tooltip { placement: "top"    }   // default — above trigger
P.Tooltip { placement: "bottom" }   // below trigger
P.Tooltip { placement: "left"   }   // left of trigger
P.Tooltip { placement: "right"  }   // right of trigger
```

Pick the best side for your layout. Tooltip does **not** auto-flip when the viewport edge is reached (shadcn/Radix does; pearl-kit v0.3.0 ships a deliberate simpler model).

## Delay

`delay` is the time in milliseconds between the visible-binding flipping to `true` and the tooltip actually appearing. shadcn's Radix TooltipProvider defaults to `0` (aggressive); pearl-kit matches:

```qml
P.Tooltip { delay: 0 }      // default — shadcn parity
P.Tooltip { delay: 500 }    // Apple HIG
P.Tooltip { delay: 700 }    // Radix raw default, Windows convention
```

## Wrapping long text

Tooltip defaults to `maxWidth: 320` and `wrapMode: WordWrap`. Long text wraps automatically:

```qml
P.Tooltip {
    text: "A long explanation that spans multiple lines and wraps at the 320 px column so the bubble does not stretch across the entire viewport."
    maxWidth: 280
}
```

For single-line enforcement, override `maxWidth` to a very large number.

## States

| State | Trigger | Visual |
|---|---|---|
| Hidden | `visible: false` (default) | not rendered |
| Visible | `visible: true` | inverted surface fades + scales from 0.95 → 1 over 150 ms |
| Closing | `visible: false` after visible | fades + scales to 0.95 over 150 ms, then removed |

## Accessibility

Tooltip exposes itself as `Accessible.ToolTip` with `Accessible.name` bound to `text`. VoiceOver and screen readers announce the text when the trigger is focused.

For keyboard-only users, bind `visible` to both hover and focus:

```qml
P.Tooltip { visible: btn.hovered || btn.visualFocus }
```

This matches shadcn's `focus-visible:` behavior — Tab navigation reveals the tooltip too.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `text` | `string` | `""` | Tooltip content. Inherited from `T.ToolTip`. |
| `placement` | `string` | `"top"` | One of `"top"`, `"bottom"`, `"left"`, `"right"`. Static — no auto-flip. |
| `maxWidth` | `int` | `320` | Maximum bubble width in pixels; text wraps at this width. |
| `delay` | `int` | `0` | Milliseconds before the tooltip appears after `visible` flips true. |
| `timeout` | `int` | `-1` | Milliseconds until auto-hide; `-1` means no timeout (desktop convention). |
| `visible` | `bool` | `false` | Bind to the trigger's `hovered` (and optionally `visualFocus`) state. |
| `parent` | `Item` | `null` | Set to the trigger control. Tooltip positions itself relative to `parent`'s geometry. |

## Hover-steal edge case

If a tooltip appears to "blink" when the pointer moves over the bubble, the popup window is stealing the trigger's hover state. Rare in practice, but the fix is a `HoverHandler` on the trigger:

```qml
P.Button {
    id: btn
    text: "Save"
    property bool _hovering: false
    HoverHandler { onHoveredChanged: btn._hovering = hovered }
    P.Tooltip { parent: btn; text: "Save"; visible: btn._hovering && btn.enabled }
}
```

## Under the hood

Tooltip is a `QtQuick.Templates.ToolTip` subclass with `background` and `contentItem` overridden. The default `Label` contentItem is replaced with `PearlBaseText` so font family (`SF Pro Display`), weight, size (`Tokens.font.size.xs` = 12 px), and `Text.NativeRendering` match the rest of pearl-kit typography.

Background is a plain `Rectangle` with `color: Tokens.foreground` (inverted) and `radius: Tokens.radius.md` (6 px, shadcn `rounded-md`). Content text color is `Tokens.background` (inverted). In DarkBlue the bubble is near-white (`#E8ECF4`) with very dark text (`#141822`); in Light mode it inverts to dark bubble + light text. Both directions match shadcn's `bg-foreground text-background` semantic.

Enter / exit run parallel fade (0 → 1) + scale (0.95 → 1) `NumberAnimation`s over `Tokens.motion.fast` (150 ms) with `Easing.OutCubic`, matching Tailwind `animate-in fade-in-0 zoom-in-95`. The 2 px `slide-in-from-*-2` modifier shadcn adds per placement is skipped — the delta at 150 ms is imperceptible and keeps the enter transition single-form across all four placements.

Positioning uses explicit `x` / `y` bindings relative to `parent` based on `placement`. No auto-flip: if the tooltip would clip the viewport, the consumer picks a different placement. Auto-flip is a candidate for v0.4.0 if usage patterns demand it.

Width clamping uses `implicitWidth: Math.min(implicitContentWidth + leftPadding + rightPadding, maxWidth)` in concert with `contentItem.width: control.availableWidth`. Text up to `maxWidth` renders on a single line; longer strings wrap at `maxWidth` via `Text.WordWrap`.

No focus ring — tooltips don't receive keyboard focus (`focus: false`, the Popup default).

## Deliberate divergences from shadcn

- **No arrow.** macOS-native tooltip convention; without auto-flip the arrow geometry is non-deterministic. Revisit if user demand emerges.
- **No auto-flip placement.** Fixed 4-direction placement. Consumer responsibility to pick the right side.
- **No `sideOffset` property.** Flush against trigger (shadcn/Radix source default = 0). Consumers override `x` / `y` for custom gap.
- **No enter-animation slide.** Fade + scale only; slide-from-opposite-side skipped for simplicity.
- **No attached `ToolTip.text: "..."`.** Qt's attached `ToolTip.*` API routes through `QQuickStyle`, which requires a C++ plugin. pearl-kit stays pure-QML; standalone `P.Tooltip { }` is the only supported entry point.
- **Consumer-wired visibility.** `visible: trigger.hovered && trigger.enabled` — explicit rather than magical. No `TooltipProvider` / portal / state-machine abstraction layers.
