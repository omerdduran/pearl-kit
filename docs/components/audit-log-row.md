# AuditLogRow

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=audit-log-row"
        title="Live AuditLogRow demo"
        loading="lazy"
        width="100%" height="280"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A 3-column audit log row: mono time (80 px) + mono muted date (90 px) +
severity dot + event text. 1 px bottom hairline between rows. Used in
the DALI settings Security section to list the last 5 audit events.

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
    width: 520
    P.AuditLogRow {
        time: "14:32"; date: "Today"
        event: "Signed plan #2041-04 · 5/5 risks acknowledged"
        severity: "ok"
        width: parent.width
    }
    P.AuditLogRow {
        time: "14:18"; date: "Today"
        event: "Applied AI suggestion · implant I2 rotated −2°"
        severity: "info"
        width: parent.width
    }
}
```

## Severities

- `ok` — green `#10B981` dot.
- `info` — blue `#2563EB` dot (default).
- `warn` — amber `#F59E0B` dot.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `time` | `string` | `""` | Mono time stamp in the left column. |
| `date` | `string` | `""` | Mono muted relative date in the middle column. |
| `event` | `string` | `""` | Event description in the right column. |
| `severity` | `string` | `"info"` | `ok` / `info` / `warn`. |
| `showBottomHairline` | `bool` | `true` | Toggle the 1 px bottom separator. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for the event text. |

## Notes

- Source: `settings.jsx:862-870` in the DALI settings handoff.
- Row is non-interactive by default — if you need row-level actions,
  wrap in a `MouseArea` on the consumer side.
