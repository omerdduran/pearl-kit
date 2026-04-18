# Button

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=button"
        title="Live Button demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/button)'s Button — six variants, five sizes, optional icon slots, full keyboard accessibility.

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
import PearlKit 1.0 as P

P.Button {
    text: "Save changes"
    onClicked: console.log("clicked")
}
```

## Variants

Six variants, same API surface as shadcn/ui:

| Variant | Use case | Background | Foreground |
|---|---|---|---|
| `default` | Primary action on a page | `Tokens.primary` | `Tokens.primaryForeground` |
| `destructive` | Irreversible action (delete, leave, cancel subscription) | `Tokens.destructive` | `Tokens.destructiveForeground` |
| `outline` | Secondary action, lower visual weight | Transparent, 1px border | `Tokens.foreground` |
| `secondary` | Supporting action next to a primary | `Tokens.secondary` | `Tokens.secondaryForeground` |
| `ghost` | Subtle action inside a toolbar or menu | Transparent | `Tokens.foreground` |
| `link` | Inline text-style action | Transparent, underline on hover | `Tokens.primary` |

```qml
Row {
    spacing: 12
    P.Button { text: "Default";     variant: "default" }
    P.Button { text: "Destructive"; variant: "destructive" }
    P.Button { text: "Outline";     variant: "outline" }
    P.Button { text: "Secondary";   variant: "secondary" }
    P.Button { text: "Ghost";       variant: "ghost" }
    P.Button { text: "Link";        variant: "link" }
}
```

On hover, each variant transitions its background to a 10–20% lightened shade over 150ms with an `OutCubic` easing curve — the same motion profile as shadcn's `transition-all duration-150`.

## Sizes

Five sizes, controlling height and horizontal padding. Font size and weight stay constant at 14px / medium across every size, matching shadcn's `text-sm font-medium` base class.

| Size | Height | Horizontal padding | Use case |
|---|---|---|---|
| `xs` | 24 | 8 (6 with icon) | Dense tables, inline row actions |
| `sm` | 32 | 12 (10 with icon) | Compact forms, sidebars |
| `default` | 36 | 16 (12 with icon) | General use |
| `lg` | 40 | 24 (16 with icon) | Marketing, hero CTAs |
| `icon` | 36 × 36 | — | Icon-only square button |

```qml
Row {
    spacing: 12
    P.Button { text: "xs";      size: "xs" }
    P.Button { text: "sm";      size: "sm" }
    P.Button { text: "Default"; size: "default" }
    P.Button { text: "lg";      size: "lg" }
    P.Button { iconLeft: "qrc:/icons/plus.svg"; size: "icon" }
}
```

When `iconLeft` or `iconRight` is set, horizontal padding automatically shrinks by 4px to balance the extra visual weight — this matches shadcn's `has-[>svg]` Tailwind modifier.

## Icons

```qml
P.Button {
    text: "Save"
    iconLeft: "qrc:/icons/save.svg"
}

P.Button {
    text: "Next"
    iconRight: "qrc:/icons/arrow-right.svg"
}

P.Button {
    size: "icon"
    iconLeft: "qrc:/icons/trash.svg"
    variant: "destructive"
}
```

Icons render at **16×16 logical pixels** via `Image.PreserveAspectFit` with `sourceSize: Qt.size(16, 16)` for crisp SVG rasterization. Any image format QML's `Image` element supports (PNG, JPG, SVG, WebP) works — SVG requires the `QtSvg` plugin, which ships with the PySide6 wheel.

The gap between icon and text follows the size scale: `xs` → 4px, `sm` → 6px, everything else → 8px.

## States

| State | Trigger | Visual |
|---|---|---|
| Hover | Pointer over button | Background transitions to a 10–20% lighter shade over 150ms |
| Pressed | Mouse down or keyboard Space/Return | Same as hover (shadcn does not distinguish `:active`) |
| Focus (keyboard) | Tab navigation lands on button | 3px focus ring at `Tokens.ring` @ 50% alpha, no offset |
| Focus (pointer) | Click | **No ring** — matches shadcn's `focus-visible:` behavior |
| Disabled | `enabled: false` | Background + content at 50% opacity, all interaction suppressed |

```qml
P.Button { text: "Disabled"; enabled: false }
```

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `text` | `string` | `""` | Button label. Hidden when empty. |
| `variant` | `string` | `"default"` | One of `default`, `destructive`, `outline`, `secondary`, `ghost`, `link`. |
| `size` | `string` | `"default"` | One of `default`, `xs`, `sm`, `lg`, `icon`. |
| `iconLeft` | `url` | `""` | Optional icon rendered before the text. Empty URL hides the slot. |
| `iconRight` | `url` | `""` | Optional icon rendered after the text. |
| `enabled` | `bool` | `true` | Inherited from `T.Button`. Toggles the disabled visual + interaction state. |

### Inherited signals from `T.Button`

| Signal | When |
|---|---|
| `clicked()` | Released after a click or keyboard Space/Return |
| `pressed()` | Pointer down or keyboard activate |
| `released()` | Pointer up |
| `doubleClicked()` | Two clicks within the double-click interval |

## Accessibility

- **Keyboard activation** — `Space` and `Return` fire `clicked()` via `T.Button`'s base implementation. Do not write your own `Keys.onPressed` handlers; they will cause duplicate signals.
- **Focus chain** — Buttons participate in the Tab focus chain by default (`focusPolicy: Qt.StrongFocus`). The focus ring appears **only** on keyboard-initiated focus, matching the `focus-visible:` semantics of shadcn/ui.
- **Disabled state** — `enabled: false` suppresses both pointer and keyboard interaction and skips the button in the focus chain.

## Under the hood

Button is a `QtQuick.Templates.Button` (not `QtQuick.Controls.Basic.Button`). `QtQuick.Templates` provides the headless behavior primitives — keyboard activation, hover/pressed state tracking, focus chain integration — while all visual rendering is pearl-kit's own. This is the same pattern used by every serious QML component library (Material, FluentUI-QML, Kirigami).

Internally Button composes three helper atoms from `PearlKit.internal`:

- `PearlBaseText` for the label (14px / medium / `SF Pro Display`)
- `PearlFocusRing` for the keyboard focus indicator
- A bare `Rectangle` for the background (variant-specific color + border logic lives inline rather than in a generic `PearlBackground` helper)

Every color, radius, spacing, and motion value resolves through `Tokens.*`, so theme changes (`Tokens.mode = Tokens.Light`) propagate automatically.
