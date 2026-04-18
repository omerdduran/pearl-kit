# FormRow

A horizontal label-and-input primitive with optional hint and error slots per row. Stack several `FormRow`s inside a `ColumnLayout` to build classic desktop settings forms.

shadcn/ui ships `Label`, `Form`, and a set of related form primitives — but shadcn forms always stack vertically (label above input). `FormRow` is a pearl-kit-original layout primitive that lays label and input **side by side** to match desktop form conventions, using shadcn label typography and message colors throughout.

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
    spacing: 8

    P.FormRow {
        Layout.fillWidth: true
        label: "Email"
        P.Input { placeholderText: "you@example.com" }
    }
}
```

Place exactly one child inside each `FormRow` — the input component you want labeled. `FormRow` binds its slot's width to the child automatically, so your input fills the available space.

## Basic usage

The minimum: a label paired with an input.

```qml
P.FormRow {
    Layout.fillWidth: true
    label: "First name"
    P.Input { }
}
```

Any pearl-kit control (or any Item) works as the child — `Input`, `Select`, `Toggle`, `Stepper`, `CheckBox`, or a custom composition.

```qml
P.FormRow {
    Layout.fillWidth: true
    label: "Language"
    P.Select { model: ["English", "Türkçe", "Deutsch"] }
}

P.FormRow {
    Layout.fillWidth: true
    label: "Notifications"
    P.Toggle { }
}
```

## Hint

Set `hint` to display muted helper text directly below the input, left-aligned with the input column (not the label column).

```qml
P.FormRow {
    Layout.fillWidth: true
    label: "Email"
    hint: "We'll never share your address."
    P.Input { placeholderText: "you@example.com" }
}
```

Hint typography matches shadcn's `FormDescription`: 14 px, `Tokens.mutedForeground`.

## Error

Set `error` to a non-empty string to display an error message. An error replaces the hint, recolors the label with `Tokens.destructive`, and tints the error text the same. Compose with the input's own `error: true` for the full invalid-state visual:

```qml
P.FormRow {
    Layout.fillWidth: true
    label: "Password"
    error: "Password is required."
    P.Input {
        placeholderText: "••••••••"
        echoMode: TextInput.Password
        error: true
    }
}
```

Error color is `Tokens.destructive`. When `error` is an empty string, `hint` takes over.

## Label width

The label column reserves a fixed width (default 120 px). Override per-row with `labelWidth`, or use the same value on every row for perfectly aligned columns:

```qml
ColumnLayout {
    spacing: 8

    P.FormRow {
        Layout.fillWidth: true
        label: "Server endpoint URL"
        labelWidth: 160
        P.Input { }
    }
    P.FormRow {
        Layout.fillWidth: true
        label: "Timeout"
        labelWidth: 160
        P.Stepper { from: 0; to: 60; value: 30; suffix: " s" }
    }
}
```

If the label text exceeds `labelWidth`, it wraps to multiple lines (`wrapMode: Text.WordWrap`). The input stays on the first row and the label vertically centers against it.

## Disabled

`enabled: false` fades both label and meta text (hint / error) to 50 % alpha. It does **not** automatically disable the input child — set `enabled: false` on the input separately if you need to.

```qml
P.FormRow {
    Layout.fillWidth: true
    label: "API key"
    enabled: false
    P.Input { text: "sk-••••••"; enabled: false }
}
```

## States

| State | Trigger | Visual |
|---|---|---|
| Default | idle | Label left, input right, 12 px gap |
| With hint | `hint` non-empty, `error` empty | Muted 14 px text below input |
| With error | `error` non-empty | Destructive 14 px text below input, label recolored |
| Disabled | `enabled: false` | Label + meta text at 50 % alpha |

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `label` | `string` | `""` | Label text displayed in the left column. |
| `hint` | `string` | `""` | Optional helper text below the input. Hidden when empty. |
| `error` | `string` | `""` | Error message. When non-empty, overrides `hint`, recolors label. |
| `labelWidth` | `int` | `120` | Fixed width (px) of the label column. |
| `enabled` | `bool` | `true` | Standard QML disabled flag. Fades label + meta text. Does not auto-propagate to the input child. |
| `content` (default) | `list<Item>` | `[]` | Default slot — exactly one child, the input. Its width is bound to the slot automatically. |

## Accessibility

- **Focus** — `FormRow` itself is not focusable. The input child participates in Tab navigation as usual.
- **Label association** — QML does not have a `<label htmlFor>` equivalent. The visual pairing is layout-based. Consumers who need screen-reader label-control association should set `Accessible.name` on the input to the label text, or use `Accessible.labelledBy` bindings.
- **Error announcement** — when `error` is set, the destructive text appears as a visible child of the row. Consumers needing live-region semantics should wire `Accessible.role: "alert"` on their own.

## Under the hood

`FormRow` is a plain `Item` root with a 2-column `GridLayout` inside. Unlike most pearl-kit components, it does not inherit from `QtQuick.Templates.*` — it has no interactive state (no hover, no focus, no pressed), so the Templates layer would add nothing.

The grid has two rows:

- **Row 0** — label (column 0, fixed `labelWidth`) + input slot (column 1, `Layout.fillWidth: true`). Label is `Qt.AlignVCenter` so it centers vertically against the input, independent of the hint/error text below.
- **Row 1** — empty (column 0 is skipped via `Layout.column: 1` on the meta text) + hint / error text (column 1). Hidden entirely when both are empty.

Why `GridLayout` and not two nested `RowLayout` + `ColumnLayout`s? Because the label must align to the *input*'s vertical center, not the combined *row*'s center. If hint or error is visible the column height grows; nested layouts would drift the label downward. GridLayout rows size independently, so the label stays anchored to row 0.

The input slot auto-sizes the first child:

```qml
onChildrenChanged: _bindFirstChildWidth()
Component.onCompleted: _bindFirstChildWidth()

function _bindFirstChildWidth() {
    if (children.length > 0) {
        children[0].width = Qt.binding(() => _slot.width)
    }
}
```

This is an explicit `Qt.binding` so the child's width tracks the slot width even when the outer `FormRow` is resized. If you need a narrower input, wrap it in a `Row` with a trailing stretcher item and put that `Row` in the slot.

The component composes existing pearl-kit atoms:

- **`PearlText` with `variant: "label"`** for the label (14 px, medium weight, `Tokens.foreground` / `Tokens.destructive` when errored). `leading-none` (1.0) matches shadcn's label typography.
- **`PearlText` with `variant: "muted"`** for the hint / error row (14 px, regular weight, `Tokens.mutedForeground` / `Tokens.destructive`).
- **`Behavior on color`** at `Tokens.motion.fast` (150 ms) on both text items so error transitions aren't instant.

## Deliberate divergences from shadcn

- **Horizontal layout, not vertical.** shadcn `Form` stacks label above input. Desktop form patterns (macOS System Settings, GNOME dconf-editor, every Qt Designer form) align label to the left of the input at a fixed column width. pearl-kit is macOS-first desktop — horizontal is the native idiom. Consumers who want vertical stacking can compose `ColumnLayout { PearlText; Input; PearlText }` directly.
- **No shadcn primitive named `FormRow`.** shadcn's form suite is `Form`, `FormField`, `FormItem`, `FormLabel`, `FormControl`, `FormDescription`, `FormMessage` — a 7-component React tree glued together by `react-hook-form`. pearl-kit does not ship a state-management library, so a context-driven form tree would have no state to bind to. `FormRow` collapses the useful visual-composition bits of that tree into a single primitive.
- **No `FormField` / `Form` wrapper.** The shadcn `<Form>` provider and `<FormField>` `react-hook-form` controller are state-management concerns, not layout concerns. pearl-kit callers bind their own state directly to the input child's `text` / `checked` / `value` properties.
- **Single child slot, not a composition tree.** shadcn `FormItem` wraps `FormLabel`, `FormControl`, `FormDescription`, `FormMessage` as siblings. `FormRow` bakes the label / description / message into properties so the call site stays flat (one `P.FormRow { label; hint; Input { } }` instead of four nested components).
- **`aria-describedby` not auto-wired.** shadcn ties the input's `aria-describedby` to the `FormDescription` and `FormMessage` IDs via `FormControl`. QML's accessibility surface uses `Accessible.name` / `Accessible.description`, not HTML ARIA attributes. If you need strict a11y pairing, set `Accessible.description` on the input child.
