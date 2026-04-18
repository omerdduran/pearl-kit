# IconStrip

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=icon-strip"
        title="Live IconStrip demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A 48 px vertical sidebar nav rail with top-anchored main items and bottom-pinned footer items, driven by a JavaScript-array model and a single controlled `activeKey`. Pearl-kit-original — shadcn/ui ships no direct equivalent.

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

P.IconStrip {
    items: [
        { key: "viewer",       iconSource: "qrc:/icons/view.svg",    label: "View" },
        { key: "segmentation", iconSource: "qrc:/icons/segment.svg", label: "Segment" }
    ]
    footerItems: [
        { key: "settings", iconSource: "qrc:/icons/settings.svg", label: "Settings" }
    ]
    activeKey: "viewer"
    onItemClicked: function(key) { /* switch panel */ }
}
```

## Basic usage

IconStrip is a **controlled** component — you own the `activeKey` string, and IconStrip re-emits `itemClicked(key)` whenever a tile is clicked. You decide whether to accept the click and re-bind.

```qml
QtObject {
    id: appState
    property string mode: "viewer"
}

P.IconStrip {
    activeKey: appState.mode
    items: [
        { key: "viewer",       iconSource: "qrc:/icons/view.svg",    label: "View" },
        { key: "segmentation", iconSource: "qrc:/icons/segment.svg", label: "Segment" },
        { key: "implant",      iconSource: "qrc:/icons/implant.svg", label: "Implant" },
        { key: "analysis",     iconSource: "qrc:/icons/chart.svg",   label: "Analysis" }
    ]
    onItemClicked: function(key) { appState.mode = key }
}
```

## Model shape

Every entry in `items` and `footerItems` is a plain JavaScript object with three fields:

| Field | Type | Required | Description |
|---|---|---|---|
| `key` | `string` | Yes | Stable identifier. Drives the `activeKey` match and the `itemClicked(key)` signal payload. |
| `iconSource` | `url` | No | Any URL `Image` supports (PNG, JPG, SVG, WebP). Empty string hides the image slot. |
| `label` | `string` | No | Text shown beneath the icon. Hidden when `showLabels` is `false` or the label is empty. |

## Footer items

Items in `footerItems` are rendered in a second Column pinned to the strip's bottom edge. They share the same tile delegate (same visuals, same active-state rendering, same `itemClicked` signal) — the split is purely layout.

```qml
P.IconStrip {
    items: [
        { key: "viewer", iconSource: "qrc:/view.svg", label: "View" }
    ]
    footerItems: [
        { key: "ai",       iconSource: "qrc:/ai.svg",       label: "AI" },
        { key: "settings", iconSource: "qrc:/settings.svg", label: "Settings" }
    ]
}
```

If you want the AI button to appear "active" only while the assistant panel is open, reassign `activeKey` to `"ai"` on open and back to the previous mode on close.

## Dimensions

Every size is tokenized as a `property` so consumers can override without patching the component:

| Property | Default | Effect |
|---|---|---|
| `stripWidth` | `48` | Total strip width (px) |
| `tileHeight` | `52` | Per-tile height (px) |
| `iconSize` | `20` | Rendered icon edge (px). `sourceSize` also uses this. |
| `showLabels` | `true` | Hide all labels for a compact icon-only rail. |

```qml
P.IconStrip {
    stripWidth: 56
    tileHeight: 60
    iconSize: 24
    showLabels: false
    items: [ /* ... */ ]
}
```

## States

| State | Trigger | Visual |
|---|---|---|
| Default | No interaction | Transparent tile, icon @ 60 % opacity, label in `Tokens.mutedForeground` |
| Hover | Pointer over tile | Tile background transitions to `Tokens.accent` @ 60 % alpha, icon + label to 100 % |
| Active | `activeKey === item.key` | Tile background fills `Tokens.accent`, label color → `Tokens.foreground`, a 3 × 16 `Tokens.primary` indicator bar appears flush against the strip's left edge |
| Focus (keyboard) | Tab lands on tile | 3 px focus ring at `Tokens.ring` @ 50 % alpha, keyboard-only via `visualFocus` |
| Disabled | `enabled: false` (strip-wide) | Background + content fade to 50 % alpha, interaction suppressed |

All state transitions animate at `Tokens.motion.fast` (150 ms, `Easing.OutCubic`).

## Icon tinting

Pearl-kit does **not** tint raster / SVG icons at runtime — Qt 6 deprecated the necessary effects and pearl-kit avoids `Qt5Compat`. Two patterns cover the common cases:

1. **Foreground-white SVGs.** Ship icons with a single foreground color (typically white for dark themes, `Tokens.foreground` flat color for light). Pearl-kit fades opacity between `0.6` (idle) and `1.0` (hover / active) so inactive tiles feel dimmer.
2. **Per-theme icon sets.** Flip the `iconSource` URL in your consumer code when the theme changes. IconStrip re-evaluates the binding and swaps.

Label color does reactively bind to `Tokens.mutedForeground` / `Tokens.foreground`, so text stays correct across Dark / DarkBlue / Light modes out of the box.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `stripWidth` | `int` | `48` | Strip total width. |
| `tileHeight` | `int` | `52` | Per-tile height. |
| `iconSize` | `int` | `20` | Icon render size and `sourceSize`. |
| `showLabels` | `bool` | `true` | Globally hide labels for an icon-only rail. |
| `items` | `var` | `[]` | Top-anchored items (main modes). |
| `footerItems` | `var` | `[]` | Bottom-pinned items (AI, Settings, etc.). |
| `activeKey` | `string` | `""` | Currently active item's `key`. Matches both `items` and `footerItems`. |
| `enabled` | `bool` | `true` | Strip-wide enable flag. Disabled tiles still render, just at 50 % alpha with no interaction. |

### Signals

| Signal | When |
|---|---|
| `itemClicked(string key)` | Any tile clicked (pointer or keyboard Space / Return). Payload is the item's `key`. |

## Accessibility

- **Keyboard activation** — each tile is a `T.AbstractButton` that fires `clicked` on Space / Return via Qt's base implementation. Pearl-kit does not attach any `Keys.on*Pressed` handlers.
- **Tab order** — Tab traverses top items in document order, then footer items, then leaves the strip. Shift-Tab reverses.
- **Focus ring** — keyboard-only (`visualFocus`), matching Button. Mouse clicks do not show a ring.
- **Disabled state** — `enabled: false` on the strip skips all tiles in the focus chain.

## Under the hood

IconStrip is a plain `Rectangle` (no `QtQuick.Templates` base — the strip itself has no interactive contract). Each tile is a `T.AbstractButton` so we inherit the Qt behavior primitives (hover, focus, keyboard click, checked state) without paying for `T.Button`'s default `text` / `icon` rendering. `background` and `contentItem` are both overridden to composite our own geometry.

Layout uses two anchored `Column`s with `Repeater` delegates — top Column anchors to `parent.top`, footer Column anchors to `parent.bottom`. This works regardless of parent height without a `Flickable` or `ColumnLayout` spacer.

The 3 × 16 active indicator is a child of the tile `background` with `x: 0`, so it sits flush against the strip's left edge (not the tile's left edge) — that's the signature look of macOS-style vertical navigators (Finder sidebar, Xcode navigator).

Theme switching propagates through the usual `Tokens.*` bindings: set `Tokens.mode = Tokens.Light` and every color re-resolves automatically.

## Deliberate divergences from shadcn

shadcn/ui has no IconStrip primitive. This component is a deliberate pearl-kit-original, loosely inspired by shadcn's `Sidebar` and `Tabs` with `orientation="vertical"` but purposefully narrower:

1. **Model-driven** (`items: var`) instead of declarative composition (no `IconStripItem` child component). Matches Select's `ComboBox`-style API.
2. **`footerItems` as a parallel array** instead of a `<footer>` slot or `SidebarFooter` primitive. Keeps the API surface flat and matches airontgen's pinned-to-bottom affordance.
3. **Opacity-based icon dimming** instead of color tinting. Qt 6 deprecated the necessary effects; opacity is cleaner.
4. **3 px left-edge indicator bar** (airontgen parity) instead of shadcn Tabs's bottom-border accent. Apple HIG convention for vertical nav.
