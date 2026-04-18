# Card

Elevated surface primitive for grouping related content — a bordered, padded container with an optional left-border accent stripe for status signaling. Use `Card` when you want a neutral container for mixed content; use [`GroupBox`](group-box.md) when you need a built-in title, description, or collapsible header.

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

Card {
    PearlText { variant: "heading"; text: "Plan summary" }
    PearlText { variant: "muted"; text: "4 implants ready to export." }
}
```

Children passed as default-slot content land in a vertical `Column` with 24 px spacing by default — matching shadcn's `flex flex-col gap-6`.

## Variants

| Variant | Accent stripe | Use case |
|---|---|---|
| `default` | None | Neutral content grouping |
| `destructive` | `Tokens.destructive` | Error, validation failure, collision |
| `warning` | `Tokens.warning` | Caution, low-confidence signal |
| `success` | `Tokens.success` | Completion, validated state |
| `info` | `Tokens.primary` | Informational callout, beta flag |

```qml
Card {
    variant: "destructive"
    PearlText { variant: "heading"; text: "Collision detected" }
    PearlText {
        variant: "muted"
        wrapMode: Text.WordWrap
        text: "Implant #3 overlaps the mandibular nerve canal."
    }
}
```

Setting `variant` to anything other than `"default"` auto-enables a 4 px left-border accent stripe in the variant color. Override per-instance via `accentWidth`.

## Padding and spacing

`Card` defaults to 24 px padding and 24 px inter-child spacing. Override both per-instance:

```qml
Card {
    padding: 16
    spacing: 8
    PearlText { variant: "label"; text: "Compact" }
    PearlText { variant: "muted"; text: "Dense list row." }
}
```

The content `Column` is offset inwards by `padding` on all four sides. Children inherit the `Column` width automatically via `parent.width` inside the Column.

## Accent stripe

The accent stripe is a 4 px rectangle anchored to the left edge, rendered inside a clipped `Rectangle` so its corners round with the card's `radius-xl`. Override width:

```qml
Card { variant: "destructive"; accentWidth: 6 }
```

Set `accentWidth: 0` to disable the stripe even on non-default variants:

```qml
Card { variant: "destructive"; accentWidth: 0 }
```

## Disabled state

Setting `enabled: false` fades the surface background and content `Column` to 50 % alpha. Matches pearl-kit's convention for other inert surfaces:

```qml
Card {
    enabled: false
    PearlText { variant: "heading"; text: "Archived" }
}
```

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `variant` | `string` | `"default"` | One of `default`, `destructive`, `warning`, `success`, `info` |
| `accentWidth` | `int` | `4` (non-default variant) / `0` (default) | Left-stripe width in px; `0` disables |
| `padding` | `int` | `24` | Inset around content column on all four sides |
| `spacing` | `int` | `24` | Vertical gap between content-column children |
| `enabled` | `bool` | `true` | `false` fades background + content to 50 % alpha |
| default slot | children | — | Aliased onto an internal `Column { spacing: spacing }` |

## Under the hood

`Card` is an `Item`-rooted primitive — no `QtQuick.Templates` base, since a card has no interactive contract. The surface is a child `Rectangle` with `radius: Tokens.radius.xl` (12 px, matching shadcn `rounded-xl`), `border.color: Tokens.border`, and `border.width: 1`.

The accent stripe is a second `Rectangle` nested inside the surface with `clip: true` on the parent. Clipping is the cleanest QML idiom for single-side rounded corners — the stripe itself has no `radius`, but the parent surface's rounded corners clip the stripe's outer edges. Without `clip`, the stripe would render as a sharp-cornered rectangle overlapping the card's rounded corner.

The content `Column` is a sibling of the surface (not a child) — consistent with `GroupBox`. This avoids `clip: true` affecting descendant rendering (e.g., popup or hover layers escaping the card bounds).

## Deliberate differences from shadcn

shadcn ships `Card` as a composition of seven React primitives (`Card`, `CardHeader`, `CardTitle`, `CardDescription`, `CardAction`, `CardContent`, `CardFooter`). Pearl-kit takes a different path:

1. **Single atomic `Card`, not a composition.** shadcn's header / content / footer split exists because CSS flexbox dividers (`has-[.border-t]:pt-6`) need explicit slot components. QML's `Column` + `Separator` handle the same job without sub-components. For title + description + collapsible affordances, reach for [`GroupBox`](group-box.md) — it's the pearl-kit analogue of `CardHeader` + `CardTitle` + `CardDescription` rolled into one.
2. **Left-border accent stripe (pearl-kit extension).** shadcn Card has no status taxonomy. Pearl-kit adds `variant`-driven accents because status cards are common in medical-planning UI (DALI's `ImplantCard` invalid-collision state). Default variant renders with no stripe for shadcn parity.
3. **No `shadow-sm`.** shadcn applies a subtle shadow by default; pearl-kit omits it for consistency with `GroupBox`. Border + background alone read as elevated on macOS. Revisit if DALI surfaces a clear shadow-dependent case — shadow would use `QtQuick.Effects.MultiEffect` (see `Dialog` for the pattern).
4. **Built-in `Column` layout.** shadcn uses flexbox on the Card itself. Pearl-kit bakes a `Column` in so simple usage (`Card { PearlText {} PearlText {} }`) just works. For custom layouts, wrap children in a `ColumnLayout`, `RowLayout`, `GridLayout`, or custom container inside Card.

## Related

- [GroupBox](group-box.md) — titled container with description and optional collapsible body. Use when you need header semantics inside the card surface.
- [Separator](separator.md) — divider for Card content rows.
- [PearlText](pearl-text.md) — typography primitive for Card children.
