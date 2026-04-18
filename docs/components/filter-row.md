# FilterRow

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=filter-row"
        title="Live FilterRow demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A selectable sidebar row with a label, a trailing count pill, and a 2 px left strip that fills in on the active row. Built on `T.AbstractButton` — hover + click + keyboard activation all come from the base template.

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
import QtQuick.Layouts
import PearlKit 1.0 as P

ColumnLayout {
    spacing: 4
    P.FilterRow { label: "All cases";    count: 42; active: true  }
    P.FilterRow { label: "Flagged";      count: 3;  active: false }
    P.FilterRow { label: "Archive";      count: 128 }
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `string` | `""` | Row text. |
| `count` | `int` | `0` | Trailing pill count. |
| `active` | `bool` | `false` | Highlights the row and fills the strip. |
| `stripColor` | `color` | `#2563EB` | Active-strip color. |
| `monoFontFamily` | `string` | `Tokens.font.mono` | Label font override. |
| `sansFontFamily` | `string` | `Tokens.font.ui` | Count pill font override. |

## Signals

| Signal | Description |
|--------|-------------|
| `clicked()` | Emitted on left-click / Space / Return (inherited from `T.AbstractButton`). |
