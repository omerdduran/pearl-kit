# Input

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=input"
        title="Live Input demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/input)'s Input. Single 36 px height, `property bool error` for invalid state, optional `iconLeft` / `iconRight` slots, full keyboard and IME support via `QtQuick.Templates.TextField`.

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

P.Input {
    placeholderText: "you@example.com"
    onTextChanged: console.log("value:", text)
}
```

## Basic usage

```qml
P.Input {
    placeholderText: "Enter your name"
    text: "Omer"
    onAccepted: console.log("submitted:", text)
}
```

Input exposes the full `T.TextField` API, including `text`, `placeholderText`, `textChanged`, `accepted`, `editingFinished`, and more.

## Error state

```qml
P.Input {
    placeholderText: "Email"
    text: "not-an-email"
    error: true
}
```

When `error` is `true`:

- Border color switches to `Tokens.destructive`
- Focus ring color switches to destructive at 20% alpha (shadcn `ring-destructive/20`)
- Text color stays normal — shadcn does not change text color on error, only the chrome

Toggle `error` based on your own validation logic:

```qml
P.Input {
    id: emailInput
    placeholderText: "Email"
    error: text.length > 0 && !text.includes("@")
}
```

## Icons

`iconLeft` and `iconRight` accept URLs to any image format Qt's `Image` element supports (PNG, JPG, SVG, WebP). Icons render at **16 × 16** logical pixels and automatically adjust input padding to prevent text overlap.

```qml
P.Input {
    iconLeft: "qrc:/icons/search.svg"
    placeholderText: "Search..."
}

P.Input {
    iconRight: "qrc:/icons/clear.svg"
    placeholderText: "Filter"
}

P.Input {
    iconLeft: "qrc:/icons/mail.svg"
    iconRight: "qrc:/icons/check.svg"
    placeholderText: "Email"
}
```

When an icon is present on a side, horizontal padding on that side jumps from 12 px to 36 px (12 base + 16 icon + 8 gap). Empty string URLs hide the slot and reclaim the padding.

## Disabled

```qml
P.Input {
    text: "read-only value"
    placeholderText: "Disabled field"
    enabled: false
}
```

When disabled:

- Background, text, and placeholder fade to 50% opacity
- Pointer and keyboard interaction is suppressed
- Input is skipped in the focus chain

Importantly, the focus ring is **not** faded — pearl-kit applies opacity to the background and text layers separately, leaving the ring (hosted on the root control) at full alpha. This matches shadcn's visual hierarchy where disabled inputs still show a distinct ring if programmatically focused.

## Password / echo mode

`T.TextField`'s `echoMode` property is a passthrough — pearl-kit adds no wrapper:

```qml
P.Input {
    placeholderText: "Password"
    echoMode: TextInput.Password
}
```

Supported values: `TextInput.Normal`, `TextInput.Password`, `TextInput.NoEcho`, `TextInput.PasswordEchoOnEdit`.

## States

| State | Trigger | Visual |
|---|---|---|
| Default | Idle | Border `Tokens.border`, transparent background (light) or `Tokens.input @ 0.3` (dark) |
| Hover | Pointer over | Same as default (no distinct hover style — shadcn parity) |
| Focused | Mouse click or keyboard Tab | Border → `Tokens.ring`, 3 px focus ring at 50% alpha |
| Error | `error: true` | Border → `Tokens.destructive`, ring color → destructive at 20% alpha if focused |
| Disabled | `enabled: false` | 50% opacity on text, placeholder, and background. No interaction. |

Unlike Button, Input's focus ring appears on **any** focus source (mouse click or keyboard). Text inputs need caret feedback regardless of how focus arrived — this follows Material, Mantine, Chakra, and Radix UI conventions.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `text` | `string` | `""` | Current input value (inherited from `T.TextField`). |
| `placeholderText` | `string` | `""` | Placeholder shown when `text` is empty. |
| `error` | `bool` | `false` | Toggles invalid-state visuals (border + ring color). |
| `iconLeft` | `url` | `""` | Optional 16×16 icon rendered on the left side of the input. |
| `iconRight` | `url` | `""` | Optional 16×16 icon rendered on the right side of the input. |
| `enabled` | `bool` | `true` | Inherited. Toggles disabled visuals and suppresses interaction. |
| `echoMode` | `int` | `TextInput.Normal` | Inherited. Password/no-echo passthrough. |
| `validator` | `Validator` | `null` | Inherited. Pass any `IntValidator`, `DoubleValidator`, `RegExpValidator`. |
| `inputMask` | `string` | `""` | Inherited. Qt input mask passthrough (e.g. `"000-000"`). |
| `selectByMouse` | `bool` | `true` | Inherited. Mouse drag selects text. |

### Inherited signals from `T.TextField`

| Signal | When |
|---|---|
| `textChanged()` | Any edit to `text` |
| `accepted()` | User presses Return/Enter |
| `editingFinished()` | Focus is lost after edits |
| `textEdited()` | User explicitly edits (not programmatic change) |

## Accessibility

- **Keyboard navigation** — Qt's `TextInput` base handles all standard editing keys: Backspace, Delete, arrow keys, Home/End, Ctrl+A/C/V/X/Z/Y. Do **not** add `Keys.on*Pressed` handlers — they will duplicate or swallow events.
- **IME support** — Input method composition (Japanese, Chinese, Korean, dead-key combinations) works automatically through Qt's `QInputMethod` integration. No pearl-kit configuration required.
- **Focus chain** — Inputs participate in Tab navigation by default (`focusPolicy: Qt.StrongFocus`).
- **Selection** — Mouse drag and Shift+arrow selection both work. Selection color is `Tokens.ring` at 35% alpha for subtle highlight.

## Under the hood

Input is a `QtQuick.Templates.TextField`, not `QtQuick.Controls.Basic.TextField`. Templates provides the headless editing primitives — caret rendering, selection tracking, IME composition, undo/redo, click-to-position, dead-keys, password echo, text wrapping — while all visual rendering is pearl-kit's own.

Critically, Input **does not override `contentItem`**. The default `TextInput` child of `T.TextField` handles every text editing behavior. Overriding it would lose all of the above. Only the `background` Rectangle is custom, and the focus ring is an auxiliary `PearlFocusRing` sibling.

Both `iconLeft` and `iconRight` are rendered as **children of the background Rectangle**, anchored to their respective sides. `Image` elements have no `MouseArea` by default, so pointer events pass through to the text input beneath — you can still click anywhere in the input to position the caret.

Every color, radius, padding, and motion value resolves through `Tokens.*`, so theme changes (`Tokens.mode = Tokens.Light`) propagate automatically to every Input instance.
