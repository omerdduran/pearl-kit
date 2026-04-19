# SettingsToggleCard

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=settings-toggle-card"
        title="Live SettingsToggleCard demo"
        loading="lazy"
        width="100%" height="480"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Toggle row card for settings / privacy steps. Title (with optional badge
chip) on top, optional description below, `Toggle` on the right. Two
state modifiers: `highlighted` switches to a blue-tinted border + bg (the
HIPAA-recommended look from the AI step), and `locked` disables the
toggle and fades the card (the cloud-inference-blocked-by-HIPAA look).

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

P.SettingsToggleCard {
    width: 540
    title: "HIPAA / KVKK compliance mode"
    description: "All DICOM data remains on the workstation. Only anonymized summaries leave the device for AI reasoning."
    badgeText: "RECOMMENDED"
    checked: true
    highlighted: true
    onToggled: enabled => prefs.hipaa = enabled
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `string` | `""` | Semibold title line. |
| `description` | `string` | `""` | Wrapped description. Hidden when empty. |
| `badgeText` | `string` | `""` | Optional small chip next to the title. Hidden when empty. |
| `checked` | `bool` | `false` | Toggle state — round-trips with `Toggle.checked`. |
| `highlighted` | `bool` | `false` | Switches to blue-tinted border (`#BFDBFE`) + bg (`#EFF6FF`). |
| `locked` | `bool` | `false` | Disables the toggle and applies 0.5 opacity to the entire card. |
| `badgeFg` / `badgeBg` | `color` | `#047857` / `#D1FAE5` | Badge text + fill. |
| `highlightedBorder` / `highlightedBackground` | `color` | `#BFDBFE` / `#EFF6FF` | Border + bg when `highlighted: true`. |
| `defaultBorder` / `defaultBackground` | `color` | `#E2E8F0` / `#FFFFFF` | Border + bg when `highlighted: false`. |
| `radius` | `int` | `5` | Card corner radius. |
| `hPadding` / `vPadding` | `int` | `18` / `16` | Card padding. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the badge. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for title + description. |

## Signals

- `toggled(bool checked)` — emitted whenever the embedded `Toggle` changes state. The `checked` property auto-updates.

## Notes

- Source: `onboarding.jsx:309-346` in the DALI onboarding handoff.
- Use `locked: true` whenever a parent toggle (e.g. HIPAA compliance) forbids the inner setting; the card still reads, but the `Toggle` rejects clicks.
