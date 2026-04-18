# Separator

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=separator"
        title="Live Separator demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/separator)'s Separator. A thin 1 px divider that visually (and optionally semantically) splits content into groups.

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

Inside your QML:

```qml
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0 as P

ColumnLayout {
    P.PearlText { variant: "heading"; text: "Account" }
    P.Separator { Layout.fillWidth: true }
    P.PearlText { variant: "body"; text: "Email, password, and billing." }
}
```

## Basic usage

```qml
P.Separator { Layout.fillWidth: true }
```

Separator has no default width or height. Its `implicitHeight` is `1` when horizontal and its `implicitWidth` is `1` when vertical — the other dimension is left at `0` so it participates naturally in Qt layouts:

- Inside a `ColumnLayout` or `RowLayout`, use `Layout.fillWidth: true` (horizontal) or `Layout.fillHeight: true` (vertical).
- Inside an `Item` or a manual layout, anchor it (`anchors.left`, `anchors.right`) or set `width` / `height` explicitly.

## Orientation

```qml
// Horizontal (default) — splits rows in a Column
P.Separator { Layout.fillWidth: true }

// Vertical — splits cells in a Row
P.Separator {
    orientation: "vertical"
    Layout.fillHeight: true
}
```

Switching `orientation` swaps which dimension holds the 1 px thickness:

| `orientation` | `implicitWidth` | `implicitHeight` |
|---|---|---|
| `"horizontal"` (default) | `0` | `1` |
| `"vertical"` | `1` | `0` |

## Example: vertical dividers in a toolbar

```qml
RowLayout {
    spacing: 12
    P.PearlText { text: "File" }
    P.Separator { orientation: "vertical"; Layout.fillHeight: true }
    P.PearlText { text: "Edit" }
    P.Separator { orientation: "vertical"; Layout.fillHeight: true }
    P.PearlText { text: "View" }
}
```

## Example: explicit width

```qml
P.Separator { width: 240 }
```

When you don't have a layout, give the separator an explicit `width` (horizontal) or `height` (vertical).

## Accessibility

Separator exposes a `decorative` boolean:

- `decorative: true` (default) — the separator is treated as a purely visual element (`Accessible.NoRole`). Assistive technology skips it.
- `decorative: false` — the separator is announced as a semantic divider (`Accessible.Separator`). Use when the divide is meaningful to the content structure, not just a visual flourish.

```qml
// Purely visual — default
P.Separator { Layout.fillWidth: true }

// Semantic — "separator" announced by screen readers
P.Separator {
    Layout.fillWidth: true
    decorative: false
}
```

This mirrors Radix UI's `decorative` prop, which shadcn forwards verbatim.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `orientation` | `string` | `"horizontal"` | Either `"horizontal"` or `"vertical"`. Swaps the 1 px axis. |
| `decorative` | `bool` | `true` | When `false`, `Accessible.role` becomes `Separator` so screen readers announce it. |
| `color` | `color` | `Tokens.border` | Inherited from `Rectangle`. Override if you need a non-default shade. |

## Under the hood

Separator is a plain `Rectangle` — there is no `QtQuick.Templates.*` base. Separators have no interactive state (no hover, no focus, no disabled), so the Templates layer would add nothing.

The color resolves through `Tokens.border`, which means theme switches (`Tokens.mode = Tokens.Light`) propagate automatically to every Separator instance without any per-component wiring. If you need a stronger or softer divider, override `color` directly at the call site.

## Deliberate divergences from shadcn

- shadcn uses Tailwind's `w-full` / `h-full` on the horizontal / vertical axis respectively. QML does not have an automatic "fill parent" primitive on bare `Rectangle`, so pearl-kit leaves the non-thickness axis at `implicitWidth: 0` / `implicitHeight: 0` and expects the consumer to set it via `Layout.fillWidth` / `Layout.fillHeight`, anchors, or an explicit dimension. This is the standard Qt pattern for container-aware sizing.
