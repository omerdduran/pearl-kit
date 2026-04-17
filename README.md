# pearl-kit

**Pixel-craft PySide6/QML component kit. macOS first.**

[![PyPI](https://img.shields.io/pypi/v/pearl-kit.svg)](https://pypi.org/project/pearl-kit/)
[![Python](https://img.shields.io/pypi/pyversions/pearl-kit.svg)](https://pypi.org/project/pearl-kit/)
[![License](https://img.shields.io/pypi/l/pearl-kit.svg)](https://github.com/omerdduran/pearl-kit/blob/main/LICENSE)
[![CI](https://github.com/omerdduran/pearl-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/omerdduran/pearl-kit/actions/workflows/ci.yml)

A curated set of QML primitives built on `QtQuick.Templates`, sourced from the shadcn/ui design language, with a three-theme token system and no framework abstractions.

---

## What it is

`pearl-kit` is a small, opinionated QML component library for PySide6 desktop apps that care how they look on macOS. Instead of fighting Qt's default widget styling — or settling for Material Design — it treats components as a curated kit: a coherent token system, a handful of carefully-built primitives, shadcn-level attention to detail, and zero framework abstractions.

It's not trying to be the next big Python UI framework. It's trying to be the missing layer between `PySide6` and a real-looking 2026 desktop app.

## Why it exists

Python has had the "beautiful desktop app" problem for a decade. PyQt and PySide6 are powerful but default-ugly; the community has largely routed around them with Electron sidecars, webviews, and Flutter bridges. The recurring complaint in every *"Python desktop UI in 2025"* thread is some variant of **"everything looks ten years out of date, and every Tailwind-level fix takes 1,000 lines of QSS."**

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

A sign-in card with three shipped components — `Button`, `Input`, `Toggle` — and one typography primitive (`Text`):

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
import QtQuick.Layouts
import PearlKit 1.0 as P

Window {
    width: 480; height: 360; visible: true
    color: P.Tokens.background

    ColumnLayout {
        anchors.centerIn: parent
        spacing: P.Tokens.space.x4
        width: 280

        P.Input {
            Layout.fillWidth: true
            placeholderText: "you@domain.com"
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: P.Tokens.space.x2

            P.Toggle { checked: true }
            P.Text {
                text: "Remember me"
                variant: "body"
            }
            Item { Layout.fillWidth: true }
        }

        P.Button {
            Layout.fillWidth: true
            text: "Sign in"
            variant: "default"
        }
    }
}
""")

app.exec()
```

`register_qml()` adds the bundled QML directory to your engine's import path, so `import PearlKit 1.0` resolves from anywhere.

## Components

Eight primitives ship in v0.1.0. Each one is built on `QtQuick.Templates.*` with a full visual override — no reliance on Qt's default widget styling.

| Component | What it does | API surface | Docs |
|---|---|---|---|
| `Button`   | Clickable action | 6 variants × 5 sizes, iconLeft/iconRight, loading, checkable | [→](https://omerdduran.github.io/pearl-kit/components/button/) |
| `Input`    | Single-line text field | error state, iconLeft/iconRight, password mode | [→](https://omerdduran.github.io/pearl-kit/components/input/) |
| `Toggle`   | On/off switch | 2 sizes, animated thumb, keyboard focus ring | [→](https://omerdduran.github.io/pearl-kit/components/toggle/) |
| `Select`   | Non-editable dropdown | 2 sizes, error state, model-driven, grouped items | [→](https://omerdduran.github.io/pearl-kit/components/select/) |
| `Dialog`   | Modal popover | title/description, footer slot, close button, enter/exit transitions | [→](https://omerdduran.github.io/pearl-kit/components/dialog/) |
| `CheckBox` | Multi-select box | error state, indeterminate (tristate) | [→](https://omerdduran.github.io/pearl-kit/components/checkbox/) |
| `Stepper`  | Numeric field with ± buttons | int + float modes, suffix, specialValueText, error state | [→](https://omerdduran.github.io/pearl-kit/components/stepper/) |
| `Text`     | Typography primitive | 7 variants — title, heading, body, muted, label, code, mono | [→](https://omerdduran.github.io/pearl-kit/components/text/) |

Run `python examples/gallery.py` after a `uv sync` to see every variant live.

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
| Motion | `Tokens.motion.{fast,base,slow}` | `150, 180, 260` ms |

Full reference: **[docs/tokens](https://omerdduran.github.io/pearl-kit/tokens/)**.

## Roadmap

### Shipped — v0.1.0

The first component tier, each one built on `QtQuick.Templates` with full visual override:

- **Button** — 6 variants × 5 sizes, icon slots, loading, checkable
- **Input** — single-line field with error state and icon slots
- **Toggle** — iOS-style switch, 2 sizes
- **Select** — non-editable dropdown with grouped items and keyboard navigation
- **Dialog** — modal popover with overlay, focus trap, and fade + zoom transitions
- **CheckBox** — indeterminate-capable, error-aware
- **Stepper** — numeric field with int + float modes and auto-repeat buttons
- **Text** — typography primitive covering title through mono variants

### Next — layout primitives

- `GroupBox` — titled section with optional collapse
- `FormLayout` / `FormRow` — label↔input alignment with hint and error slots
- `ScrollArea` — thin-scrollbar wrapper matching the token set
- `Splitter` — horizontal + vertical split with persistable sizes
- `Card` — elevated surface with radius, border, padding
- `Separator` — thin divider

### Later

Feedback and navigation primitives — `Slider`, `ProgressBar`, `Tooltip`, `Toast`, `Tabs`, `Menu`, `StatusBar`, `ListView`, `Badge`, `Avatar`, `CodeBlock`, `TextArea`, and `Spinner`.

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

uv run pytest              # full suite (55 tests today)
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
