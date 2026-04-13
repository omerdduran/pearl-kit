# Tokens

`PearlKit.Tokens` is a QML singleton exposing the complete design language: colors, radius, spacing, typography, shadow, and motion. All public tokens follow the [shadcn/ui](https://ui.shadcn.com/docs/theming) taxonomy.

```qml
import QtQuick
import PearlKit 1.0 as P

Rectangle {
    color: P.Tokens.card
    radius: P.Tokens.radius.md
    border.color: P.Tokens.border
}
```

## Themes

Three modes ship out of the box:

| Mode | Enum | Default | Notes |
|---|---|---|---|
| `Dark` | `Tokens.Dark` | no | Pure dark, high contrast |
| `DarkBlue` | `Tokens.DarkBlue` | **yes** | Blue-tinted dark (airontgen's default) |
| `Light` | `Tokens.Light` | no | Light mode |

Switch at runtime:

```qml
P.Tokens.mode = P.Tokens.Light
```

All bindings update automatically.

## Color tokens

| Token | Dark | DarkBlue | Light |
|---|---|---|---|
| `background` | `#111111` | `#141822` | `#F5F6F8` |
| `foreground` | `#E8E8E8` | `#E8ECF4` | `#1E293B` |
| `muted` | `#242424` | `#232942` | `#F0F1F4` |
| `mutedForeground` | `#999999` | `#9AACC4` | `#64748B` |
| `card` | `#1A1A1A` | `#1B2033` | `#FFFFFF` |
| `cardForeground` | `#E8E8E8` | `#E8ECF4` | `#1E293B` |
| `popover` | `#222222` | `#273050` | `#FFFFFF` |
| `popoverForeground` | `#E8E8E8` | `#E8ECF4` | `#1E293B` |
| `primary` | `#3B82F6` | `#4B92FF` | `#2563EB` |
| `primaryForeground` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` |
| `secondary` | `#A78BFA` | `#B49CFF` | `#7C3AED` |
| `secondaryForeground` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` |
| `accent` | `#3A3A3A` | `#2A4A7A` | `#DBEAFE` |
| `accentForeground` | `#E8E8E8` | `#E8ECF4` | `#1E293B` |
| `destructive` | `#EF4444` | `#EF4444` | `#DC2626` |
| `destructiveForeground` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` |
| `success` | `#22C55E` | `#22C55E` | `#16A34A` |
| `warning` | `#F59E0B` | `#F59E0B` | `#D97706` |
| `border` | `#2A2A2A` | `#283050` | `#E2E5EA` |
| `input` | `#242424` | `#232942` | `#F0F1F4` |
| `ring` | `#3B82F6` | `#4B92FF` | `#3B82F6` |
| `elevation0` | `#111111` | `#141822` | `#F5F6F8` |
| `elevation1` | `#1A1A1A` | `#1B2033` | `#FFFFFF` |
| `elevation2` | `#242424` | `#232942` | `#F0F1F4` |
| `elevation3` | `#222222` | `#273050` | `#FFFFFF` |

## Radius

`Tokens.radius.sm` = 4, `.md` = 6, `.lg` = 8, `.xl` = 12, `.full` = 9999.

## Spacing

4-based scale. `Tokens.space.x0` = 0, `.x1` = 4, `.x2` = 8, `.x3` = 12, `.x4` = 16, `.x5` = 20, `.x6` = 24, `.x8` = 32, `.x10` = 40, `.x12` = 48.

## Typography

- `Tokens.font.ui` — `"SF Pro Display"`
- `Tokens.font.mono` — `"SF Mono"`
- `Tokens.font.size.{xs,sm,md,lg,xl,xxl}` — `12, 14, 16, 18, 20, 24`
- `Tokens.font.weight.{regular,medium,semibold,bold}` — Qt `Font` constants

## Shadow

Two-layer shadcn-style black opacity:

- `Tokens.shadow.sm1` / `sm2` — 10% / 6%
- `Tokens.shadow.md1` / `md2` — 12% / 8%
- `Tokens.shadow.lg1` / `lg2` — 16% / 10%

## Motion

Durations in ms: `Tokens.motion.fast` = 120, `.base` = 180, `.slow` = 260.
