# NavItem

Single-row clickable item for sidebars, settings panels, and tabbed navigation. Derived from [shadcn/ui](https://ui.shadcn.com/docs/components/sidebar)'s `SidebarMenuButton` (default variant).

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

ColumnLayout {
    id: sidebar
    spacing: 4
    property int currentTab: 0
    property var labels: ["General", "Appearance", "Editor", "Files"]

    Repeater {
        model: sidebar.labels
        delegate: P.NavItem {
            Layout.fillWidth: true
            text: modelData
            active: index === sidebar.currentTab
            onClicked: sidebar.currentTab = index
        }
    }
}
```

`NavItem` does not enforce single-selection semantics — the consumer owns the `currentTab` / `currentKey` state and updates it in `onClicked`. This matches pearl-kit's "kit, not framework" philosophy and replaces `QListWidget` in one-to-one drop-in migrations.

## Sizes

Three sizes matching shadcn `SidebarMenuButton`'s size scale:

| Size | Height | Font size | Use case |
|---|---|---|---|
| `sm` | 28 | 12 | Dense settings panes, compact tool palettes |
| `default` | 32 | 14 | General use — settings dialogs, sidebar navigation |
| `lg` | 48 | 14 | User profile rows, account switchers, prominent tab lists |

```qml
P.NavItem { size: "sm";      text: "Compact" }
P.NavItem { size: "default"; text: "Standard" }
P.NavItem { size: "lg";      text: "Roomy" }
```

Horizontal and vertical padding stay at 8 px across all sizes (shadcn `p-2`), as does the 8 px gap between icon and label (`gap-2`). Only height and font size change with `size`.

## Icons

```qml
P.NavItem {
    text: "Settings"
    iconLeft: "qrc:/icons/cog.svg"
}

P.NavItem {
    text: "More"
    iconLeft: "qrc:/icons/folder.svg"
    iconRight: "qrc:/icons/chevron-right.svg"
}
```

Icons render at **16×16 logical pixels** via `Image.PreserveAspectFit` with `sourceSize: Qt.size(16, 16)` for crisp SVG rasterization. Both slots are optional and hide when the URL is empty. `iconRight` is typically used for chevrons on expandable rows or badges on rows with indicator counts.

## States

| State | Trigger | Visual |
|---|---|---|
| Idle | Default | Transparent background, `Tokens.foreground` text |
| Hover | Pointer over row | `Tokens.accent` fill, `Tokens.accentForeground` text (150 ms transition) |
| Pressed | Mouse down or keyboard Space / Return | Same as hover |
| Active | `active: true` | `Tokens.accent` fill, `Tokens.accentForeground` text, **`medium` font weight** |
| Focus (keyboard) | Tab navigation lands on row | 3 px focus ring at `Tokens.ring` @ 50 % alpha, no offset |
| Focus (pointer) | Click | **No ring** — matches shadcn's `focus-visible:` behavior |
| Disabled | `enabled: false` | Background + content at 50 % opacity, all interaction suppressed |

Active and hover collapse to the same background + foreground color (shadcn cascades `hover:bg-sidebar-accent` and `data-[active=true]:bg-sidebar-accent` to the same value). The only visible difference for the active state is the bolder font weight.

```qml
P.NavItem { text: "Selected";   active: true }
P.NavItem { text: "Disabled";   enabled: false }
P.NavItem { text: "Also off";   enabled: false; active: true }
```

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `text` | `string` | `""` | Row label. Elides right when width is constrained. |
| `size` | `string` | `"default"` | One of `default`, `sm`, `lg`. |
| `active` | `bool` | `false` | Selected-state flag. Consumer-managed. |
| `iconLeft` | `url` | `""` | Optional leading icon (16 × 16). Empty URL hides the slot. |
| `iconRight` | `url` | `""` | Optional trailing icon — chevron, badge, overflow dot. |
| `enabled` | `bool` | `true` | Inherited from `T.Button`. Toggles disabled visual + interaction. |

### Inherited signals from `T.Button`

| Signal | When |
|---|---|
| `clicked()` | Released after a click or keyboard Space / Return |
| `pressed()` | Pointer down or keyboard activate |
| `released()` | Pointer up |

## Accessibility

- **Keyboard activation** — `Space` and `Return` fire `clicked()` via `T.Button`'s base implementation. Do not write your own `Keys.onPressed` handlers; they will cause duplicate signals.
- **Focus chain** — NavItems participate in the Tab focus chain by default (`focusPolicy: Qt.StrongFocus`). The focus ring appears **only** on keyboard-initiated focus, matching the `focus-visible:` semantics of shadcn/ui.
- **Disabled state** — `enabled: false` suppresses both pointer and keyboard interaction and skips the row in the focus chain.
- **Exclusive single-selection** — pearl-kit does not ship a built-in radio-group semantics. Consumers toggle `active` based on an externally-held index or key, as in the usage example above. For small, fixed tab counts this is idiomatic; for dynamic lists, a `ButtonGroup { exclusive: true }` can wrap a `Repeater` of `NavItem`s.

## Under the hood

NavItem is a `QtQuick.Templates.Button` (not `QtQuick.Controls.Basic.Button` and not `T.ItemDelegate`). `T.Button`'s semantics — keyboard activation, `clicked()` signal, `down`, `hovered`, `visualFocus` — map 1:1 to shadcn's `<button>` root. `T.ItemDelegate` was considered and rejected because its built-in `highlighted` state would shadow our explicit `active` property.

Internally NavItem composes three helper atoms from `PearlKit.internal`:

- `PearlBaseText` for the label (14 px / medium / `SF Pro Display`, size-aware via `font.pixelSize`)
- `PearlFocusRing` for the keyboard focus indicator
- A bare `Rectangle` for the background

State consolidation mirrors shadcn: a single `_highlighted` computed property collapses `active || down || hovered` to one background token (`Tokens.accent`), with `active` additionally switching the font weight from `regular` to `medium`.

Every color, radius, spacing, motion, and typography value resolves through `Tokens.*`, so theme changes (`Tokens.mode = Tokens.Light`) propagate automatically.

## Deliberate divergences from shadcn

- **No `variant: "outline"`.** In `sidebar.tsx`, the `outline` variant is used for decorative label rows with a 1 px shadow ring — out of scope for a plain nav item. Will revisit if a consumer asks.
- **No `tooltip` prop.** shadcn shows the label as a tooltip when the parent sidebar collapses to icon-only mode. pearl-kit has no collapsible-sidebar primitive yet, so this is deferred.
- **No `SidebarMenuBadge` / `SidebarMenuAction` / `SidebarMenuSub`.** These are separate primitives in shadcn; pearl-kit ships only the base row for now. Each can be added on a real consumer ask.
- **`iconRight` is a URL slot, not a child.** shadcn composes external SVGs as JSX children. pearl-kit follows `Button` / `Input` conventions where both icon slots are URL properties — simpler for the common case of chevrons and badges.
- **`active` is a plain `bool`, not `data-state`.** No `ButtonGroup` auto-wiring. Consumer owns the state.
