# PearlText

Typography primitive — renders strings with `variant`-based font, size, weight, and color presets. The most common widget in a pearl-kit app: headings, body copy, form labels, muted annotations, inline code.

The name is deliberately prefixed to avoid shadowing `QtQuick.Text`: under an unqualified `import PearlKit 1.0`, the built-in `Text` element stays resolvable, and the pearl-kit primitive is accessed as `PearlText`.

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

PearlText { variant: "title"; text: "Settings" }
PearlText { variant: "body";  text: "Update your account information." }
```

## Variants

| Variant | Size | Weight | Color | Family | Line height | Use |
|---|---|---|---|---|---|---|
| `title` | 24 px | semibold | `foreground` | SF Pro Display | 1.2 | Page / section titles |
| `heading` | 18 px | semibold | `foreground` | SF Pro Display | 1.2 | Sub-section headers, dialog titles |
| `body` (default) | 14 px | regular | `foreground` | SF Pro Display | 1.2 | Paragraph text, default |
| `muted` | 14 px | regular | `mutedForeground` | SF Pro Display | 1.2 | Secondary annotations, metadata |
| `label` | 14 px | medium | `foreground` | SF Pro Display | 1.0 | Form labels (shadcn `<Label>` parity) |
| `code` | 14 px | regular | `mutedForeground` | SF Mono | 1.2 | Monospace, muted — inline code, paths |
| `mono` | 14 px | regular | `foreground` | SF Mono | 1.2 | Monospace, default foreground |

```qml
PearlText { variant: "title";   text: "Settings" }
PearlText { variant: "heading"; text: "Notifications" }
PearlText { variant: "body";    text: "Receive updates when your plan completes." }
PearlText { variant: "muted";   text: "32 items" }
PearlText { variant: "label";   text: "Email" }
PearlText { variant: "code";    text: "/usr/local/bin/dali" }
PearlText { variant: "mono";    text: "42" }
```

## Eliding

`PearlText` inherits from `QtQuick.Text`, so every elide and wrap property is available. Set an explicit `width` to trigger eliding.

```qml
PearlText {
    text: "a very long title that will elide at the end"
    width: 160
    elide: Text.ElideRight
}
```

`ElideRight` is the most common. For middle-eliding file paths, use `Text.ElideMiddle`. Multi-line wrapping: set `wrapMode: Text.WordWrap` and a `width`.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `variant` | `string` | `"body"` | One of `title`, `heading`, `body`, `muted`, `label`, `code`, `mono` |
| `text` | `string` | `""` | The content (inherited from `QtQuick.Text`) |
| `elide` | `enum` | `Text.ElideNone` | `ElideNone` / `ElideLeft` / `ElideMiddle` / `ElideRight` |
| `wrapMode` | `enum` | `Text.NoWrap` | `NoWrap` / `WordWrap` / `Wrap` / `WrapAnywhere` |
| `enabled` | `bool` | `true` | Fades the color to 50 % alpha when false |

Every other property on `QtQuick.Text` — `horizontalAlignment`, `maximumLineCount`, `lineHeight`, `textFormat`, etc. — passes through. Customize by overriding per-instance.

## Disabled state

`enabled: false` fades the text color to 50 % alpha. The font family / size / weight are unchanged, matching pearl-kit's convention for other components.

## Under the hood

`PearlText` is a pure `QtQuick.Text` Item — no `Rectangle` wrapper, no `QtQuick.Templates` base. This keeps it cheap (`~100+ call sites` means it shows up everywhere) and makes every native Text property available without re-plumbing.

The variant-driven properties (`font.family`, `font.pixelSize`, `font.weight`, `color`, `lineHeight`) are computed by private `_pxSize`, `_weight`, `_color`, `_family` resolvers that switch on `variant`. Every value comes from `Tokens.font.*` or `Tokens.foreground` / `Tokens.mutedForeground` — no hardcoded hex or magic numbers.

`renderType: Text.NativeRendering` matches the pearl-kit `internal/PearlBaseText.qml` atom for crisp rendering on Retina displays. `antialiasing: true` explicit — Qt's default flips between versions.

## Deliberate differences from shadcn

shadcn has `Label` as a separate form-label primitive and documents typography via Tailwind classes rather than a component. Pearl-kit unifies both concerns into a single `PearlText` with variants:

1. **Single component, not Label + typography classes.** shadcn exports `<Label>` (`text-sm leading-none font-medium`) as its own React component. In pearl-kit, that's `variant: "label"`.
2. **`code` variant has no background chip.** shadcn's `<code>` pattern in typography docs uses `bg-muted px-[0.3rem] py-[0.2rem]`. A pure `Text` Item can't render a background. If you need a visible chip, wrap the `PearlText` in a `Rectangle { color: Tokens.muted; radius: 4; ... }`.
3. **`mono` variant is pearl-kit-specific.** shadcn doesn't distinguish "mono" from "code" — both are rendered the same. Pearl-kit splits: `code` is mono + muted (documentation flavor), `mono` is mono + foreground (data display flavor).
4. **No shadcn typography `h1..h4` / `lead` / `large` / `small` variants.** Not shipped — rewritable via `font.pixelSize` and `font.weight` on any `PearlText` instance. Revisit if DALI demand surfaces.

## Related

- [Input](input.md) — pair `PearlText { variant: "label" }` with an Input for form fields
- [Button](button.md) — Button's label is already internally styled; pass `text:`
- [CheckBox](checkbox.md) — pair with `PearlText` label via `Row` + `MouseArea`
