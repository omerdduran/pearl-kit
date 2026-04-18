# DataTable

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=data-table"
        title="Live DataTable demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

A PACS-style dense table for implant specs, metric listings, and any
fixed-schema tabular data. Header is mono uppercase 10 px on a muted
`#FAFBFC` bar; rows are mono 12 px on white with 1 px hairline dividers.
Per-cell color and weight overrides come through conventional extra keys
(`<col>Color`, `<col>Weight`) so severity-driven formatting stays declarative.

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

P.DataTable {
    implicitWidth: 640
    columns: [
        { key: "id",    label: "ID",     mono: true,  width: 48 },
        { key: "tooth", label: "TOOTH",  mono: true,  width: 64 },
        { key: "brand", label: "BRAND",  mono: false },
        { key: "ian",   label: "IAN",    align: "right", width: 64 }
    ]
    rows: [
        { id: "I1", tooth: "#22", brand: "Straumann BLT",
          ian: "3.2", ianColor: "#047857", ianWeight: Font.DemiBold },
        { id: "I2", tooth: "#23", brand: "Straumann BLT",
          ian: "2.1", ianColor: "#B45309", ianWeight: Font.DemiBold }
    ]
}
```

## Column spec

| Field | Type | Description |
|-------|------|-------------|
| `key` | `string` | Row property name used to look up the cell value. |
| `label` | `string` | Header text. |
| `mono` | `bool` | When `false`, the cell uses the UI sans font (for brand strings). Defaults to `true`. |
| `align` | `string` | `"left"` (default), `"center"`, or `"right"`. |
| `width` | `int` | Fixed pixel width; when omitted the column flexes. |

Any extra row keys named `<key>Color` or `<key>Weight` override the default
cell color and font weight.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `columns` | `var` | `[]` | Array of column specs. |
| `rows` | `var` | `[]` | Array of row objects. |
| `headerHeight` | `int` | `30` | Height of the header bar. |
| `rowHeight` | `int` | `32` | Uniform body row height. |
| `borderColor` | `color` | `#E2E8F0` | Outer border color. |
| `headerBg` | `color` | `#FAFBFC` | Header bar background. |
| `rowBorderColor` | `color` | `#F1F5F9` | Bottom hairline on each row. |
| `headerColor` | `color` | `#6B7280` | Header text color. |
| `cellColor` | `color` | `#1A202C` | Default cell text color. |

## Notes

- Source: `report-tab.jsx:295-325` in the DALI design handoff.
- This is a fixed-schema table, not a virtualizing grid. For long lists,
  wrap it in `ScrollArea` or use `ListView` directly.
