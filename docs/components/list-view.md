# ListView

A generic vertical list primitive with shadcn-styled chrome. Use it for implant lists, measurements, recent files, log entries, and any other single-column interactive row display. Renders plain string arrays out of the box; swap in a custom delegate when rows need richer structure.

shadcn/ui does not ship a pure ListView primitive — design values are blended from `Command.Item` (selected/hover accent), `Table.Row` (optional row separators), and `Command` root (rounded card container).

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

P.ListView {
    width: 240
    height: 280
    model: ["Inbox", "Drafts", "Sent", "Archive"]
    onItemClicked: function(index) { console.log("clicked", index) }
    onItemActivated: function(index) { console.log("activated", index) }
}
```

## Basic usage — string model

The simplest form: pass an array of strings. The default delegate renders each string as a 36 px row with accent hover/selection.

```qml
P.ListView {
    Layout.fillWidth: true
    Layout.preferredHeight: 280
    model: ["Alpha", "Bravo", "Charlie", "Delta"]
}
```

## Object model with roles

Pass an array of objects (or a `ListModel`) with `label`, `iconSource`, `trailing`, and `enabled` roles to drive the default delegate without writing custom QML.

```qml
P.ListView {
    Layout.fillWidth: true
    Layout.preferredHeight: 240
    model: [
        { label: "report.pdf",     trailing: "2.1 MB"  },
        { label: "scan.dcm",       trailing: "48 MB"   },
        { label: "notes.md",       trailing: "12 kB"   },
        { label: "locked.key",     trailing: "—", enabled: false }
    ]
}
```

Row roles understood by the default delegate:

| Role | Type | Purpose |
|---|---|---|
| `label` | string | Primary text (fallback: the string itself for primitive arrays) |
| `iconSource` | url | Optional 16 × 16 leading icon |
| `trailing` | string | Optional right-aligned secondary text (12 px muted) |
| `enabled` | bool | Per-row disable (defaults to `true`) |

## Custom delegate

When the default row isn't enough, override `delegate`. The contract is the standard Qt Quick ListView delegate — one item per row sized to the list's width.

```qml
P.ListView {
    Layout.fillWidth: true
    Layout.preferredHeight: 360
    model: implantModel
    delegate: Rectangle {
        width: ListView.view ? ListView.view.width : 0
        height: 64
        color: ListView.isCurrentItem ? P.Tokens.accent : "transparent"
        radius: P.Tokens.radius.sm
        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            P.PearlText { variant: "label"; text: model.id }
            P.PearlText { variant: "muted"; text: model.size }
        }
    }
}
```

## Variants

| Variant | Chrome | When to use |
|---|---|---|
| `"card"` (default) | 1 px border, `radius.md`, `Tokens.card` background | Standalone list panels |
| `"flush"` | No background, no border | List nested inside a `Card`, `GroupBox`, or any bordered parent |

```qml
P.Card {
    P.ListView {
        Layout.fillWidth: true
        Layout.preferredHeight: 240
        variant: "flush"
        model: ["Inside the card, no double border."]
    }
}
```

## States

| State | Trigger | Visual |
|---|---|---|
| Default | idle | row transparent, label at `foreground` |
| Hover | pointer over a row | row fills with `Tokens.accent`, label at `accentForeground` |
| Selected | `currentIndex === row` | same as hover — pearl-kit collapses hover and selected into one accent fill |
| Keyboard focus (outer) | Tab to the list | 3 px `ring/50 %` focus ring around the container |
| Disabled row | `model.enabled: false` | row bg/text at 50 % alpha, no hover response |
| Disabled list | `enabled: false` | entire list body + background at 50 % alpha |

## Separators

Opt-in 1 px bottom hairlines between rows, styled to `Tokens.border`. Matches shadcn `Table.Row` `border-b`.

```qml
P.ListView {
    Layout.fillWidth: true
    Layout.preferredHeight: 280
    showSeparators: true
    model: ["Row one", "Row two", "Row three"]
}
```

## Empty state

Set `emptyText` to render a centered muted message when `count === 0`.

```qml
P.ListView {
    Layout.fillWidth: true
    Layout.preferredHeight: 200
    emptyText: "No recent files"
    model: []
}
```

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `variant` | string | `"card"` | Container chrome (`"card"` or `"flush"`) |
| `showSeparators` | bool | `false` | Draw a 1 px border under each row |
| `emptyText` | string | `""` | Centered placeholder when `count === 0` |
| `rowHeight` | int | `36` | Height of each default-delegate row (px) |
| `model` | any | — | Alias → internal `ListView.model` |
| `delegate` | Component | built-in | Alias → internal `ListView.delegate` |
| `currentIndex` | int | `-1` | Alias → internal `ListView.currentIndex` |
| `count` | int (read-only) | `0` | Alias → internal `ListView.count` |
| `spacing` | real | `0` | Alias → inter-row spacing |
| `orientation` | enum | `ListView.Vertical` | Alias → internal `ListView.orientation` |
| `header` | Component | `undefined` | Alias → internal `ListView.header` |
| `footer` | Component | `undefined` | Alias → internal `ListView.footer` |

## Signals

| Signal | When | Payload |
|---|---|---|
| `itemClicked(int index)` | Single left click on a row | row index |
| `itemActivated(int index)` | Double click OR Return/Enter on current row | row index |

## Keyboard

| Key | Action |
|---|---|
| Tab / Shift+Tab | Move focus in/out of the list |
| Up / Down | Move `currentIndex` within the list (native Qt) |
| Home / End | Jump to first / last row (native Qt) |
| PageUp / PageDown | Page navigation (native Qt) |
| Return / Enter | Emit `itemActivated(currentIndex)` |

## Accessibility

The outer `T.Control` participates in the Tab chain and publishes its activeFocus state. Rows are rendered as `T.ItemDelegate` instances so each has native `hovered`, `pressed`, and `enabled` accessibility attributes. The component does not currently emit `Accessible.ItemView` selection-change announcements — that will be tackled in a cross-component A11y pass.

## Under the hood

`ListView` is a `QtQuick.Templates.Control` with its `contentItem` set to a native `QtQuick.ListView`. The outer `T.Control` exists solely for the `focusPolicy` + `visualFocus` machinery; the inner ListView keeps every Flickable affordance (delegate recycling, `keyNavigationEnabled`, header/footer slots, `currentIndex`).

The default delegate is a `T.ItemDelegate` — the same base used by `Select`'s dropdown rows — with overridden `background` and `contentItem` slots. Role resolution mirrors `Select.qml`: each property checks both `model.<role>` (ListModel / object models) and `modelData.<role>` (primitive-array models), with a final fallback to the primitive value itself for plain string arrays.

The vertical scrollbar is an inline `T.ScrollBar` matching `ScrollArea` exactly — 10 px width, 8 px inner radius, border / mutedForeground color ladder, 180 ms autoHide fade driven by an inline `HoverHandler`. Horizontal scrollbar is intentionally omitted — list rows always span the full viewport width.

Disabled state fades the `background` Rectangle and the ListView body to 50 % alpha but never touches the root control, per pearl-kit's rule that the keyboard focus ring stays full-alpha.

## Deliberate divergences from shadcn

- **No direct shadcn equivalent.** Pearl-kit blends Command + Table idioms into one reusable primitive.
- **Opt-in separators via `showSeparators`** instead of Table's always-on `border-b` — keeps the default look closer to Command (breathing room between rows).
- **Single-line rows only** in the default delegate. Two-line rows (`description` role) would double the `rowHeight` and complicate vertical rhythm; consumers who need them pass a custom `delegate`.
- **`"card"` / `"flush"` variant instead of responsive class system** — pearl-kit is desktop-first with no Tailwind responsive breakpoints to emulate.
- **Single-selection only.** Multi-selection (Ctrl/Cmd+Click, Shift+Click range) would require a different selection model and signal surface — deferred until a concrete consumer asks for it.
