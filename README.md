# pearl-kit

**Pixel-craft PySide6/QML component kit. macOS first.**

[![PyPI](https://img.shields.io/pypi/v/pearl-kit.svg)](https://pypi.org/project/pearl-kit/)
[![Python](https://img.shields.io/pypi/pyversions/pearl-kit.svg)](https://pypi.org/project/pearl-kit/)
[![License](https://img.shields.io/pypi/l/pearl-kit.svg)](https://github.com/omerdduran/pearl-kit/blob/main/LICENSE)
[![CI](https://github.com/omerdduran/pearl-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/omerdduran/pearl-kit/actions/workflows/ci.yml)

> **Status — alpha, infrastructure only.** The design language, QML module, and release pipeline are live. Public components are the next milestone. See [Roadmap](#roadmap).

---

## What it is

`pearl-kit` is a small, opinionated QML component library for PySide6 desktop apps that care how they look on macOS. Instead of fighting Qt's default widget styling — or settling for Material Design — it treats components as a curated kit: a coherent token system, a handful of carefully-built primitives, shadcn-level attention to detail, and zero framework abstractions.

It's not trying to be the next big Python UI framework. It's trying to be the missing layer between `PySide6` and a real-looking 2026 desktop app.

## Why it exists

Python has had the "beautiful desktop app" problem for a decade. PyQt and PySide6 are powerful but default-ugly; the community has largely routed around them with Electron sidecars, webviews, and Flutter bridges. The recurring complaint in every *"Python desktop UI in 2025"* thread is some variant of **"everything looks ten years out of date, and every tailwind-level fix takes 1,000 lines of QSS."**

`pearl-kit` is the answer that assumes:

- You want to stay in Python/QML for real reasons — NumPy, SciPy, PyTorch, domain libraries, or just because your backend is already there.
- You want the app to look like Linear or Raycast, not like a 2012 Qt demo.
- You don't want another framework — you want **pixels you can drop in**.

QML is the right substrate for this. It's GPU-accelerated, declarative, animation-first, and officially native on macOS since Qt 6. `pearl-kit` brings the shadcn/Linear design sensibility on top of it.

## Install

```bash
pip install pearl-kit
```

or with [uv](https://docs.astral.sh/uv/):

```bash
uv add pearl-kit
```

Requirements: Python 3.11+, PySide6 6.8+, macOS or Linux.

## Quick look

Today, `pearl-kit` exposes the `Tokens` singleton — the design language every future component will compose from. You can use it directly in your own QML:

```python
import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit

app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
pearl_kit.register_qml(engine)

engine.loadData(b"""
import QtQuick
import QtQuick.Window
import PearlKit 1.0 as P

Window {
    width: 480; height: 320
    visible: true
    color: P.Tokens.background

    Rectangle {
        anchors.centerIn: parent
        width: 240; height: 56
        color: P.Tokens.primary
        radius: P.Tokens.radius.lg

        Text {
            anchors.centerIn: parent
            text: "Hello, Pearl"
            color: P.Tokens.primaryForeground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.md
            font.weight: P.Tokens.font.weight.semibold
        }
    }
}
""")

app.exec()
```

`register_qml()` adds the bundled QML directory to your engine's import path, so `import PearlKit 1.0` resolves from anywhere.

## The token system

Three themes ship out of the box: `Dark`, `DarkBlue` (default), `Light`. Switch at runtime — every binding re-evaluates automatically:

```qml
P.Tokens.mode = P.Tokens.Light
```

Color tokens follow the **shadcn/ui** naming convention:

```
background   foreground       card         cardForeground
popover      popoverForeground primary      primaryForeground
secondary    secondaryForeground accent     accentForeground
muted        mutedForeground   destructive destructiveForeground
success      warning           border      input        ring
elevation0   elevation1        elevation2  elevation3
```

Scale tokens:

| Category | API | Values |
|---|---|---|
| Radius | `Tokens.radius.{sm,md,lg,xl,full}` | `4, 6, 8, 12, 9999` |
| Spacing | `Tokens.space.x{0..12}` | 4-based scale: `0, 4, 8, 12, 16, 20, 24, 32, 40, 48` |
| Typography | `Tokens.font.size.{xs..xxl}` | `12, 14, 16, 18, 20, 24` |
| Font | `Tokens.font.ui` / `.mono` | `"SF Pro Display"` / `"SF Mono"` |
| Shadow | `Tokens.shadow.{sm,md,lg}{1,2}` | Two-layer shadcn-style |
| Motion | `Tokens.motion.{fast,base,slow}` | `120, 180, 260` ms |

Full reference: **[docs/tokens](https://omerdduran.github.io/pearl-kit/tokens/)**.

## Roadmap

### v0.0.x — current (infrastructure only)

- `Tokens` singleton with three themes
- Internal helper atoms — `PearlBackground`, `PearlText`, `PearlFocusRing`, `PearlPopup`
- `pearl_kit.register_qml()` Python API
- CI matrix: macOS 14 + Ubuntu × Python 3.11 / 3.12 / 3.13
- PyPI trusted publishing, docs site, release pipeline

### v0.1.0 — "the five"

The initial component set, each one built on `QtQuick.Templates` with full visual override:

- **Button** — default / secondary / destructive / ghost / outline / link variants
- **Input** — single-line text with label, hint, and error states
- **Toggle** — on/off switch with transition
- **Select** — dropdown with popover positioning and keyboard navigation
- **Dialog** — modal with overlay, focus trap, and entry/exit transitions

### v0.2.0 and beyond

New primitives as they land: `Card`, `Badge`, `Tooltip`, `Toast`, `Checkbox`, `Radio`, `Slider`, `Tabs`, `Menu`, `Avatar`, `Skeleton`.

The scope is deliberately narrow. This is a component kit, not a framework — no reactivity engine, no router, no state management. Those belong in your app or in Qt Quick itself.

## Philosophy

Three rules:

1. **macOS first, everything else follows.** Tested on retina, SF Pro native, system conventions respected.
2. **Pixels over abstractions.** No magic. Every component is one `.qml` file you can read in under ten minutes.
3. **Boring primitives, uncompromising execution.** You should recognize every component from ten other design systems. What's different is the detail — the shadow layers, the focus rings, the transition curves.

## Development

```bash
git clone https://github.com/omerdduran/pearl-kit
cd pearl-kit
uv sync --all-extras

uv run pytest              # 4/4 smoke tests
uv run ruff check .
uv run pyright              # strict mode
uv run mkdocs serve         # live docs preview
```

Releases are fully automated. Pushing a `v*` tag triggers a GitHub Actions workflow that builds, publishes to PyPI via trusted publishing, and creates a GitHub Release with wheel + sdist + sigstore attestations.

## Links

- **Docs** — <https://omerdduran.github.io/pearl-kit>
- **PyPI** — <https://pypi.org/project/pearl-kit/>
- **Changelog** — [CHANGELOG.md](./CHANGELOG.md)
- **Issues** — <https://github.com/omerdduran/pearl-kit/issues>

## License

[MIT](./LICENSE)
