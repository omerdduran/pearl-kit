# SampleCasePreview

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=sample-case-preview"
        title="Live SampleCasePreview demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Ready-step 140 px dark hero rectangle: layered radial-style gradients + a
faux volumetric blob + N implant-marker bars + mono chips top-left and
top-right. Stand-alone decorative atom; embed inside [`SampleCaseCard`](sample-case-card.md)
for the full case-summary card.

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

P.SampleCasePreview {
    width: 540
    topLeftLabel: "DEMO · MAXILLA"
    topRightLabel: "142 / 512"
    markerCount: 3
    previewHeight: 180
}
```

## Replacing the decoration with a real thumbnail

```qml
P.SampleCasePreview {
    width: 540
    Image {
        anchors.fill: parent
        source: "qrc:/thumbs/case-0000.png"
        fillMode: Image.PreserveAspectCrop
    }
}
```

The `default property alias overlayContent` accepts arbitrary children
(here an `Image`) that render above the synthetic decoration but beneath
the chip text overlays.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `topLeftLabel` | `string` | `"SAMPLE · 3D VOLUMETRIC"` | Top-left mono chip text. Hidden when empty. |
| `topRightLabel` | `string` | `""` | Top-right mono chip (slice counter, etc). Hidden when empty. |
| `markerCount` | `int` | `2` | Number of vertical implant marker bars. Distributed evenly. Set to `0` to hide. |
| `previewHeight` | `int` | `140` | Hero rectangle height. |
| `background` | `color` | `#0B1120` | Base dark surface. |
| `topLeftColor` | `color` | `#93C5FD` | Top-left chip text color. |
| `topRightColor` | `color` | `#6B7280` | Top-right chip text color. |
| `markerLow` / `markerHigh` | `color` | `#60A5FA` / `#2563EB` | Marker bar gradient stops + halo tint. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the chip text. |

## Notes

- Source: `onboarding.jsx:380-404` in the DALI onboarding handoff.
- Marker bars are evenly distributed around the horizontal centre with a
  fixed 12 % spacing factor; tweak the QML directly if you need a custom layout.
- The radial-style gradients are layered `Rectangle` + `Gradient` (vertical)
  approximations — Qt's true `RadialGradient` lives in `QtQuick.Effects` and
  would force a heavier dependency.
