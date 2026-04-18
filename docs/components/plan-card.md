# PlanCard

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A tinted horizontal card for billing / plan display: mono eyebrow +
serif title + vertical divider + mono price (with `/ mo` suffix) +
outline `UPGRADE` chip. Hardcoded `#EFF6FF` / `#BFDBFE` surface and
border.

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

P.PlanCard {
    title: "Solo Clinician"
    price: "€180"
    priceSuffix: "/ mo"
    actionLabel: "UPGRADE"
    onActionRequested: console.log("upgrade flow")
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `eyebrow` | `string` | `"CURRENT"` | Mono uppercase eyebrow above the title. |
| `title` | `string` | `""` | Serif plan name. |
| `price` | `string` | `""` | Mono price text. |
| `priceSuffix` | `string` | `"/ mo"` | Appended after the price. |
| `actionLabel` | `string` | `"UPGRADE"` | Outline chip label. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface. |
| `fontFamilySerif` | `string` | `"Times New Roman"` | Serif typeface for the title. |

## Signals

- `actionRequested()` — emitted when the chip is clicked.

## Notes

- Source: `settings.jsx:676-693` in the DALI settings handoff.
