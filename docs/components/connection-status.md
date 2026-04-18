# ConnectionStatus

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

An 8 px glowing status dot + mono bold uppercase state label + mono
muted caption. Used in the DALI settings for DICOM network status
(`ONLINE · last echo 2s ago`). Distinct from `SaveIndicator` (6 px dot,
single muted label) — this component renders a heavier, more prominent
status line.

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

Column {
    spacing: 10
    P.ConnectionStatus {
        state: "online"
        caption: "· last echo 2s ago"
    }
    P.ConnectionStatus { state: "offline"; caption: "· reconnecting" }
    P.ConnectionStatus { state: "error";   caption: "· check DICOM node" }
}
```

## States

- `online` — green dot + `ONLINE` label `#047857`.
- `offline` — grey dot + `OFFLINE` label `#6B7280`.
- `error` — red dot + `ERROR` label `#B91C1C`.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `state` | `string` | `"online"` | `online` / `offline` / `error`. |
| `label` | `string` | `""` | Override the uppercase label (otherwise derived from `state`). |
| `caption` | `string` | `""` | Mono muted caption to the right. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |

## Notes

- Source: `settings.jsx:558-564` in the DALI settings handoff.
- The glow is a 16×16 transparent ring at 50 % alpha — cheaper than a
  real Gaussian blur and visually close to the handoff spec.
