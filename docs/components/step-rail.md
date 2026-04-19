# StepRail

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=step-rail"
        title="Live StepRail demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Vertical step list for the editorial-shell left rail. Each row is a 28 px
circle column + label / sub column with a 1 px hairline between rows; the
active row gets a soft accent halo around its circle.

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

P.StepRail {
    width: 280
    currentIndex: 2
    model: [
        { n: "01", label: "Welcome",   sub: "Get started"   },
        { n: "02", label: "Profile",   sub: "Who you are"   },
        { n: "03", label: "Clinical",  sub: "Your defaults" },
        { n: "04", label: "AI & data", sub: "Privacy"       },
        { n: "05", label: "Ready",     sub: "Sample case"   }
    ]
    onStepClicked: index => console.log("jump to", index)
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `model` | `var` | `[]` | Array of `{ n, label, sub }` per step. |
| `currentIndex` | `int` | `0` | Active step. Done steps render a check; upcoming steps are non-clickable. |
| `accentColor` | `color` | `#2563EB` | Active row border + halo + sub-label color, done row fill. |
| `hairline` | `color` | `#ECEEF2` | 1 px separator between rows. |
| `circleSize` | `int` | `24` | Diameter of each row's index circle. |
| `rowVerticalPadding` | `int` | `13` | Vertical padding inside each row. |
| `leftIndentColumn` | `int` | `28` | Width of the circle column. |
| `columnGap` | `int` | `12` | Gap between circle and label columns. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the step number + sub. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for the row label. |

## Signals

- `stepClicked(int index)` — emitted only for steps the user can reach (`index <= currentIndex`).

## Notes

- Source: `onboarding.jsx:651-693` in the DALI onboarding handoff.
- For the compact-shell horizontal equivalent see [`StepCircles`](step-circles.md).
- Default `implicitWidth` is `280`. Override with `Layout.preferredWidth` or `width` when nesting in a left-rail container.
