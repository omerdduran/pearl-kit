# Render3D

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=render-3d"
        title="Live Render3D demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A volumetric-render placeholder — gradient fill, an implant marker, a canal-hint label strip, and three corner metadata labels. Use it as the inline preview tile in case cards until a real 3D render is wired in.

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

P.Render3D {
    width: 320
    height: 200
    topLabel: "3D · VOLUMETRIC"
    bottomRightLabel: "0.3mm · 512³"
    bottomLeftLabel: "⊙ canal detected"
}
```

## Toggle overlays

```qml
P.Render3D {
    showImplantMarker: false
    showCanalHint: true
}
```

## Hide the bottom-left label

Set `bottomLeftLabel` to the empty string to hide the canal-hint text entirely — useful once a real CBCT render replaces the decorative mockup and the mock label no longer matches the underlying imagery.

```qml
P.Render3D {
    imageSource: "file:///.../case-render.png"
    bottomLeftLabel: ""       // hide the mock "◉ canal detected" glyph
    showCanalHint: false      // also hide the yellow canal line
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `topLabel` | `string` | `"3D · VOLUMETRIC"` | Top-left label. |
| `bottomRightLabel` | `string` | `"0.3mm · 512³"` | Bottom-right label. |
| `bottomLeftLabel` | `string` | `"⊙ canal detected"` | Bottom-left label. Set to `""` to hide the `Text` node entirely. |
| `showImplantMarker` | `bool` | `true` | Toggle the implant marker. |
| `showCanalHint` | `bool` | `true` | Toggle the canal-hint strip. |
| `monoFontFamily` | `string` | `Tokens.font.mono` | Label font. |
