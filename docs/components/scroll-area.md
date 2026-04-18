# ScrollArea

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=scroll-area"
        title="Live ScrollArea demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/scroll-area)'s ScrollArea. A scrollable viewport with thin, rounded, auto-hiding scrollbars that match pearl-kit's token set.

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
import QtQuick.Layouts
import PearlKit 1.0 as P

P.ScrollArea {
    Layout.fillWidth: true
    Layout.preferredHeight: 240

    Rectangle {
        width: 400
        height: 800
        color: P.Tokens.card
    }
}
```

## Basic usage

```qml
P.ScrollArea {
    width: 320
    height: 200

    Column {
        width: parent.width
        spacing: 8
        Repeater {
            model: 20
            P.PearlText { text: "Row " + (index + 1) }
        }
    }
}
```

Children are placed inside an internal `Flickable` automatically — standard `T.ScrollView` semantics. Pass one or more Items as children, and `ScrollArea` handles the viewport, clipping, and scrollbar wiring for you.

## Auto-hide vs. always-on scrollbars

`ScrollArea` defaults to Radix-style auto-hide behavior — both scrollbars stay invisible until the user hovers the area or starts scrolling. Set `autoHide: false` to pin them on-screen permanently.

```qml
// Default — thumbs fade in on hover or scroll
P.ScrollArea {
    Rectangle { width: 600; height: 600; color: "steelblue" }
}

// Persistent scrollbars — useful for data-dense views
P.ScrollArea {
    autoHide: false
    Rectangle { width: 600; height: 600; color: "steelblue" }
}
```

Opacity transitions run at `Tokens.motion.base` (180 ms) with `Easing.OutCubic`.

## Horizontal and vertical scrolling

Both axes are supported simultaneously. The scrollbar on each axis is hidden when the content fits along that axis (`policy: ScrollBar.AsNeeded`).

```qml
P.ScrollArea {
    width: 320
    height: 200

    // Wider and taller than the viewport — both bars appear
    Rectangle {
        width: 800
        height: 600
        color: P.Tokens.muted
    }
}
```

## Sizing patterns

`T.ScrollView`'s `availableWidth` / `availableHeight` give the viewport size minus scrollbar padding. Bind child widths to `availableWidth` for full-fill rows:

```qml
P.ScrollArea {
    id: scroller
    width: 320
    height: 200

    ColumnLayout {
        width: scroller.availableWidth
        spacing: 8
        Repeater {
            model: 24
            P.PearlText { text: "Item " + (index + 1) }
        }
    }
}
```

For a horizontal-only scroller with a fixed row, set `contentWidth` explicitly:

```qml
P.ScrollArea {
    width: 320
    height: 80
    contentWidth: 1200
    contentHeight: availableHeight

    Row {
        spacing: 12
        Repeater {
            model: 20
            Rectangle { width: 56; height: 48; color: P.Tokens.card; border.color: P.Tokens.border }
        }
    }
}
```

## Disabled state

Setting `enabled: false` disables pointer and keyboard interaction. The internal `Flickable` stops responding to wheel / drag / keyboard scroll.

```qml
P.ScrollArea {
    enabled: false
    Rectangle { width: 400; height: 400; color: P.Tokens.card }
}
```

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `autoHide` | `bool` | `true` | When `true`, scrollbars fade in on hover / scroll and fade out otherwise. When `false`, they are permanently visible whenever their axis needs scrolling. |
| `clip` | `bool` | `true` | Inherited from `T.ScrollView`. Clips overflowing content to the viewport bounds. Leaving on is recommended. |
| `focusPolicy` | `Qt.FocusPolicy` | `Qt.StrongFocus` | Inherited from `T.Control`. Enables keyboard-driven scrolling (arrow keys, PageUp / PageDown). |
| `hoverEnabled` | `bool` | `true` | Required for the `autoHide` logic to react to pointer hover on the viewport. |
| `contentWidth` / `contentHeight` | `real` | `-1` | Inherited from `T.ScrollView`. Override when you want the scrollable content to be larger (or smaller) than what the child delegates report. |
| `availableWidth` / `availableHeight` | `real` | computed | Viewport width / height minus padding. Bind child widths to these for proper fill behavior. |
| `ScrollBar.vertical` / `ScrollBar.horizontal` | attached | custom `T.ScrollBar` | Each axis's scrollbar is already styled per shadcn. Reach through the attached property (e.g. `ScrollBar.vertical.policy`) to override per-instance behavior. |

## Scrollbar geometry

Matches shadcn/ui v4 exactly:

| Dimension | Value | Tailwind class |
|---|---|---|
| Track thickness | `10 px` | `w-2.5` / `h-2.5` |
| Track padding | `1 px` | `p-px` |
| Thumb thickness | `8 px` | track - 2 × padding |
| Thumb radius | `full` (height / 2) | `rounded-full` |
| Thumb color (idle) | `Tokens.border` | `bg-border` |
| Thumb color (hover) | `Tokens.mutedForeground @ 80 %` | pearl-kit tint |
| Thumb color (pressed) | `Tokens.mutedForeground` | pearl-kit tint |
| Color transition | `150 ms` / `Easing.OutCubic` | `transition-colors` |
| Opacity transition | `180 ms` / `Easing.OutCubic` | pearl-kit auto-hide |

## Under the hood

`ScrollArea` is built on `QtQuick.Templates.ScrollView`. Both `ScrollBar.vertical` and `ScrollBar.horizontal` attached properties are replaced with `T.ScrollBar` instances that have:

- a `contentItem` rectangle acting as the rounded-full thumb, bound to `Tokens.border` idle / `Tokens.mutedForeground` hover + pressed
- a transparent `Item` background (shadcn draws no visible track color either — just a `border-transparent` line for layout purposes)
- `minimumSize: 0.1` so the thumb never shrinks below 10 % of track length, even on very long content
- `Behavior on opacity` and `Behavior on color` for pearl-kit motion tokens

`clip: true` is on by default so overflowing content doesn't bleed past the rounded viewport edges. `hoverEnabled: true` is explicit so the auto-hide opacity gate (`control.hovered || bar.active || bar.hovered`) reacts to pointer entry on the viewport itself, not just on the scrollbar.

## Deliberate divergences from shadcn

- **No focus-visible ring on the viewport.** shadcn uses `focus-visible:ring-[3px] focus-visible:ring-ring/50 focus-visible:outline-1` on the viewport — accessibility feedback when the viewport itself takes focus for keyboard scrolling. In QML, `T.ScrollView` silently reparents direct children into its internal `Flickable.contentItem`, which means a `PearlFocusRing` child would scroll along with content instead of staying pinned around the viewport. Rather than introducing a wrapper layer that would break the `Layout.fillWidth` / attached-property ergonomics of `T.ScrollView`, pearl-kit skips the ring. Keyboard scrolling still works — the scrollbars themselves provide sufficient visual feedback. Wrap in a `FocusScope` or an outer bordered container if you need explicit focus framing.
- **Auto-hide is implemented in opacity** rather than shadcn / Radix's `data-state="visible"` attribute + CSS `transition-opacity` pattern. Result is identical — scrollbars fade in on hover and out on idle — but the implementation lives in QML `Behavior on opacity` instead of state-driven classes.
- **Hover / pressed thumb tint is pearl-kit-specific.** shadcn ships only `bg-border` on the thumb with no hover state. pearl-kit adds a subtle `mutedForeground @ 80 %` hover and `mutedForeground` pressed state for desktop cursor feedback — Radix / Tailwind do not, but macOS / Windows desktop conventions expect visual response when the pointer lands on a scrollbar thumb.
- **Minimum thumb size is 10 %** of track length (`minimumSize: 0.1`) to keep the thumb grabbable even with very long content. shadcn / Radix do not expose this — pearl-kit prefers the usability win.

## Accessibility

`ScrollArea` exposes the native `T.ScrollView` accessibility properties:

- Keyboard navigation (Arrow keys, PageUp / PageDown, Home / End) scrolls the viewport when `focusPolicy: Qt.StrongFocus` is in effect (the default).
- `enabled: false` removes the area from the tab chain and disables interaction.
- Screen readers announce the scrollable region through Qt's default `Accessible.Pane` role on scroll views.
