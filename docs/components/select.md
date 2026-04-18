# Select

A non-editable dropdown with keyboard navigation and a popper-positioned popup. Ports [shadcn/ui v4 Select](https://ui.shadcn.com/docs/components/select) to `QtQuick.Templates.ComboBox`. Supports flat lists, typed models (`textRole` / `valueRole`), and grouped models with header and separator rows.

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
import PearlKit 1.0 as P

P.Select {
    model: ["Apple", "Banana", "Cherry"]
    onCurrentIndexChanged: console.log("picked", currentText)
}
```

## Basic usage

`Select` inherits `QtQuick.Templates.ComboBox`, so the usual Qt properties are available: `model`, `currentIndex`, `currentText`, `currentValue`, `displayText`, `textRole`, `valueRole`, `count`, `activated`, `accepted`.

```qml
P.Select {
    placeholderText: "Choose a language"
    textRole: "text"
    valueRole: "value"
    model: ListModel {
        ListElement { text: "Türkçe";  value: "tr" }
        ListElement { text: "English"; value: "en" }
    }
    onActivated: (index) => console.log("activated", currentValue)
}
```

## Sizes

| Size | Height |
|---|---|
| `default` | 36 |
| `sm` | 32 |

```qml
Row {
    spacing: 12
    P.Select { model: ["a", "b"] }
    P.Select { size: "sm"; model: ["a", "b"] }
}
```

## States

| State | Trigger | Visual |
|---|---|---|
| Default | idle | Transparent bg (light) / `Tokens.input @ 30%` (dark); `Tokens.border` frame |
| Hover | pointer over | Dark-mode bg lifts to `Tokens.input @ 50%` |
| Focus (keyboard) | Tab | 3 px ring at `Tokens.ring @ 50%`, border switches to `Tokens.ring` |
| Error | `error: true` | Border + ring switch to `Tokens.destructive` (ring at 20% alpha) |
| Disabled | `enabled: false` | Background, content, and chevron all fade independently; focus ring unaffected |
| Open | popup visible | Popup fades + scales in below the trigger with a 4 px offset |

## Grouped model — `type` role

Pearl-kit merges shadcn's `<SelectGroup>` / `<SelectLabel>` / `<SelectSeparator>` into a single model-driven API. Each row can carry a `type`:

| `type` | Rendered as | Selectable |
|---|---|---|
| `"item"` (default) | Normal row with label and optional current-selection dot | Yes |
| `"header"` | Small muted label in `text-xs` / `mutedForeground` | No |
| `"separator"` | 1 px horizontal line in `Tokens.border` | No |

```qml
P.Select {
    textRole: "text"
    model: ListModel {
        ListElement { type: "header"; text: "Latin" }
        ListElement { type: "item";   text: "English" }
        ListElement { type: "item";   text: "Türkçe" }
        ListElement { type: "separator" }
        ListElement { type: "header"; text: "CJK" }
        ListElement { type: "item";   text: "日本語" }
        ListElement { type: "item";   text: "中文" }
    }
}
```

Rows without a `type` field default to `"item"` — plain string arrays work as before.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `model` | `any` | `[]` | Data source (inherited from `T.ComboBox`) |
| `textRole` | `string` | `""` | Role for display text on object models |
| `valueRole` | `string` | `""` | Role for `currentValue` on object models |
| `currentIndex` | `int` | first item row | Selected index |
| `currentText` | `string` | `""` | Label of selected row |
| `currentValue` | `any` | `undefined` | Value of selected row via `valueRole` |
| `placeholderText` | `string` | `""` | Shown when `currentIndex === -1` |
| `size` | `string` | `"default"` | `"default"` or `"sm"` |
| `error` | `bool` | `false` | Invalid-state visuals |
| `enabled` | `bool` | `true` | Interaction + focus |

## Keyboard

- **Tab** — focus the trigger
- **Space / Return** — open the popup
- **Up / Down** — move highlight; when popup is closed, changes `currentIndex` directly
- **Home / End** — first / last row
- **Escape** — close popup without committing
- **Type-ahead** — jump to rows whose label starts with the typed character (Qt native)

The focus ring is keyboard-only (matches shadcn's `focus-visible:`). Clicking the trigger does not reveal the ring — per Apple HIG convention.

## Accessibility

`focusPolicy: Qt.StrongFocus` — the trigger participates in tab order and Qt's accessibility tree exposes the control as a combo box. The popup inherits Qt's default overlay focus handling; `Escape` closes it, `Return` commits on an item row.

## Under the hood

`Select` overrides every `T.ComboBox` slot:

- `background` — Input-style rectangle with theme-aware color, border, and `Behavior on border.color` for focus / error transitions
- `contentItem` — a `PearlBaseText` showing `displayText` or `placeholderText` with disabled-aware color ternaries
- `indicator` — a `PearlChevron` (Canvas-based stroked chevron), positioned absolutely at `x = control.width - 28`
- `popup` — an inline `T.Popup` parented to `T.Overlay.overlay`, containing a `ListView` bound to `control.delegateModel` and `control.highlightedIndex`; enter transition fades + scales (`Tokens.motion.fast`)
- `delegate` — a `T.ItemDelegate` that branches on a `_type` property derived from `model.type` or `modelData.type`, producing three visual forms

The focus ring targets `control` directly (not the indicator), because the trigger is rectangular and Qt's default `Tokens.radius.md` fallback on `PearlFocusRing` wraps it correctly.

### Non-selectable row guard

Qt's `T.ComboBox` has no native concept of non-selectable rows. Pearl-kit implements the guard explicitly:

```qml
property int _lastValidIndex: 0

onActivated: function(index) {
    if (_rowType(index) === "item") {
        _lastValidIndex = index
    } else {
        currentIndex = _lastValidIndex
    }
}
```

On `Component.onCompleted`, the first `"item"` row in the model is seeded as the current selection so the trigger never displays a header or separator label.

## Known limitations

1. **Keyboard navigation does not skip headers and separators.** Up / Down moves through every row, including non-selectable ones. Pressing Enter on a header or separator triggers the `onActivated` guard, which reverts the selection. Visually the highlight passes across the non-item rows. This is a Qt `T.ComboBox` limitation — there is no hook to tell the built-in navigation to skip rows.
2. **Popup positioning is popper-style only.** shadcn's default `position="item-aligned"` — where the popup opens with the selected row aligned on top of the trigger — has no Qt equivalent. The popup always opens below the trigger with a 4 px offset.
3. **Popup max height is a static 320 px.** shadcn uses `max-h-(--radix-select-content-available-height)` which is viewport-aware; pearl-kit clamps to 320 px for now. Dynamic viewport-aware clamping is deferred to v0.2.
4. **No scroll up / down buttons.** pearl-kit uses Qt's native `ScrollIndicator.vertical`, which is desktop-appropriate.

## Deliberate differences from shadcn

1. **Model-driven API.** shadcn composes `<SelectItem>` children; pearl-kit uses Qt's `model` + `textRole` + `valueRole`. Unavoidable for QML.
2. **`type` role on model rows** replaces `<SelectLabel>` and `<SelectSeparator>` components.
3. **Minimal filled dot** instead of a check icon on the selected row — avoids shipping an extra Canvas atom just for a check glyph.
4. **No `shadow-md` on the popup** — the 1 px border provides enough separation; `Tokens.shadow.*` is reserved for Dialog.
5. **Popper-style positioning only** (item-aligned omitted).
6. **No ScrollUp / ScrollDown chevron buttons** (native ScrollIndicator).
7. **Keyboard nav does not skip non-items** (Qt limitation; committed values are still guarded).

## Related

- [Input](input.md) — text entry with the same border / focus ring patterns
- [Button](button.md) — non-stateful action triggers
