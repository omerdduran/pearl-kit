# Changelog

All notable changes to this project will be documented in this file.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [SemVer](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `PearlKit.Button` — first public component. Six variants (`default`, `destructive`, `outline`, `secondary`, `ghost`, `link`) x five sizes (`default`, `xs`, `sm`, `lg`, `icon`) with `iconLeft` / `iconRight` URL slots. Built on `QtQuick.Templates.Button` with state-reactive background and foreground color transitions, keyboard-only focus ring (3px, 50% ring-color alpha, no offset), and shadcn/ui v4 visual parity.
- `PearlKit.Input` — second public component. Single 36 px size (shadcn parity — Input has no size variants), `property bool error` for invalid-state visuals (border + ring switch to destructive), `iconLeft` / `iconRight` URL slots (pearl-kit extension over shadcn for Button consistency), theme-aware background (transparent in light mode, `Tokens.input` at 30% alpha in dark modes). Built on `QtQuick.Templates.TextField` with the default `TextInput` contentItem preserved for native caret, IME, selection, and undo/redo support. Focus ring appears on any focus source (mouse or keyboard) rather than `visualFocus`-only as Button — text inputs need caret feedback on click too.
- `PearlKit.Toggle` — third public component. iOS-style switch with two sizes (`sm`, `default`) matching shadcn/ui v4 Switch geometry (24×14 and 32×18 px tracks, 12 and 16 px thumbs). Built on `QtQuick.Templates.Switch` with a custom `indicator` slot (rounded-full track + animated thumb). Keyboard-only focus ring (3 px @ `ring/50`, offset 0) targets `control.indicator` so the ring follows the rounded-full track radius instead of the default rectangular fallback. Thumb position animated via `Behavior on x` (NumberAnimation) and color via `Behavior on color` (ColorAnimation), both at `Tokens.motion.fast` with `Easing.OutCubic`. Named `Toggle` rather than shadcn's `Switch` for pearl-kit roadmap and DALI migration consistency. Thumb color uses a uniform `foreground` / `primaryForeground` formula across all themes instead of a `Tokens.isLight`-branched approach — deliberately higher-contrast in Light mode than shadcn. Track unchecked background uses full-alpha `Tokens.input` across all modes (shadcn uses `dark:/80`). No `shadow-xs` (skipped by design, negligible on a control this small).
- `PearlKit.Select` — fourth public component. Non-editable dropdown with two sizes (`sm`, `default`), `property bool error` for invalid-state visuals, model-driven API (supports string arrays, ListModel, and JS object models via `textRole` / `valueRole`), popper-positioned popup with fade + scale enter transition (`Tokens.motion.fast`), and `type`-role grouped models (`"item"` / `"header"` / `"separator"`) as a unified replacement for shadcn's `SelectLabel` + `SelectSeparator` + `SelectGroup` primitives. Built on `QtQuick.Templates.ComboBox` with every slot overridden: `background` (Input-style rectangle), `contentItem` (PearlText with placeholder handling), `indicator` (new `PearlChevron` internal atom), `popup` (inline `T.Popup` parented to `T.Overlay.overlay`), and `delegate` (`T.ItemDelegate` branching on the row type). Commits to header or separator rows are guarded by an `onActivated` interceptor that reverts to the last valid selection. Keyboard navigation (Up / Down / Home / End / Space / Return / Escape / type-ahead) is handled natively by `T.ComboBox`; note that Qt's built-in nav does not skip non-selectable rows, so the keyboard highlight passes through headers and separators — the commit guard handles this cleanly. Deliberate divergences from shadcn: popper-only positioning (no item-aligned), static 320 px popup max height, no ScrollUp / ScrollDown chevron buttons (native `ScrollIndicator` used instead), minimal filled-dot current-row indicator instead of a check glyph, no `shadow-md` on the popup.
- `PearlKit.internal.PearlChevron` — Canvas-based stroked chevron atom with `strokeColor`, `strokeWidth`, and `direction` (`"down"` / `"up"`) properties. Avoids adding a new Qt.labs dependency for Select's indicator. Re-usable for future components that need a chevron glyph.
- `PearlFocusRing` parameterized: new `ringWidth` (default 2) and `ringColor` (default `Tokens.ring`) properties for per-component ring customization. Backward-compatible with existing defaults.

### Changed

- `Tokens.motion.fast` updated from 120ms to 150ms to match the shadcn / Tailwind transition duration default so future components stay consistent.

### v0.0.0 — Initial infrastructure

- Initial project scaffolding (uv + hatchling + hatch-vcs).
- `Tokens` QML singleton with shadcn taxonomy and airontgen-derived palette (Dark / DarkBlue / Light).
- `PearlKit.internal` helper atoms: `PearlBackground`, `PearlText`, `PearlFocusRing`, `PearlPopup`.
- `pearl_kit.register_qml(engine)` Python API for QML module discovery.
- CI, release, and docs GitHub Actions workflows.
- mkdocs-material documentation skeleton.
