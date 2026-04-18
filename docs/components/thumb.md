# Thumb

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=thumb"
        title="Live Thumb demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A CBCT-slice plane-selector thumbnail — gradient fill, crosshairs, and a kind-labeled footer (axial / coronal / sagittal / pano / 3d). Placeholder graphic for plane pickers and case-library tiles that don't have a real render yet.

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

P.Thumb { kind: "axial" }
```

## Plane kinds

```qml
Row {
    spacing: 8
    P.Thumb { kind: "axial";    accent: true }
    P.Thumb { kind: "coronal" }
    P.Thumb { kind: "sagittal" }
    P.Thumb { kind: "pano" }
    P.Thumb { kind: "3d" }
}
```

- `axial`, `coronal`, `sagittal` — orthogonal CBCT planes, each with a matching crosshair orientation.
- `pano` — panoramic strip.
- `3d` — volumetric cue.

Set `accent: true` to outline the active thumbnail in the primary color.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `kind` | `string` | `"axial"` | One of `axial` / `coronal` / `sagittal` / `pano` / `3d`. |
| `accent` | `bool` | `false` | Blue border + slightly stronger gradient. |
| `monoFontFamily` | `string` | `Tokens.font.mono` | Label font. |
