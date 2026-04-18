# StatusBar

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=statusbar"
        title="Live StatusBar demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

Main-window footer primitive — a single bar at the bottom of an application window with three regions: a left-aligned hint slot, an absolutely centered measurement slot, and a right-aligned status slot. Follows the macOS footer convention (Xcode, Finder, VS Code) rather than any shadcn/ui component — shadcn does not ship a status bar, since it targets web-first layouts where a persistent footer is rare.

Use `StatusBar` whenever a desktop application needs a persistent footer for navigation hints, live measurements, or process state. The centered region is absolutely positioned within the bar (not flexbox-spaced) so the measurement stays visually centered even when the left or right content grows or shrinks.

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
import QtQuick.Controls
import PearlKit 1.0 as P

ApplicationWindow {
    width: 900
    height: 600
    visible: true

    // ... main content above ...

    P.StatusBar {
        id: footer
        anchors.bottom: parent.bottom
        width: parent.width
        leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Press S to save" }
        centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "14.2 × 8.3 mm" }
        rightContent: P.PearlText {
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.xs
            text: "Idle"
            color: footer.statusColor
        }
    }
}
```

`StatusBar` has an implicit height of 28 px and an implicit width of 480 px — the width default is a placeholder. In practice, bind `width` to the parent window width via `anchors.left`/`anchors.right` or a `Layout.fillWidth: true` hint inside a `ColumnLayout`.

## Regions

Three `Component` slot properties, instantiated via `Loader` at the right anchor points:

| Slot | Anchor | Typical content |
|---|---|---|
| `leftContent` | `anchors.left` | Keyboard hint, mode indicator, file path |
| `centerContent` | `anchors.horizontalCenter` | Live measurement, zoom level, cursor position |
| `rightContent` | `anchors.right` | Status text, saved indicator, sync state |

Each slot accepts a single Component. Consumers supply a `PearlText`, `Row`, icon, or any Item directly — QML automatically wraps the child in a Component.

```qml
P.StatusBar {
    leftContent: Row {
        spacing: 6
        Image {
            source: "qrc:/icons/mouse.svg"
            sourceSize: Qt.size(14, 14)
            width: 14
            height: 14
            anchors.verticalCenter: parent.verticalCenter
        }
        P.PearlText {
            variant: "muted"
            font.pixelSize: P.Tokens.font.size.xs
            text: "Click to select"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
```

The center region is absolutely centered inside the bar (via `anchors.horizontalCenter: parent.horizontalCenter`), not flex-spaced between the left and right regions. This matches macOS Finder and Xcode: the measurement stays fixed in the middle of the window even when left or right content is a different width.

## Status kinds

The optional `statusKind` property drives a derived `statusColor` that consumers bind from the right slot:

| `statusKind` | `statusColor` |
|---|---|
| `"default"` | `Tokens.mutedForeground` |
| `"success"` | `Tokens.success` |
| `"warning"` | `Tokens.warning` |
| `"error"` | `Tokens.destructive` |

Because the region is a Component slot (not a string), you reference `statusColor` through the StatusBar's `id`:

```qml
P.StatusBar {
    id: bar
    statusKind: "error"
    rightContent: P.PearlText {
        font.family: P.Tokens.font.ui
        font.pixelSize: P.Tokens.font.size.xs
        text: "Validation failed"
        color: bar.statusColor
    }
}
```

`statusKind` has no direct visual effect on the bar itself — it only exposes the color. This keeps the design flexible: consumers can render icons, badges, or multi-child Rows in the right region while still opting into the taxonomy for color signaling.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `leftContent` | `Component` | `null` | Instantiated at the left edge, vertically centered |
| `centerContent` | `Component` | `null` | Instantiated at the absolute horizontal center |
| `rightContent` | `Component` | `null` | Instantiated at the right edge, vertically centered |
| `statusKind` | `string` | `"default"` | One of `default`, `success`, `warning`, `error` — drives `statusColor` |
| `statusColor` | `color` | derived | Readonly; bind from the right slot's content for coloring |
| `hpad` | `int` | `12` | Left and right inset for the outer slots (Tokens.space.x3) |
| `enabled` | `bool` | `true` | `false` fades the three Loader slots to 50 % alpha |
| `implicitHeight` | `int` | `28` | macOS footer convention — comfortable 12 px font + breathing room |
| `implicitWidth` | `int` | `480` | Placeholder; override via `width` or `Layout.fillWidth` |

## Typography

`StatusBar` does not prescribe a font size for the region content — any Item works. The macOS footer convention uses 12 px text (`Tokens.font.size.xs`), which is not `PearlText`'s default (`14 px` for `body` / `muted`). Override explicitly:

```qml
rightContent: P.PearlText {
    variant: "muted"
    font.pixelSize: P.Tokens.font.size.xs    // 12 px
    text: "Saved"
}
```

A future helper variant (`PearlText { variant: "caption" }`) could bake this in — out of scope for now.

## Accessibility

`StatusBar` is a purely visual footer with no interactive contract. It has no focus policy, no keyboard navigation, no click handler — the slot content can have its own interactivity (buttons, clickable labels) if needed. Qt assistive tech announces the bar's children individually.

## Under the hood

Root is a plain `Rectangle` (no `QtQuick.Templates` base — a status bar has no interactive state). The bar's fill is `Tokens.muted`, with a 1 px top border in `Tokens.border` rendered as a child `Rectangle` anchored to the top edge.

Each region is a `Loader` with `sourceComponent` bound to one of the three Component properties. Loaders are siblings inside the Rectangle root:

- Left Loader — `anchors.left` / `anchors.leftMargin: hpad` / `anchors.verticalCenter`
- Center Loader — `anchors.horizontalCenter` / `anchors.verticalCenter`
- Right Loader — `anchors.right` / `anchors.rightMargin: hpad` / `anchors.verticalCenter`

The centered region uses `anchors.horizontalCenter: parent.horizontalCenter` (not a RowLayout spacer) so the content stays absolutely centered relative to the bar, regardless of left/right content widths. This is the macOS Finder / Xcode status bar convention.

Disabled state fades each Loader to 50 % alpha independently — opacity is not applied to the root bar because QML parent-opacity inheritance would fade any child atoms (e.g. if a consumer adds a focus ring around a clickable hint). Keeping the fade on the slot Loaders mirrors the pattern used in `Input` and `Card`.

## Deliberate differences from shadcn

`StatusBar` has no shadcn/ui equivalent — shadcn targets web-first layouts where persistent footers are rare. The design language for this component is taken from the macOS footer idiom (Xcode, Finder, VS Code):

1. **28 px height + 12 px font.** Matches Xcode (23 px) / VS Code (22 px) / Finder (24 px) with slightly more breathing room for pearl-kit's desktop-first default of 14 px body text.
2. **`Tokens.muted` fill + 1 px top hairline.** macOS status bar convention — softer than the window background, clearly separated from main content.
3. **Absolute-center middle region.** Flexbox would space the center "between" the left and right regions, drifting the measurement off-center when they have different widths. macOS centers absolutely, and pearl-kit follows.
4. **Component slots, not string properties.** The regions accept arbitrary Items (icons + text + badges), not just strings. String-only APIs would force every custom layout into composition-outside-the-bar, defeating the point of a footer primitive.
5. **`statusKind` taxonomy.** Four-value enum (`default` / `success` / `warning` / `error`) matches pearl-kit's `Card` variant vocabulary. Exposed via `statusColor` for consumer opt-in rather than forced into the bar's own styling.

## Related

- [Card](card.md) — elevated surface primitive with similar `statusKind`-style variant taxonomy.
- [Separator](separator.md) — 1 px divider; StatusBar's top hairline is the same visual idiom.
- [PearlText](pearl-text.md) — typography primitive for region content (remember to override `font.pixelSize` to `xs`).
