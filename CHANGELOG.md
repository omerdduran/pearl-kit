# Changelog

All notable changes to this project will be documented in this file.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [SemVer](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `PearlKit.Button` — first public component. Six variants (`default`, `destructive`, `outline`, `secondary`, `ghost`, `link`) x five sizes (`default`, `xs`, `sm`, `lg`, `icon`) with `iconLeft` / `iconRight` URL slots. Built on `QtQuick.Templates.Button` with state-reactive background and foreground color transitions, keyboard-only focus ring (3px, 50% ring-color alpha, no offset), and shadcn/ui v4 visual parity.
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
