# StepCircles

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=step-circles"
        title="Live StepCircles demo"
        loading="lazy"
        width="100%" height="320"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Horizontal step indicator: 24×24 numbered circles with hairline connectors
between them. Done steps render a check, the active step gets the accent
border + accent number, upcoming steps stay neutral. Used in the compact
onboarding-card header.

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

P.StepCircles {
    currentIndex: 1
    labelMode: "active"
    model: [
        { n: "01", label: "Welcome",   sub: "Get started" },
        { n: "02", label: "Profile",   sub: "Who you are" },
        { n: "03", label: "Clinical",  sub: "Your defaults" },
        { n: "04", label: "AI & data", sub: "Privacy" },
        { n: "05", label: "Ready",     sub: "Sample case" }
    ]
    onStepClicked: index => console.log("jump to", index)
}
```

## Label modes

- `"active"` (default) — only the current step shows its label inline; matches the compact onboarding header.
- `"all"` — every step's label and `sub` render under the connector. Use in wider headers when room permits.
- `"none"` — circles only, no labels. Use as a slim progress dot strip.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `model` | `var` | `[]` | Array of `{ n, label, sub }` per step. `n` is the index glyph (string), `label` and `sub` only render when `labelMode` shows them. |
| `currentIndex` | `int` | `0` | Active step. Steps with `index < currentIndex` are marked done; steps with `index > currentIndex` are upcoming and not clickable. |
| `labelMode` | `string` | `"active"` | One of `"active"`, `"all"`, `"none"`. |
| `accentColor` | `color` | `#2563EB` | Active circle border, done circle fill, connector fill before the active step. |
| `circleSize` | `int` | `24` | Diameter of each step circle. |
| `interSpacing` | `int` | `12` | Horizontal margin between circle and connector. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the step number. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for the inline label. |

## Signals

- `stepClicked(int index)` — emitted only for steps the user can reach (`index <= currentIndex`).
  Wire to your wizard router.

## Notes

- Source: `onboarding.jsx:451-503` in the DALI onboarding handoff.
- Pair with [`OnboardingNavFooter`](onboarding-nav-footer.md) at the bottom of the same card.
- For the editorial-shell vertical equivalent see [`StepRail`](step-rail.md).
