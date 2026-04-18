# Menu

A desktop-grade menu family — **MenuBar**, **Menu**, **MenuItem**, **MenuSeparator** — sourced from [shadcn/ui](https://ui.shadcn.com/docs/components/menubar) `menubar.tsx` + `dropdown-menu.tsx`. The same `Menu` works as a menubar dropdown, a standalone right-click context menu (`popup(x, y)`), and as a nested submenu.

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
import QtQuick.Controls
import PearlKit 1.0 as P

ApplicationWindow {
    width: 800
    height: 600
    visible: true

    menuBar: P.MenuBar {
        P.Menu {
            title: "&File"
            P.MenuItem { text: "&New";  shortcut: "Cmd+N" }
            P.MenuItem { text: "&Open"; shortcut: "Cmd+O" }
            P.MenuSeparator {}
            P.MenuItem { text: "&Quit"; shortcut: "Cmd+Q"; variant: "destructive" }
        }
    }
}
```

## MenuBar

`MenuBar` holds `Menu` children as top-level triggers. Each `Menu.title` drives the trigger's label; prefix a letter with `&` (e.g. `"&File"`) to mark it as the Alt-mnemonic.

```qml
P.MenuBar {
    P.Menu {
        title: "&File"
        P.MenuItem { text: "&New File"; shortcut: "Cmd+N" }
        P.MenuItem { text: "&Open...";  shortcut: "Cmd+O" }
    }
    P.Menu {
        title: "&View"
        P.MenuItem { text: "Show &Toolbar"; checkable: true; checked: true }
    }
    P.Menu {
        title: "&Help"
        P.MenuItem { text: "&About" }
    }
}
```

Two placements:

- **Attached to `ApplicationWindow.menuBar`** — the idiomatic desktop placement, renders as a native-looking bar above the window content. On macOS this is the global menu bar.
- **Inline in a layout** — `MenuBar` is a regular `Item`, so placing it inside a `ColumnLayout` or anchoring it directly also works. Useful for embedded tools, dialogs, or split-pane editors with per-pane menus.

## Menu as a context menu

The same `Menu` component can be opened as a right-click menu without a bar. Declare it anywhere inside a `Window` / `ApplicationWindow` and call `popup()` or `popup(x, y)` from a `MouseArea`:

```qml
Rectangle {
    id: target
    width: 200
    height: 80
    color: P.Tokens.muted

    P.Menu {
        id: ctx
        P.MenuItem { text: "&Copy";   shortcut: "Cmd+C" }
        P.MenuItem { text: "&Paste";  shortcut: "Cmd+V" }
        P.MenuSeparator {}
        P.MenuItem { text: "&Delete"; variant: "destructive" }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: function(mouse) { ctx.popup(mouse.x, mouse.y) }
    }
}
```

`popup()` without coordinates docks the menu at the current cursor position.

## MenuItem

`MenuItem` is the row primitive. Combinations you'll use most:

```qml
P.MenuItem { text: "&Save"; shortcut: "Cmd+S" }
P.MenuItem { text: "&Open..."; iconSource: "qrc:/icons/folder.svg" }
P.MenuItem { text: "&Delete"; variant: "destructive" }
P.MenuItem { text: "Show &Grid"; checkable: true; checked: true }
P.MenuItem { text: "&List view"; checkable: true; checked: true; radio: true }
P.MenuItem { text: "Unavailable"; enabled: false }
```

### Variants

| Variant | Use case | Text color | Hover background |
|---|---|---|---|
| `default` | Regular action | `Tokens.popoverForeground` | `Tokens.accent` |
| `destructive` | Delete, remove, discard, quit | `Tokens.destructive` | `Tokens.destructive` @ 10% alpha |

### Checkable items

Set `checkable: true` to turn an item into a toggle. When `checked: true`, pearl-kit renders a check glyph on the left:

```qml
P.MenuItem { text: "Show Line Numbers"; checkable: true; checked: true }
P.MenuItem { text: "Word Wrap";         checkable: true }
```

For radio-style mutually-exclusive items, also set `radio: true`. The indicator becomes a filled dot, matching shadcn's `RadioItem`:

```qml
P.MenuItem { text: "&List";    checkable: true; checked: true; radio: true }
P.MenuItem { text: "&Grid";    checkable: true; radio: true }
P.MenuItem { text: "&Gallery"; checkable: true; radio: true }
```

pearl-kit does not wire exclusivity automatically — use Qt's `ButtonGroup { exclusive: true }` if you need one-at-a-time enforcement, or manage the `checked` state yourself on each item's `onTriggered`.

### Inset padding

When a menu mixes checkable and non-checkable items, the non-checkable ones will visually start further left because they have no indicator slot. Set `inset: true` to reserve the same 16 px indicator zone and align the rows:

```qml
P.Menu {
    P.MenuItem { text: "Show Toolbar"; checkable: true; checked: true }
    P.MenuItem { text: "Show Sidebar"; checkable: true }
    P.MenuSeparator {}
    P.MenuItem { text: "Reset Layout"; inset: true }  // aligns with the checkable rows above
}
```

### Icons

`iconSource: url` renders a 16 × 16 icon before the text. Any format QML's `Image` supports (SVG, PNG, JPG, WebP) works.

```qml
P.MenuItem { text: "&Open..."; iconSource: "qrc:/icons/folder.svg" }
P.MenuItem { text: "&Save";    iconSource: "qrc:/icons/save.svg"; shortcut: "Cmd+S" }
```

### Shortcuts (display-only)

`shortcut: string` renders a right-aligned hint next to the item. It is **not** parsed as a `QKeySequence` and does not fire anything — write it however you want your users to read it (`"Cmd+N"` on macOS, `"Ctrl+N"` on Windows / Linux, `"Delete"`, `"⌘ ⇧ Z"`, etc.).

To actually bind a key, pair the item with a regular Qt `Shortcut` or `Action`:

```qml
P.MenuItem {
    text: "&New File"
    shortcut: "Cmd+N"
    onTriggered: app.newFile()
}

Shortcut {
    sequence: StandardKey.New
    onActivated: app.newFile()
}
```

## MenuSeparator

Zero-property horizontal divider, 1 px tall, `Tokens.border` color, with a deliberate negative margin so it bleeds to the popup's inner edge (matching shadcn's `-mx-1`).

```qml
P.Menu {
    P.MenuItem { text: "Cut" }
    P.MenuItem { text: "Copy" }
    P.MenuItem { text: "Paste" }
    P.MenuSeparator {}
    P.MenuItem { text: "Select All" }
}
```

## Submenus

Nest `Menu` inside `Menu` to declare a submenu. A right-pointing chevron is auto-added to the parent item, and the submenu opens on hover or on activation via Arrow Right:

```qml
P.Menu {
    title: "&Tools"

    P.MenuItem { text: "&Preferences"; shortcut: "Cmd+," }
    P.MenuSeparator {}

    P.Menu {
        title: "&Export"
        P.MenuItem { text: "PDF" }
        P.MenuItem { text: "PNG" }
        P.MenuItem { text: "SVG" }
    }
}
```

Submenus cascade indefinitely, inherit the parent's styling, and close together when the top-level menu dismisses.

## Keyboard navigation

All handling is native `QtQuick.Templates.Menu` — pearl-kit adds no custom key handlers. The keys below work out of the box.

| Key | Action |
|---|---|
| `Alt + letter` | Open the menu whose title has `&letter` mnemonic (e.g. `&File` → Alt + F) |
| `Up` / `Down` | Move the highlighted item |
| `Return` / `Space` | Activate the highlighted item |
| `Right` | Enter a submenu, or jump to the next top-level menu on the bar |
| `Left` | Close the current submenu, or jump to the previous top-level menu |
| `Escape` | Close the current menu (and any open submenu stack) |
| Letter keys | Type-ahead to jump to the next item whose text starts with that letter |

## Property reference

### MenuBar

| Property | Type | Default | Description |
|---|---|---|---|
| `padding` | `int` | `4` | Inset from the bar edge to triggers |
| `spacing` | `int` | `4` | Gap between triggers |
| `implicitHeight` | `int` | `36` | shadcn `h-9` parity |

`MenuBar` inherits from `QtQuick.Templates.MenuBar`; all its standard properties (`currentIndex`, `focus`, `hoverEnabled`, …) are available.

### Menu

| Property | Type | Default | Description |
|---|---|---|---|
| `minimumWidth` | `int` | `192` | Minimum popup width in pixels (shadcn `min-w-[12rem]`) |
| `padding` | `int` | `4` | Inset from popup edge to items |
| `modal` | `bool` | `false` | Leave as `false` — modal menus break outside-click dismissal |
| `cascade` | `bool` | `true` | Required for submenu positioning |

`Menu` inherits from `QtQuick.Templates.Menu`. Standard methods like `popup()`, `popup(x, y)`, `popup(parent, pos)`, `close()`, and `open()` all work.

### MenuItem

| Property | Type | Default | Description |
|---|---|---|---|
| `text` | `string` | `""` | Item label. Prefix a letter with `&` for a mnemonic. |
| `shortcut` | `string` | `""` | Right-aligned display-only hint. Not parsed as a key sequence. |
| `iconSource` | `url` | `""` | Optional 16 × 16 icon before the text. |
| `variant` | `string` | `"default"` | `"default"` or `"destructive"` |
| `checkable` | `bool` | `false` | Shows an indicator zone on the left |
| `checked` | `bool` | `false` | Fills the indicator when `checkable` |
| `radio` | `bool` | `false` | When `checkable`, renders a filled dot instead of a check |
| `inset` | `bool` | `false` | Reserves indicator-width left padding for alignment with checkable siblings |
| `enabled` | `bool` | `true` | Disabled items fade to 50 % alpha and don't respond |

`MenuItem` inherits from `QtQuick.Templates.MenuItem`. `triggered()`, `clicked()`, `toggled()`, `hovered`, and `highlighted` are all available.

### MenuSeparator

No pearl-kit-specific properties. Inherits from `QtQuick.Templates.MenuSeparator`.

## Accessibility

- **Keyboard-first by design.** All navigation works without the mouse; the mnemonic-underline convention (`&File`) matches desktop idioms on every platform.
- **Focus handling is native `T.Menu`.** pearl-kit does not add a visible focus ring on items — the accent background already conveys highlighted state clearly, matching shadcn's `focus:bg-accent` approach.
- **Disabled items** are skipped by keyboard navigation and pointer interaction. The 50 % opacity applies to `background` and `contentItem` separately, preserving any nested focus chrome at full alpha (standard pearl-kit rule).

## Under the hood

The four components subclass `QtQuick.Templates.MenuBar`, `QtQuick.Templates.Menu`, `QtQuick.Templates.MenuItem`, and `QtQuick.Templates.MenuSeparator` respectively — the same headless base types every major QML component library uses.

`MenuItem.contentItem` is overridden with a `RowLayout` that holds, in order:

1. A 16 × 16 indicator cell — visible when `checkable` or `inset`, content is either `PearlCheckIcon` (for check), a filled `Rectangle` (for radio), or empty (inset padding only).
2. A 16 × 16 icon cell — visible when `iconSource` is non-empty.
3. The main `PearlBaseText` label (fills remaining width).
4. A right-aligned `shortcut` text in `Tokens.mutedForeground`.
5. A `PearlChevron { direction: "right" }` — visible only when `subMenu !== null` (submenu detection).

Because `contentItem` is overridden, `T.MenuItem`'s default `indicator` and `arrow` slots are not rendered; everything is composed inline in the `RowLayout`.

Mnemonics (underlined letter when Alt is held) require `textFormat: Text.StyledText`, which is set on both `MenuItem.contentItem` and the `MenuBarItem.delegate`.

Menu popup shadow uses `QtQuick.Effects.MultiEffect` (Qt 6.5+) — the same path as `Dialog`. The `paddingRect` is expanded by 16 px per side so the shadow blur isn't clipped.

Every color, radius, padding, spacing, and motion value resolves through `Tokens.*`, so a theme switch propagates automatically.

## Deliberate divergences from shadcn

- **`iconSource` is a direct `url` prop.** Shadcn composes icons as children (`<DropdownMenuItem><FolderIcon />…</DropdownMenuItem>`). pearl-kit matches `Button` / `Input` convention for consistency.
- **`shortcut` is display-only.** Shadcn's `<DropdownMenuShortcut>` is also display-only; pearl-kit mirrors this. Firing is the user's responsibility via `Shortcut {}` or `Action {}`.
- **`radio` is a modifier on `MenuItem`, not a separate component.** Shadcn has `<CheckboxItem>` and `<RadioItem>` as distinct React components. pearl-kit uses one `MenuItem` with `radio: bool` for smaller surface area — a single component covers both patterns.
- **Shadow uses `MultiEffect`.** Shadcn uses CSS `shadow-md`. Visual parity is the goal, not underlying tech.

## Known limitations

- `shortcut` strings are never parsed into `QKeySequence` objects. Use Qt's `Shortcut` element to actually bind keys.
- There is no `MenuLabel` / `MenuGroup` / `MenuRadioGroup` primitive yet. Use a disabled `MenuItem` as a label, and `ButtonGroup` for exclusivity.
- Submenu `sideOffset` and `alignOffset` customization is not exposed — `Menu` uses Qt `T.Menu` defaults, which match shadcn's recommended offsets closely.
- Scroll arrows for very tall menus are not custom-styled; the native `ScrollIndicator` appears when the menu overflows the viewport.
- The `MenuBar` `shadow-xs` from shadcn is intentionally skipped — a top bar sitting flush against the window chrome reads cleaner without a hairline shadow underneath.
