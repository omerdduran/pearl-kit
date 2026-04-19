# OnboardingNavFooter

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=onboarding-nav-footer"
        title="Live OnboardingNavFooter demo"
        loading="lazy"
        width="100%" height="360"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Onboarding footer band: ghost back (left) + mono `STEP X / Y` counter
(center) + skip + optional secondary outline + primary accent (right).
Every label, signal, and enabled flag is exposed as a property so
consumers can drive intermediate, skippable, and final steps from the
same component.

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

// intermediate skippable step
P.OnboardingNavFooter {
    width: 640
    currentStep: 3
    totalSteps: 5
    canSkip: true
    onBack:    wizard.previous()
    onSkip:    wizard.next()
    onPrimary: wizard.next()
}

// final step with two CTAs
P.OnboardingNavFooter {
    width: 640
    currentStep: 5
    totalSteps: 5
    secondaryText: "GO TO LIBRARY"
    primaryText: "Open sample case →"
    onSecondary: app.openLibrary()
    onPrimary:   app.openSampleCase()
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `backEnabled` | `bool` | `true` | Disables the back button (greyed out, no signal) when false. |
| `backText` | `string` | `"← BACK"` | Back button label. Mono uppercase. |
| `currentStep` | `int` | `1` | Used in the centre counter (`STEP X / Y`). |
| `totalSteps` | `int` | `5` | Used in the centre counter. |
| `counterTemplate` | `string` | `"STEP %1 / %2"` | Counter format string. `%1` → `currentStep`, `%2` → `totalSteps`. |
| `canSkip` | `bool` | `false` | Shows the `SKIP` ghost button before the primary CTA. |
| `skipText` | `string` | `"SKIP"` | Skip button label. |
| `secondaryText` | `string` | `""` | When non-empty, renders an outline secondary button to the left of the primary (used for `GO TO LIBRARY` on the final step). |
| `primaryText` | `string` | `"Continue →"` | Primary CTA label. |
| `primaryEnabled` | `bool` | `true` | Disables the primary CTA (greyed, forbidden cursor). |
| `primaryColor` | `color` | `#2563EB` | Primary CTA fill. Darkens on hover. |
| `background` | `color` | `#FFFFFF` | Footer surface. |
| `borderColor` | `color` | `#E2E8F0` | Top 1 px hairline. |
| `counterColor` | `color` | `#9CA3AF` | Centre counter color. |
| `ghostColor` / `ghostDisabled` | `color` | `#4A5568` / `#CBD5E1` | Back button text colors. |
| `secondaryTextColor` | `color` | `#1A202C` | Secondary outline button label color. |
| `hPadding` / `vPadding` | `int` | `28` / `16` | Padding. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for back / counter / skip / secondary. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for the primary CTA label. |

## Signals

- `back()` — emitted when the back button is clicked (only when `backEnabled`).
- `skip()` — emitted when the skip button is clicked (only when `canSkip`).
- `primary()` — emitted when the primary CTA is clicked (only when `primaryEnabled`).
- `secondary()` — emitted when the secondary outline button is clicked (only when `secondaryText !== ""`).

## Notes

- Source: `onboarding.jsx:506-554` in the DALI onboarding handoff.
- `canSkip`, `secondaryText`, and `backEnabled` are independent — combine freely for any step shape.
- For the per-step indicator that lives at the top of the same card see [`StepCircles`](step-circles.md) (compact) or [`StepRail`](step-rail.md) (editorial).
