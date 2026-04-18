# PullQuote

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=pull-quote"
        title="Live PullQuote demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

An editorial pull-quote: a large serif `"` glyph on the left + italic
wrapped text on the right. Meant for magazine-layout reports and
long-form narrative captions.

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

P.PullQuote {
    text: "Both fixtures seat in D2 bone. Implant #22 holds a comfortable 3.2 mm canal clearance; #23 is tighter at 2.1 mm."
    maxWidth: 720
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `string` | `""` | Italic wrapped quote text. |
| `quoteGlyph` | `string` | `"\""` | The glyph shown in the left column. |
| `maxWidth` | `int` | `720` | Implicit max-width for the whole composition. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for the quote body. |
| `fontFamilySerif` | `string` | `"Times New Roman"` | Serif typeface for the quote glyph. |
| `quoteColor` | `color` | `#1A202C` | Glyph color. |
| `textColor` | `color` | `#4A5568` | Quote text color. |

## Notes

- Source: `report-tab.jsx:527-533` in the DALI design handoff.
