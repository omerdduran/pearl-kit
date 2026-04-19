# FeatureBullet

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=feature-bullet"
        title="Live FeatureBullet demo"
        loading="lazy"
        width="100%" height="360"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Welcome-step list row: 32×32 outlined icon square + medium title + optional
secondary description. Static read-only display atom — every color and size
is exposed as a property.

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

P.FeatureBullet {
    iconSource: "qrc:/icons/segmentation.svg"
    title: "AI segmentation"
    description: "Bones, nerves, sinuses auto-detected from CBCT volumes."
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `iconSource` | `url` | `""` | SVG / image inside the icon square. Empty string hides the inner `Image`. |
| `title` | `string` | `""` | Medium ink title line. |
| `description` | `string` | `""` | Optional secondary line. Hidden when empty. |
| `iconSize` | `int` | `32` | Icon square edge length. The inner image is sized to `iconSize - 12`. |
| `iconRadius` | `int` | `6` | Corner radius of the icon square. |
| `columnGap` | `int` | `12` | Gap between icon square and text column. |
| `iconBackground` | `color` | `#FFFFFF` | Icon square fill. |
| `iconBorder` | `color` | `#E2E8F0` | Icon square 1 px border. |
| `titleColor` | `color` | `#1A202C` | Title color. |
| `descriptionColor` | `color` | `#6B7280` | Description color. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for both texts. |

## Signals

None — this is a static display atom.

## Notes

- Source: README.md "Primitives" section in the DALI onboarding handoff.
- Stack three or four of these in a `ColumnLayout` for the welcome-step feature list.
