# OrientationCube

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=orientation-cube"
        title="Live OrientationCube demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 52×52 anatomical-orientation marker — labels `R` / `L` / `S` / `I` in a
3×3 grid around a center dot glyph. Drop into the corner of a 3D viewport
to indicate right / left / superior / inferior.

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

P.OrientationCube {
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 10
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `rLabel` | `string` | `"R"` | Right label. |
| `lLabel` | `string` | `"L"` | Left label. |
| `sLabel` | `string` | `"S"` | Superior label. |
| `iLabel` | `string` | `"I"` | Inferior label. |
| `centerGlyph` | `string` | `"◉"` | Center dot glyph. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Label typeface. |

## Notes

- Source: `planning-viewer.jsx:88-98` in the DALI design handoff.
- The original design uses `backdrop-filter: blur(4px)` on the cube
  background — Qt Quick has no direct CSS backdrop-filter equivalent
  without `ShaderEffect`, so we ship with a static translucent fill.
