# Breadcrumb

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=breadcrumb"
        title="Live Breadcrumb demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A monospace trail of path segments joined by `/`. Past segments are rendered
in a light grey, the penultimate segment in a darker grey, and the current
segment in primary blue with medium weight. Ported from the DALI planning
workspace top-bar.

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

P.Breadcrumb {
    segments: [
        { label: "Library" },
        { label: "2041-04" },
        { label: "Planning", current: true }
    ]
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `segments` | `var` | `[]` | Array of `{ label, current? }`. Last item is auto-treated as current if no segment sets `current: true`. |
| `separatorChar` | `string` | `"/"` | Glyph shown between segments. |
| `fontFamily` | `string` | `Tokens.font.mono` | Label typeface. |
| `fontPixelSize` | `int` | `11` | Uniform size for segments + separators. |
| `letterSpacing` | `real` | `0.04 * fontPixelSize` | Matches the handoff's 0.04em mono spacing. |
| `separatorColor` | `color` | `#D1D5DB` | Separator glyph color. |
| `pastColor` | `color` | `#9CA3AF` | Color for segments earlier than the penultimate. |
| `penultimateColor` | `color` | `#6B7280` | Color for the segment immediately before the current. |
| `currentColor` | `color` | `#2563EB` | Color for the active (last) segment. |

## Notes

- Uses plain `Row` under the hood — no interactivity by design. Wrap individual
  segments in `MouseArea` if you need click navigation.
- Source: `planning-viewer.jsx:216-218` in the DALI design handoff.
