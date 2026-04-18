# MetaRow

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=meta-row"
        title="Live MetaRow demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A horizontal label + value row — the go-to primitive for key/value metadata in case detail panels, sidebar summaries, and footer strips. Label is mono-uppercase muted; value can toggle between mono and sans.

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

P.MetaRow {
    label: "MODEL"
    value: "MacBook Pro"
    valueMono: false
}
```

## Mono vs sans values

```qml
Column {
    spacing: 4
    P.MetaRow { label: "CASE";    value: "A-0042";      valueMono: true  }
    P.MetaRow { label: "PATIENT"; value: "Jane Foster"; valueMono: false }
    P.MetaRow { label: "HU";      value: "248";         valueMono: true  }
}
```

Use `valueMono: true` for IDs, numbers, codes; `valueMono: false` for names and prose.

## Eliding long values

By default `elideMode` is `Text.ElideNone`, so values extend to their natural width and a long string can overflow a fixed-width parent. Set `elideMode` to `Text.ElideRight` or `Text.ElideMiddle` for values whose total length is unbounded (file paths, procedure names) — the value `Text` is anchored between the label and the right edge, so it truncates inside the row instead of pushing past it. Pair with a hover tooltip if the full value is still relevant:

```qml
P.MetaRow {
    id: pathRow
    width: 320
    label: "PATH"
    value: "/Volumes/archive/2026/.../case-0042/DICOM/IMG001.dcm"
    elideMode: Text.ElideMiddle

    ToolTip.visible: hover.containsMouse
    ToolTip.text: pathRow.value
    ToolTip.delay: 600

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton   // don't steal clicks from parent
    }
}
```

`valueGap` (default `12`) controls the horizontal breathing room between the label and the value — raise it if a dense row feels cramped, lower it if a narrow row needs every pixel.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `string` | `""` | Left label, rendered mono-uppercase muted. |
| `value` | `string` | `""` | Right value. |
| `valueMono` | `bool` | `true` | `true` → mono font, `false` → sans. |
| `elideMode` | `int` | `Text.ElideNone` | How the value `Text` truncates when it doesn't fit. `Text.ElideRight` / `Text.ElideMiddle` are the useful values for paths and long names. |
| `valueGap` | `int` | `12` | Horizontal gap (px) between the label's right edge and the value. |
| `labelColor` | `color` | `#8A93A0` | Override the label color. |
| `valueColor` | `color` | `#1A202C` | Override the value color. |
| `monoFontFamily` | `string` | `Tokens.font.mono` | Mono font override. |
| `sansFontFamily` | `string` | `Tokens.font.ui` | Sans font override. |
