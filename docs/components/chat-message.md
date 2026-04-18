# ChatMessage

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=chat-message"
        title="Live ChatMessage demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A single turn in a chat log. User turns render with a blue author label + a
muted `#F7F8FA` bubble. AI turns render with a grey author label + a 2 px
left-border text block (no background). Optional `actionLabel` appends an
outline `Chip` action below the body (used for "APPLY TO PLAN →").

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

Column {
    width: 320; spacing: 14
    P.ChatMessage {
        role: "ai"
        author: "DALI"
        text: "Plan #2041-04 ready for review."
        width: parent.width
    }
    P.ChatMessage {
        role: "user"
        author: "DR. KAYA"
        text: "What is the bone density around implant #23?"
        width: parent.width
    }
    P.ChatMessage {
        role: "ai"
        author: "DALI"
        text: "Yes. −2° lingual rotation gains 0.6 mm clearance."
        actionLabel: "APPLY TO PLAN →"
        width: parent.width
        onAction: console.log("apply")
    }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `role` | `string` | `"ai"` | `user` or `ai` — drives author label color and body styling. |
| `author` | `string` | `""` | Mono uppercase author label; hidden when empty. |
| `text` | `string` | `""` | Wrapped message body. |
| `actionLabel` | `string` | `""` | Optional outline-chip label below the body. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface. |

## Signals

- `action()` — emitted when the action chip is clicked.

## Notes

- Source: `report-tab.jsx:100-124` in the DALI design handoff.
- LLM wiring is out of scope — this component ships UI only.
