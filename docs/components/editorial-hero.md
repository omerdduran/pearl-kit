# EditorialHero

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=editorial-hero"
        title="Live EditorialHero demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A full-bleed editorial section header: mono uppercase eyebrow + 56 px serif
headline + wrapped sub-line, plus an optional right-slot for an action
affordance (e.g. a `SegmentedControl` or `Button`). Used as the top of the
Editorial variant of the DALI guide-review report.

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

P.EditorialHero {
    width: 960
    eyebrow: "REPORT · 2041-04 · 17 APRIL 2026"
    headline: "A dual-implant plan for the upper left quadrant."
    subLine: "Yılmaz, Ayşe · 54 · Dr. Kaya, DDS referring · MRN 77481-2025."

    P.SegmentedControl {
        variant: "bordered"
        current: "balanced"
        options: [
            { key: "dense",     label: "DENSE" },
            { key: "balanced",  label: "BALANCED" },
            { key: "editorial", label: "EDITORIAL" }
        ]
    }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `eyebrow` | `string` | `""` | Mono uppercase caption above the headline. |
| `headline` | `string` | `""` | 56 px serif title (wraps within `maxHeadlineWidth`). |
| `subLine` | `string` | `""` | 15 px UI sub-line (wraps within `maxSubLineWidth`). |
| `padTop` | `int` | `40` | Top padding. |
| `padRight` | `int` | `60` | Right padding. |
| `padBottom` | `int` | `32` | Bottom padding. |
| `padLeft` | `int` | `60` | Left padding. |
| `maxHeadlineWidth` | `int` | `720` | Cap on headline width. |
| `maxSubLineWidth` | `int` | `680` | Cap on sub-line width. |
| `background` | `color` | `#FFFFFF` | Section background. |
| `borderColor` | `color` | `#E2E8F0` | 1 px bottom hairline. |

The default property slot is rendered in the top-right corner as an
action affordance.

## Notes

- Source: `report-tab.jsx:480-492` in the DALI design handoff.
- Set `fontFamilySerif` to your project's display serif (DALI uses
  `DM Serif Display`) before you ship — the default system fallback
  does not match the handoff's visual weight.
