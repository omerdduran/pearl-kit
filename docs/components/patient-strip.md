# PatientStrip

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=patient-strip"
        title="Live PatientStrip demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A compound header strip used at the top of a clinical case view: optional
back-affordance + `Breadcrumb` + vertical hairline divider + 2-row name /
meta block. Fixed 48 px tall. Wraps the atoms so consumers can drop it in
without laying out the row manually.

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

P.PatientStrip {
    segments: [
        { label: "Library" },
        { label: "2041-04" },
        { label: "Planning", current: true }
    ]
    name: "Yılmaz, Ayşe"
    meta: "F 54 · #22 Single implant · 17.04.2026"
    onBack: () => console.log("go back")
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `segments` | `var` | `[]` | Forwarded to the inner `Breadcrumb`. |
| `name` | `string` | `""` | Subject name, rendered in serif 16 px. |
| `meta` | `string` | `""` | Mono 10 px caption under the name. |
| `showBackButton` | `bool` | `true` | Toggle the back affordance. |
| `backIconSource` | `url` | `""` | Optional icon URL; when empty, falls back to a `←` glyph. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |
| `fontFamilySerif` | `string` | `"Times New Roman"` | Serif typeface for the name — consumers should set this to the project's display serif (DALI uses DM Serif Display). |
| `dividerColor` | `color` | `#E2E8F0` | Vertical separator color. |
| `nameColor` | `color` | `#1A202C` | Subject name color. |
| `metaColor` | `color` | `#9CA3AF` | Meta caption color. |

## Signals

- `back()` — emitted when the back affordance is clicked.

## Notes

- Source: `planning-viewer.jsx:210-228` in the DALI design handoff.
- The `back()` signal is wiring-only — consumers wire the pop-navigation.
