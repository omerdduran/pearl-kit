# Badge

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=badge"
        title="Live Badge demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/badge)'s Badge. A small pill-shaped label used for status callouts, counts, tags, and metadata chips. Non-interactive by design — a drop-in replacement for inline status text.

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

Inside QML:

```qml
import QtQuick
import PearlKit 1.0

Badge { text: "New" }
```

## Basic usage

```qml
Badge { text: "Beta"; variant: "outline" }
```

Badges size to their content — `implicitWidth` and `implicitHeight` are computed from the text plus padding (`px-2 py-0.5` in shadcn, floored at 20 px height to match shadcn's rendered output on macOS). Place Badge inside any layout (`Row`, `Flow`, `RowLayout`) or anchor it manually. No `Layout.fillWidth` is required — a stretched badge defeats the pill aesthetic.

## Variants

| Variant | Background | Foreground | Border | Use case |
|---|---|---|---|---|
| `default` | `Tokens.primary` | `Tokens.primaryForeground` | transparent | Primary status / highlight chip |
| `secondary` | `Tokens.secondary` | `Tokens.secondaryForeground` | transparent | Version tag, category label |
| `destructive` | `Tokens.destructive` | white | transparent | Error / failure state |
| `outline` | transparent | `Tokens.foreground` | `Tokens.border` | Neutral / subtle tag |
| `ghost` | transparent | `Tokens.foreground` | transparent | Barely-there status (streaming, typing…) |
| `link` | transparent | `Tokens.primary` (underlined) | transparent | Link-styled callout |

```qml
Flow {
    spacing: 8
    Badge { text: "Default";     variant: "default" }
    Badge { text: "Secondary";   variant: "secondary" }
    Badge { text: "Destructive"; variant: "destructive" }
    Badge { text: "Outline";     variant: "outline" }
    Badge { text: "Ghost";       variant: "ghost" }
    Badge { text: "Link";        variant: "link" }
}
```

## Icons

`iconLeft` and `iconRight` accept a `url` to a 12 × 12 SVG or PNG. Icons render with `sourceSize: Qt.size(12, 12)` so SVGs raster at the right dimensions and stay crisp. Empty string disables the slot.

```qml
Badge {
    text: "Verified"
    variant: "outline"
    iconLeft: "qrc:/icons/check.svg"
}
```

The layout is `[iconLeft] text [iconRight]` inside a `Row` with 4 px gap (shadcn `gap-1`). Omit the text entirely for an icon-only chip, or pass only text for the minimal case.

## Disabled state

Setting `enabled: false` fades background and content to 50 % alpha, matching pearl-kit's convention for inert surfaces:

```qml
Badge {
    text: "Archived"
    variant: "secondary"
    enabled: false
}
```

The root element's opacity is left at 1 — the fade is applied to the background `Rectangle` and content `Row` separately, so any future focus or selection overlay could sit at full alpha over a faded badge.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `text` | `string` | `""` | The badge label |
| `variant` | `string` | `"default"` | One of `default`, `secondary`, `destructive`, `outline`, `ghost`, `link` |
| `iconLeft` | `url` | `""` | Optional 12 × 12 icon rendered before the text |
| `iconRight` | `url` | `""` | Optional 12 × 12 icon rendered after the text |
| `enabled` | `bool` | `true` | When `false`, fades background and content to 50 % alpha |

## Accessibility

`Badge` exposes `Accessible.role: StaticText` with `Accessible.name` bound to `text` — the closest Qt equivalent to shadcn's `<span>` semantics. Screen readers announce the badge text as a plain label; because Badge is non-focusable, no role-based state (`aria-pressed`, `aria-invalid`, `aria-expanded`) applies.

## Interactive badges

Badge is intentionally non-interactive — it mirrors shadcn's default `<span>` behavior rather than the `asChild` anchor variant. If you need click feedback, wrap Badge in a `MouseArea`:

```qml
Item {
    width: innerBadge.width
    height: innerBadge.height
    Badge { id: innerBadge; text: "Clickable" }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: console.log("badge clicked")
    }
}
```

For most real-world interactive status chips, reach for a `Button` with `size: "xs"` and a ghost/outline variant instead — it already handles hover, pressed, focus, and accessibility.

## Under the hood

`Badge` is a plain `Item` wrapping a `Rectangle` background and a centered `Row` containing the optional left icon, the label `Text`, and the optional right icon. There is no `QtQuick.Templates.*` base: badges have no interactive contract (no hover, no pressed, no focus), so the Templates layer would add nothing and pollute the implicit-size math with internal padding.

The background `Rectangle` has `radius: Tokens.radius.full` (9999, capped by Qt to `min(width, height) / 2` — the pill shape) plus `clip: true`, mirroring shadcn's `overflow-hidden` so icons and long labels don't bleed past the pill edges. The border is always 1 px — color flips between `Tokens.border` (outline variant) and `"transparent"` (everything else), so the geometry stays stable when the variant toggles at runtime.

Text renders with a plain `Text` element (not `PearlBaseText`) because the 12 px / variant-colored / optionally underlined typography doesn't reuse any `PearlBaseText` default. `renderType: Text.NativeRendering` with `antialiasing: true` keeps glyphs crisp on Retina displays.

Color transitions on both `Rectangle.color` and `Text.color` animate at `Tokens.motion.fast` (150 ms, `Easing.OutCubic`) so theme switches don't flash — matching shadcn's `transition-[color,box-shadow]`.

## Deliberate divergences from shadcn

- **No hover state.** shadcn's variants include `[a&]:hover:bg-primary/90` etc., which only apply when the badge is rendered as an anchor (`asChild` with `Slot.Root`). Pearl-kit's Badge is a static `<span>` equivalent with no anchor mode, so hover is omitted entirely. Consumers who need click feedback wrap Badge in a MouseArea or use a `Button` with `size: "xs"`.
- **Link variant is always underlined.** shadcn's `link` variant uses `underline-offset-4` with `[a&]:hover:underline` — underline only appears on hover because the variant targets anchors. Pearl-kit underlines the text unconditionally in the link variant, since there is no interactive mode to reveal it otherwise.
- **`iconLeft` / `iconRight` as URL slots.** shadcn composes icons as children (`<Badge><Icon />Label</Badge>`), styled via the `[&>svg]:size-3` descendant selector. Pearl-kit matches `Button` / `Input` / `NavItem` conventions with dedicated URL slots — simpler API, no CSS cascading in QML.
- **Destructive foreground hardcoded to white.** shadcn uses `text-white` on the destructive variant rather than `destructive-foreground`, and pearl-kit matches that literal so Light mode reads identically.
- **No size variants.** shadcn has exactly one size; pearl-kit does too. A smaller "dot" or larger "tag" variant can be added on demand if a real consumer needs it.
- **No focus ring / aria-invalid.** Badge is not focusable, so the focus-visible ring and invalid-state styling from shadcn's base class are omitted.

## Related

- [Button](button.md) — for interactive chips with hover, pressed, focus, and click signals. Use `Button { size: "xs"; variant: "ghost" }` when the badge needs to be clickable.
- [Avatar](avatar.md) — circular profile image. Pair with Badge for `Avatar + Badge` status-dot combinations.
- [Tokens](../tokens.md) — the color and typography scale Badge composes against.
