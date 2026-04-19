# Experimental

!!! warning "Unstable API — expect breakage"
    Everything under this tab is shipped as an **experimental preview**. The
    API, visual design, and set of accepted properties may change in any
    release (including patch versions) without a deprecation period. Pin to
    an exact pearl-kit version if you rely on these components.

This tab collects primitives that were built for the [DALI](https://github.com/omerdduran) clinical-imaging
launch flow — splash screen, case library, volumetric placeholders, CBCT
plane pickers — plus a second batch extracted from the DALI planning
workspace (top-bar breadcrumb, tool palette, CBCT viewport surfaces, plan
rail, risk checklist, approve bar, AI chat panel). They are useful enough
to ship, but have not gone through the same shadcn-parity review as the
stable Components tab.

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
| [Breadcrumb](components/breadcrumb.md) | Mono path trail with per-segment color for past / penultimate / current. |
| [SegmentedControl](components/segmented-control.md) | Pill / bordered / solid grouped picker for mode tabs, variant switches, and compact option grids. |
| [SaveIndicator](components/save-indicator.md) | Colored dot + mono timestamp for autosave / connection status. |
| [PatientStrip](components/patient-strip.md) | Compound: back affordance + Breadcrumb + divider + serif name + mono meta. |
| [StatTile](components/stat-tile.md) | Mono eyebrow + serif numeral + mono subtitle; sm/md/lg sizes, warn/success tones. |
| [DataTable](components/data-table.md) | Dense PACS-style table with per-cell color / weight overrides. |
| [Chip](components/chip.md) | Clickable mono pill — soft (tinted) and outline (ink border) variants. |
| [ToolButton](components/tool-button.md) | 32×32 icon-only palette button with active state and native tooltip. |
| [Viewport2D](components/viewport-2d.md) | CBCT slice surface — crosshairs, header chip, slice counter, scroll track. |
| [OrientationCube](components/orientation-cube.md) | 52×52 R/L/S/I anatomical orientation marker. |
| [DensityBar](components/density-bar.md) | Red→yellow→green→blue gradient bar with a value needle (bone HU, etc). |
| [SafetyRow](components/safety-row.md) | Per-structure safety-distance row with threshold bar and min caption. |
| [SubjectRow](components/subject-row.md) | Selectable list row — colored ID square + title + caption + warn dot. |
| [BipolarSlider](components/bipolar-slider.md) | Symmetric ±range slider with a visible center tick at 0. |
| [ChecklistItem](components/checklist-item.md) | Tap-to-ack row with checkbox, severity label, title, multi-line body. |
| [IconBadge](components/icon-badge.md) | 20×20 gradient / solid tinted square holding a small icon. |
| [AISuggestionCard](components/ai-suggestion-card.md) | Tinted info card with IconBadge + model tag + body + primary button. |
| [PullQuote](components/pull-quote.md) | Editorial pull-quote — large serif " glyph + italic text. |
| [EditorialHero](components/editorial-hero.md) | Full-bleed section header with 56 px serif headline + eyebrow + sub-line. |
| [SectionNumeral](components/section-numeral.md) | Mono uppercase section header with optional roman / arabic prefix. |
| [ChatMessage](components/chat-message.md) | Chat turn with user / ai styling and optional action chip. |
| [ChatComposer](components/chat-composer.md) | Input + mono send button; Enter submits; emits `submitted(text)`. |
| [SubjectCard](components/subject-card.md) | Compound spec card: header + 4-col param grid + tone-colored safety strip. |
| [ApproveBar](components/approve-bar.md) | Footer with checklist progress + outline export + primary approve button. |
| [SettingsRow](components/settings-row.md) | 2-column settings form row with label + hint + control slot + bottom hairline. |
| [SuffixInput](components/suffix-input.md) | Text input with mono right-edge suffix and optional mono input font. |
| [StatusToggle](components/status-toggle.md) | 34×18 toggle with mono uppercase status label (ON/OFF, Enabled/Disabled). |
| [ReadoutSlider](components/readout-slider.md) | One-sided slider with a 72 px mono readout column showing value + unit. |
| [ColorDot](components/color-dot.md) | 22×22 circular color swatch with inner white border + outer ring. |
| [ThemeTile](components/theme-tile.md) | 120 px theme picker tile with serif `Aa` preview + mono label. |
| [StorageBar](components/storage-bar.md) | 3-row disk usage meter (label + %, 6 px bar, muted caption). |
| [ConnectionStatus](components/connection-status.md) | Glowing status dot + bold uppercase label + caption (ONLINE / OFFLINE / ERROR). |
| [SettingsHeader](components/settings-header.md) | Page-level mono eyebrow + 28 px serif title + muted description. |
| [Group](components/group.md) | Mono uppercase sub-section title with 1 px bottom border + content slot. |
| [NumberedNavItem](components/numbered-nav-item.md) | Sidebar nav row: 2-digit mono index + title + subtitle with active tint. |
| [AvatarStack](components/avatar-stack.md) | Overlapping initials avatars with optional `+` add affordance. |
| [PlanCard](components/plan-card.md) | Tinted billing / plan card: eyebrow + serif title + price + outline chip. |
| [SignaturePreview](components/signature-preview.md) | 180×54 cursive signature frame + outline REDRAW button. |
| [AuditLogRow](components/audit-log-row.md) | 3-column audit row: time + date + severity dot + event text. |
| [ProfileHeader](components/profile-header.md) | Compound profile header: gradient avatar + name + title + mono stats strip. |
| [StepCircles](components/step-circles.md) | Horizontal step indicator — 24×24 numbered circles + connectors, 3 label modes (`active` / `all` / `none`). |
| [StepRail](components/step-rail.md) | Vertical step list for the editorial-shell left rail — circle column + label/sub column with active halo. |
| [FeatureBullet](components/feature-bullet.md) | Welcome-step row — 32×32 outlined icon square + medium title + optional description. |
| [SignaturePad](components/signature-pad.md) | Profile-step "Tap to sign" affordance — dashed pad + side `OPEN CANVAS` / `REDRAW` button. |
| [SampleCasePreview](components/sample-case-preview.md) | Dark hero rectangle — gradients + faux volumetric blob + N implant marker bars + mono chips. |
| [FactGrid](components/fact-grid.md) | N-column stat grid — bordered container with 1 px hairlines, mono key + medium value + sub per cell. |
| [SettingsToggleCard](components/settings-toggle-card.md) | Toggle row card — title + badge + description + Toggle, with `highlighted` / `locked` modifiers. |
| [SummaryGrid](components/summary-grid.md) | Grey-surface card — mono eyebrow + N-column key-value grid with per-entry value color overrides. |
| [SampleCaseCard](components/sample-case-card.md) | Composite case card — `SampleCasePreview` hero + meta block + N metric chips. |
| [OnboardingNavFooter](components/onboarding-nav-footer.md) | Footer band — back / counter / skip / secondary outline / primary CTA cluster. |

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
