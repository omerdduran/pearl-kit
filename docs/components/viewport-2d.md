# Viewport2D

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=viewport-2d"
        title="Live Viewport2D demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A CBCT 2D slice imaging surface — black ground, radial atmospheric gradient,
blurred anatomy blob, axis-colored crosshairs, header chip, slice counter,
voxel-info caption, and optional right-edge slice scroll track. The
rendering is **placeholder chrome only**; wire a real volume renderer
(VTK.js, Cornerstone3D, proprietary) downstream of the component and use
the default slot for implant / annotation overlays.

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

P.Viewport2D {
    width: 320; height: 320
    kind: "axial"
    title: "AXIAL"
    slice: 142
    total: 512
    bottomInfo: "WL 400 · WW 2000"

    Rectangle {
        // consumer-supplied overlay — absolute-positioned inside the chrome
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 7; height: 60
        color: Qt.rgba(0.14, 0.39, 0.92, 0.9)
    }
}
```

## Kinds

- `axial` — crosshairs in `#3B82F6`.
- `coronal` — crosshairs in `#F87171`.
- `sagittal` — crosshairs in `#34D399`.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `kind` | `string` | `"axial"` | Drives crosshair color. |
| `title` | `string` | `""` | Header chip label, top-left. |
| `slice` | `int` | `0` | Current slice index. |
| `total` | `int` | `0` | Total slice count; when `0`, the counter and scroll track are hidden. |
| `bottomInfo` | `string` | `"WL 400 · WW 2000"` | Bottom-left voxel / WL-WW caption. |
| `showCrosshairs` | `bool` | `true` | Toggle crosshair lines. |
| `showScrollTrack` | `bool` | `true` | Toggle right-edge slice track. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for on-surface text. |

The default property slot accepts any number of absolute-positioned
`Item` children used as overlays inside the viewport bounds.

## Notes

- Source: `planning-viewer.jsx:32-151` in the DALI design handoff.
- Out of scope: real DICOM rendering. This is chrome only.
