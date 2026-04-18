# CodeBlock

A bordered, rounded monospace container for rendering fenced code blocks — optional filename header with inline copy button, selectable text, horizontal and vertical scroll for long content. Primary use case: chat-message surfaces that render assistant-authored markdown with ```fenced``` blocks.

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

P.CodeBlock {
    width: 480
    code: 'const greet = (name) => `Hello, ${name}!`\ngreet("world")\n'
    language: "typescript"
    filename: "greet.ts"
}
```

## Basic usage

The minimum is a `code` string — no filename, no language, just a copyable monospace panel:

```qml
P.CodeBlock {
    width: 400
    code: "pip install pearl-kit"
}
```

The copy button sits in the header whether or not a filename is set. Set `showCopyButton: false` to drop the header entirely when both fields are empty.

## With filename header

```qml
P.CodeBlock {
    width: 480
    filename: "example.py"
    language: "python"
    code: "def greet(name: str) -> str:\n    return f\"Hello, {name}!\"\n"
}
```

The filename renders in monospace at 12px (`Tokens.font.size.xs`) in `Tokens.mutedForeground`. The `language` property is informational — pearl-kit's core `CodeBlock` does not ship a syntax highlighter (see [Under the hood](#under-the-hood)).

## No copy button

```qml
P.CodeBlock {
    width: 400
    code: "// read-only display\nreturn 42;\n"
    showCopyButton: false
    filename: "snippet.js"
}
```

When both `filename` is empty **and** `showCopyButton` is `false`, the header collapses to zero height.

## Long content and scroll

Code wider than the viewport scrolls horizontally. Code taller than `maxBodyHeight` (default `360`) scrolls vertically. Text selection works by click-and-drag.

```qml
P.CodeBlock {
    Layout.fillWidth: true
    Layout.preferredHeight: 200
    maxBodyHeight: 200
    filename: "server.ts"
    code: longSourceString
}
```

Override `maxBodyHeight` to cap the intrinsic height, or pass an explicit `Layout.preferredHeight` / `height` to let the parent container drive the layout.

## States

| State | Trigger | Visual |
|---|---|---|
| Idle | Default | Card background, muted header, `Tokens.border` outline |
| Copy hover | Pointer over copy button | Button fills with `Tokens.accent`, icon tints to `Tokens.accentForeground` |
| Copy focused | Tab navigation | 3px focus ring at `Tokens.ring @ 50%` |
| Copied | Copy button clicked | Icon swaps from copy glyph to green `PearlCheckIcon` for `copyTimeout` ms (default 2000) |
| Disabled | `enabled: false` | Surface + header fade to 50% alpha, copy button non-interactive |

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `code` | `string` | `""` | The code to display. Newlines are rendered as literal line breaks; no markdown parsing. |
| `language` | `string` | `""` | Informational language hint. Currently not used for highlighting — reserved for a future `Full` scope. |
| `filename` | `string` | `""` | Optional filename shown in the header. Empty hides the filename label. |
| `showCopyButton` | `bool` | `true` | Whether the copy affordance is visible in the header. |
| `copyTimeout` | `int` | `2000` | Milliseconds the check glyph remains visible after a successful copy. |
| `maxBodyHeight` | `int` | `360` | Upper bound on the body's preferred height. Content taller than this scrolls vertically. |
| `copied` | `bool` (read-only) | `false` | `true` for `copyTimeout` ms after a successful copy. Useful for external indicators. |

### Signals

| Signal | When |
|---|---|
| `copyRequested()` | Fired immediately after the code has been written to the clipboard. |

### Methods

| Method | Description |
|---|---|
| `copyToClipboard()` | Imperatively copies the current `code` value and flips `copied` to `true` for `copyTimeout` ms. Useful when wiring an external copy trigger. |

## Accessibility

- **Selectable text** — the body is a `TextEdit` with `readOnly: true` and `selectByMouse: true`, so users can highlight and copy any sub-range with the pointer, keyboard, or system copy shortcut (⌘C / Ctrl+C) even without the dedicated copy button.
- **Keyboard activation** — the copy button sits in the Tab focus chain with `focusPolicy: Qt.StrongFocus`. Space / Return fires `clicked()` via `T.Button`'s base implementation (do **not** write manual `Keys.on*` handlers).
- **Disabled state** — `enabled: false` fades the surface and skips the copy button in the focus chain.

## Under the hood

`CodeBlock` is a composite `Item` built from three layers:

- A `Rectangle` surface at `Tokens.card` with `Tokens.radius.md` corners and a 1px `Tokens.border` outline. `clip: true` keeps the header's muted fill from bleeding outside the rounded corner.
- An optional header `Rectangle` at `Tokens.muted`, 44px tall, holding the filename `PearlText` anchored left and a `T.Button` anchored right. A 1px `Tokens.border` hairline separates it from the body.
- A `Flickable` body wrapping a read-only `TextEdit`. The `Flickable` drives horizontal and vertical scroll via `contentWidth` / `contentHeight` bound to the `TextEdit`'s `contentWidth` / `contentHeight` plus 16px padding on each side.

The copy button is implemented as a local `T.Button` (not the public `PearlKit.Button`) because the icon glyph swaps between a custom `PearlCopyIcon` and `PearlCheckIcon` on copy — the public Button only accepts a URL-based `iconLeft` / `iconRight`, which would force us to ship SVG assets.

The clipboard write uses a hidden `TextEdit` whose `text` is briefly set to the code, then `selectAll()` + `copy()`. This is the standard pure-QML clipboard idiom and requires no Python-side plumbing.

### Deliberate divergences from shadcn / kibo

- **No syntax highlighting.** The reference kibo `CodeBlock` uses [Shiki](https://shiki.style/) for token-level coloring. Shiki is a web-only library backed by TextMate grammars; there is no Qt equivalent short of shelling out to a CLI highlighter or porting the entire grammar set. Pearl-kit's core scope renders plain monospace in `Tokens.foreground`. A future `Full` scope may ship a minimal `QSyntaxHighlighter`-based tokenizer for a handful of languages.
- **No language selector tabs.** Kibo supports a multi-file `data: CodeBlockData[]` with a `Select` dropdown for switching languages. Pearl-kit's `CodeBlock` is single-file — consumers who need multi-file switching compose two `CodeBlock` instances inside a `TabBar` / `StackedView` pair.
- **No line numbers, no diff markers, no line focus.** These are Shiki transformers in the kibo source; without a highlighter they have no surface to bind to. Ship if and when the full-scope highlighter lands.
- **No filename icon auto-detection.** Kibo maps 80+ file extensions to simple-icons glyphs. Pearl-kit would need a matching set of Canvas icons — deferred until a real consumer asks.
- **Card background instead of transparent.** Kibo's root is transparent (border-only) and the body is `bg-background`. Pearl-kit uses `Tokens.card` at the root so the block reads as an elevated surface when dropped into a plain page.
- **`Tokens.muted` header instead of `bg-secondary`.** Pearl-kit's `Tokens.secondary` is the purple accent color (Button `secondary` variant) — semantically different from shadcn's neutral `bg-secondary`. `Tokens.muted` is the nearest neutral tint.
