# SearchField

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=search-field"
        title="Live SearchField demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A text field with a leading search glyph and a trailing `⌘K` shortcut hint pill — the canonical top-of-list filter box. Built on `T.TextField` so everything from caret, selection, placeholder, IME, and `accepted()` comes from the base.

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

```qml
import QtQuick
import PearlKit 1.0 as P

P.SearchField {
    width: 320
    placeholderText: "Search cases..."
    onAccepted: console.log("search:", text)
}
```

## Custom shortcut

```qml
P.SearchField {
    width: 320
    placeholderText: "Find file"
    shortcutHint: "⌘F"
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `shortcutHint` | `string` | `"⌘K"` | Trailing hint pill label. |
| `borderColor` | `color` | `#DDE2EA` | Outer border. |
| `fontFamily` | `string` | `Tokens.font.ui` | Input font. |
| `monoFontFamily` | `string` | `Tokens.font.mono` | Hint pill font. |

All standard `T.TextField` properties (`text`, `placeholderText`, `echoMode`, `readOnly`, etc.) and signals (`accepted`, `editingFinished`, `textChanged`) are inherited.

## vs. Input

Pick **[`Input`](input.md)** for standard form fields with error state and icon slots. Pick **`SearchField`** when you specifically want the built-in search glyph + keyboard-shortcut affordance — nav bars, list filters, command palettes.
