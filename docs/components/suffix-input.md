# SuffixInput

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=suffix-input"
        title="Live SuffixInput demo"
        loading="lazy"
        width="100%" height="380"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A text field with a right-edge mono suffix and an optional switch to a
monospace input font. Used in the DALI settings forms for unit-suffixed
numerics (`WL HU`, `WW HU`, `MM`, `NCM`) and for identifier-style fields
(DICOM node, AE title, license number) where monospace reads better.

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
    spacing: 8
    P.SuffixInput { text: "400"; suffix: "WL HU"; mono: true; width: 120 }
    P.SuffixInput { text: "2000"; suffix: "WW HU"; mono: true; width: 120 }
    P.SuffixInput { text: "localhost:11112"; mono: true; width: 260 }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `string` | `""` | Input text (inherited from `T.TextField`). |
| `placeholderText` | `string` | `""` | Placeholder (inherited). |
| `suffix` | `string` | `""` | Mono uppercase suffix on the right edge. When set, right padding expands to 40 px. |
| `mono` | `bool` | `false` | Switch the input text font-family to `JetBrains Mono`. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface. |

All standard `T.TextField` properties (`readOnly`, `echoMode`,
`validator`, selection handling, etc.) remain available.

## Notes

- Source: `settings.jsx:113-131` in the DALI settings handoff.
- Kept separate from the stable `Input` to preserve the stable API
  surface. If the `suffix` affordance proves common, we may graduate it
  into `Input` with a deprecation plan for this shim.
