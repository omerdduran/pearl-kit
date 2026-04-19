# SampleCaseCard

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=sample-case-card"
        title="Live SampleCaseCard demo"
        loading="lazy"
        width="100%" height="480"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Composite case card for the onboarding Ready step: [`SampleCasePreview`](sample-case-preview.md)
hero on top + a meta block (serif title + caseId, mono meta line, hairline
+ N metric chips) at the bottom. The CTA button (`Open sample case →`)
stays in consumer-land — pair this with [`OnboardingNavFooter`](onboarding-nav-footer.md)
or your own action row.

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

P.SampleCaseCard {
    width: 540
    title: "Demo · Yılmaz, Ayşe"
    caseId: "#0000-00"
    metaText: "MANDIBLE · TOOTH 36/37 · 2 IMPLANTS · STRAUMANN BLT"
    previewTopRightLabel: "142 / 512"
    metrics: [
        { key: "SAFETY",  value: "5 / 5 OK", valueColor: "#047857" },
        { key: "CANAL",   value: "3.2 mm" },
        { key: "AI TOUR", value: "Enabled",  valueColor: "#2563EB" }
    ]
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `string` | `""` | Serif case title (top-left of meta block). |
| `caseId` | `string` | `""` | Mono case identifier (top-right of meta block). Hidden when empty. |
| `metaText` | `string` | `""` | Mono uppercase one-line meta description. Hidden when empty. |
| `metrics` | `var` | `[]` | Array of `{ key, value, valueColor? }` for the bottom chip row. Hairline + row hidden when empty. |
| `previewTopLeftLabel` | `string` | `"SAMPLE · 3D VOLUMETRIC"` | Forwarded to embedded `SampleCasePreview.topLeftLabel`. |
| `previewTopRightLabel` | `string` | `""` | Forwarded to `SampleCasePreview.topRightLabel`. |
| `previewMarkerCount` | `int` | `2` | Forwarded to `SampleCasePreview.markerCount`. |
| `previewHeight` | `int` | `140` | Forwarded to `SampleCasePreview.previewHeight`. |
| `background` | `color` | `#FFFFFF` | Card surface. |
| `borderColor` | `color` | `#E2E8F0` | Card 1 px border. |
| `titleColor` | `color` | `#1A202C` | Title color. |
| `caseIdColor` | `color` | `#9CA3AF` | Case ID color. |
| `metaColor` | `color` | `#6B7280` | Meta line color. |
| `metricKeyColor` / `metricValueColor` | `color` | `#9CA3AF` / `#1A202C` | Default metric chip key / value colors (per-entry `valueColor` wins). |
| `hairlineColor` | `color` | `#F1F5F9` | Separator above the metric row. |
| `radius` | `int` | `6` | Card corner radius. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for caseId, meta line, and metrics. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface (currently unused; reserved for body slot extensions). |
| `fontFamilySerif` | `string` | `"Times New Roman"` | Serif typeface for the title. |

## Notes

- Source: `onboarding.jsx:380-421` in the DALI onboarding handoff.
- For the bare hero rectangle without the meta block see [`SampleCasePreview`](sample-case-preview.md).
- To inject a real CBCT thumbnail, target the embedded preview's `overlayContent` slot — see the SampleCasePreview docs for the pattern.
