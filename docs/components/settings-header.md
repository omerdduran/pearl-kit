# SettingsHeader

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A page-level section header: mono eyebrow (e.g. `02 · CLINICAL`), a
28 px serif title, and an optional 13 px muted description capped at
640 px. Smaller sibling of the batch-1 `EditorialHero` (56 px headline,
full-bleed).

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

P.SettingsHeader {
    eyebrow: "02 · CLINICAL"
    title: "Clinical preferences"
    description: "Defaults applied to every new case. Individual plans can override any value."
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `eyebrow` | `string` | `""` | Mono uppercase eyebrow; hidden when empty. |
| `title` | `string` | `""` | 28 px serif title. |
| `description` | `string` | `""` | 13 px muted description; hidden when empty. |
| `maxDescriptionWidth` | `int` | `640` | Description wrap cap. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface. |
| `fontFamilySerif` | `string` | `"Times New Roman"` | Serif typeface. |

## Notes

- Source: `settings.jsx:213-227` in the DALI settings handoff.
- Set `fontFamilySerif` to your project's display serif (DALI uses
  DM Serif Display).
