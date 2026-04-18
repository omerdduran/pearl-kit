# TextArea

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=textarea"
        title="Live TextArea demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/textarea)'s Textarea. Auto-growing multiline text input with `property bool error`, `property bool mono` for monospace variants, and full keyboard / IME support via `QtQuick.Templates.TextArea`.

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

P.TextArea {
    placeholderText: "Clinical notes..."
    onTextChanged: console.log("value:", text)
}
```

## Basic usage

```qml
P.TextArea {
    placeholderText: "Describe the procedure plan"
    Layout.preferredWidth: 420
}
```

TextArea auto-grows from a 64 px floor (shadcn `min-h-16`) based on content. Set an explicit `height` or `Layout.preferredHeight` to bound the growth — useful for log viewers or fixed-row composers.

## Error state

```qml
P.TextArea {
    placeholderText: "Required field"
    text: "too short"
    error: true
}
```

When `error` is `true`:

- Border color switches to `Tokens.destructive`
- Focus ring color switches to destructive at 20% alpha (shadcn `aria-invalid:ring-destructive/20`)
- Text color stays normal — shadcn changes only chrome, not content color

## Mono variant

`property bool mono` swaps the font family from `Tokens.font.ui` (SF Pro Display) to `Tokens.font.mono` (SF Mono). Use it for inputs where each character carries meaning individually rather than as prose:

```qml
P.TextArea {
    mono: true
    placeholderText: "XXXX-XXXX-XXXX-XXXX"
}

P.TextArea {
    mono: true
    readOnly: true
    Layout.preferredHeight: 240
    text: logs.join("\n")
}
```

Common call sites: license key entry, log viewer, configuration file preview, CLI output capture. Plain variant (`mono: false`, the default) covers clinical notes, comments, and any natural-language multiline input.

## Read-only

For log viewer and output-capture use cases, set `readOnly: true`. Selection, copy-to-clipboard, and caret navigation remain available; typing is suppressed:

```qml
P.TextArea {
    Layout.preferredWidth: 520
    Layout.preferredHeight: 200
    mono: true
    readOnly: true
    text: processOutput
}
```

## Disabled

```qml
P.TextArea {
    text: "read-only contents"
    placeholderText: "Disabled field"
    enabled: false
}
```

When disabled:

- Background, text, and placeholder fade to 50% opacity
- Pointer and keyboard interaction is suppressed
- TextArea is skipped in the focus chain

The focus ring itself is **not** faded — pearl-kit applies opacity to the background and text layers separately so the ring (hosted on the root control) stays full-alpha if the field is programmatically focused.

## Auto-grow

shadcn's `field-sizing-content min-h-16` ports to `implicitHeight: Math.max(minHeight, contentHeight + topPadding + bottomPadding)`. The field grows as you type and shrinks when lines are removed, with a 64 px floor by default. Override the floor per-instance:

```qml
P.TextArea {
    minHeight: 120
    placeholderText: "Minimum 120 px"
}
```

To pin an explicit height and enable internal scrolling, set `Layout.preferredHeight` (or plain `height`) — content beyond the box becomes scroll-reachable via arrow keys, Page Up/Down, and mouse wheel:

```qml
P.TextArea {
    Layout.preferredWidth: 420
    Layout.preferredHeight: 160
    text: longContent
}
```

## States

| State | Trigger | Visual |
|---|---|---|
| Default | Idle | Border `Tokens.border`, transparent background (light) or `Tokens.input @ 0.3` (dark) |
| Hover | Pointer over | Same as default (no distinct hover style — shadcn parity) |
| Focused | Mouse click or keyboard Tab | Border → `Tokens.ring`, 3 px focus ring at 50% alpha |
| Error | `error: true` | Border → `Tokens.destructive`, ring color → destructive at 20% alpha if focused |
| Disabled | `enabled: false` | 50% opacity on text, placeholder, and background. No interaction. |

Like Input, TextArea's focus ring appears on **any** focus source (mouse click or keyboard). Text inputs need caret feedback regardless of how focus arrived.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `text` | `string` | `""` | Current content (inherited from `T.TextArea`). |
| `placeholderText` | `string` | `""` | Placeholder shown when `text` is empty. |
| `error` | `bool` | `false` | Toggles invalid-state visuals (border + ring color). |
| `mono` | `bool` | `false` | Swaps font family to `Tokens.font.mono`. |
| `minHeight` | `int` | `64` | Floor for auto-grown `implicitHeight`. Matches shadcn `min-h-16`. |
| `readOnly` | `bool` | `false` | Inherited. Disables editing while keeping selection and keyboard navigation. |
| `wrapMode` | `int` | `TextEdit.Wrap` | Inherited. Word wrap policy. |
| `enabled` | `bool` | `true` | Inherited. Toggles disabled visuals and suppresses interaction. |
| `selectByMouse` | `bool` | `true` | Inherited. Mouse drag selects text. |

### Inherited signals from `T.TextArea`

| Signal | When |
|---|---|
| `textChanged()` | Any edit to `text` |
| `editingFinished()` | Focus is lost after edits |

Unlike `T.TextField`, `T.TextArea` does not emit `accepted()` on Return — Return always inserts a newline. Intercept submit via a sibling `Shortcut { sequence: "Ctrl+Return" }` if you need a key-driven send action.

## Accessibility

- **Keyboard navigation** — Qt's `TextEdit` base handles all standard editing keys: Backspace, Delete, arrow keys, Home/End, Page Up/Down, Ctrl+A/C/V/X/Z/Y. Do **not** add `Keys.on*Pressed` handlers — they will duplicate or swallow events.
- **IME support** — Input method composition (Japanese, Chinese, Korean, dead-key combinations) works automatically through Qt's `QInputMethod` integration.
- **Focus chain** — TextArea participates in Tab navigation by default (`focusPolicy: Qt.StrongFocus`). Tab inserts a literal tab character inside the field; use Shift+Tab to escape.
- **Selection** — Mouse drag and Shift+arrow selection both work. Selection color is `Tokens.ring` at 35% alpha.

## Under the hood

TextArea is a `QtQuick.Templates.TextArea`, not `QtQuick.Controls.Basic.TextArea`. Templates provides the headless editing primitives — caret rendering, selection tracking, IME composition, undo/redo, multi-line wrapping, click-to-position — while all visual rendering is pearl-kit's own.

Critically, TextArea **does not override `contentItem`**. The default `TextEdit` child of `T.TextArea` handles every text editing behavior. Overriding it would lose caret, IME, selection, and undo/redo. Only the `background` Rectangle is custom, and the focus ring is an auxiliary `PearlFocusRing` sibling.

Every color, radius, padding, and motion value resolves through `Tokens.*`, so theme changes (`Tokens.mode = Tokens.Light`) propagate automatically to every TextArea instance.

### Deliberate divergences from shadcn

- **`mono` variant** — shadcn Textarea has no font-family variant; pearl-kit adds `mono` to cover license key entry, log viewers, and CLI output capture without consumers needing to compose two primitives. Plain variant matches shadcn exactly.
- **Font size** — shadcn uses `text-base md:text-sm` (16 px mobile, 14 px md+). Pearl-kit is desktop-first and uses `Tokens.font.size.sm` (14 px) uniformly.
- **Focus ring trigger** — shadcn uses `focus-visible:` (keyboard-only). Pearl-kit TextArea uses `activeFocus` (any source) — text inputs need caret feedback regardless of how focus arrived. Matches Input's behavior.
- **`minHeight` as an explicit property** — shadcn bakes `min-h-16` into the class list. Pearl-kit exposes it as a property so consumers can set tighter floors (`minHeight: 40`) or roomier ones (`minHeight: 200`) without subclassing.
