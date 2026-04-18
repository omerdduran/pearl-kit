# Experimental

!!! warning "Unstable API — expect breakage"
    Everything under this tab is shipped as an **experimental preview**. The
    API, visual design, and set of accepted properties may change in any
    release (including patch versions) without a deprecation period. Pin to
    an exact pearl-kit version if you rely on these components.

This tab collects primitives that were built for the [DALI](https://github.com/omerdduran) clinical-imaging
launch flow — splash screen, case library, volumetric placeholders, CBCT
plane pickers — and extracted into pearl-kit so other apps can reuse them.
They are useful enough to ship, but have not gone through the same shadcn-
parity review as the stable Components tab.

## What's in here

| Component | Purpose |
|-----------|---------|
| [StatusPill](components/status-pill.md) | Tonal status chip (ready / processing / reviewed / neutral). |
| [SectionLabel](components/section-label.md) | Mono-uppercase section header. |
| [MetaRow](components/meta-row.md) | Horizontal label + value row for metadata. |
| [FilterRow](components/filter-row.md) | Sidebar row with label + count pill + active strip. |
| [InfoCard](components/info-card.md) | Tinted info / warning / success / neutral card. |
| [SystemInfoGrid](components/system-info-grid.md) | 4-column label + value footer with optional status dot. |
| [TopMetaStrip](components/top-meta-strip.md) | Hairline header strip with left/right slots. |
| [BrandTile](components/brand-tile.md) | Gradient tile with tooth glyph, brand mark in compact form. |
| [ScannerMark](components/scanner-mark.md) | Animated splash mark — rotating rings + sweep arc + glyph. |
| [Thumb](components/thumb.md) | CBCT-slice plane-picker thumbnail (axial / coronal / sagittal / pano / 3d). |
| [Render3D](components/render-3d.md) | Volumetric-render placeholder with implant + canal cues. |
| [ProgressLine](components/progress-line.md) | 3 px gradient progress strip. |
| [SearchField](components/search-field.md) | Search field with leading glyph and ⌘K hint pill. |

## Why these are experimental

- **Narrow validation**: design values were tuned for DALI's specific screens,
  not stress-tested across a broad set of consumer apps.
- **No shadcn parity**: these have no direct shadcn/ui equivalent, so the
  usual "port the exact values" pass doesn't apply — everything here is a
  pearl-kit original, and the surface is liable to shift as more call sites
  are added.
- **Clinical-imaging flavour**: several components (`Thumb`, `Render3D`,
  `ScannerMark`) carry dental / CBCT cues that may not suit apps outside
  medical imaging. They are kept here for now; if demand from other domains
  emerges we will split them into a neutral-named primitive plus a domain
  wrapper.

## What will change

Expect the following before any of these graduate to the stable Components
tab:

- Property-name alignment with the rest of pearl-kit (color props renamed to
  `Tokens.*` references, font-family overrides consolidated).
- Accessibility passes (focus rings, keyboard activation, ARIA roles).
- Full test coverage (currently most have a smoke-load test only).
- A shadcn-style divergence log in the component's "Under the hood" section.

If you ship against these and a later release breaks your build, open an
issue at [github.com/omerdduran/pearl-kit/issues](https://github.com/omerdduran/pearl-kit/issues)
so we can track the migration needed.
