# ChatComposer

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=chat-composer"
        title="Live ChatComposer demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A compound: pearl-kit `Input` + a mono uppercase dark send button. Pressing
<kbd>Enter</kbd> inside the input triggers submission. Emits
`submitted(text: string)`. Pair with `ChatMessage` for a full chat panel.

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

P.ChatComposer {
    width: 320
    placeholder: "Ask about bone, safety, alternatives…"
    submitLabel: "ASK"
    onSubmitted: (text) => console.log("send", text)
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `string` | `""` | Aliased to the inner `Input.text`. |
| `placeholder` | `string` | `"Ask about bone, safety, alternatives…"` | Input placeholder. |
| `submitLabel` | `string` | `"ASK"` | Send button label — mono uppercase. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the send button. |

## Signals

- `submitted(string text)` — fires on click or <kbd>Enter</kbd>; input is
  cleared automatically. Empty / whitespace-only submissions are ignored.

## Notes

- Source: `report-tab.jsx:139-155` in the DALI design handoff.
