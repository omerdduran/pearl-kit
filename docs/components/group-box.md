# GroupBox

A titled section container for grouping related form rows under a heading. Optionally collapsible, with built-in support for an "advanced settings" visibility gate.

shadcn/ui has no direct `GroupBox` primitive — `GroupBox` is a pearl-kit-original composition derived from shadcn `Card` (visual container) and `Accordion` (collapse semantics).

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

P.GroupBox {
    title: "Notifications"
    description: "Choose how you'd like to be notified."

    P.CheckBox { }
    P.Toggle { }
}
```

Children placed inside `GroupBox` land in an internal Column with 12 px spacing — typical form-row spacing. Wrap in your own `Row`, `Column`, or `GridLayout` if you need a different arrangement.

## Basic usage

The simplest form: a static section with a title only.

```qml
P.GroupBox {
    title: "Profile"
    P.Input { placeholderText: "Display name" }
    P.Input { placeholderText: "Email" }
}
```

Add a `description` for a one-line subtitle below the title:

```qml
P.GroupBox {
    title: "Notifications"
    description: "Choose how you'd like to receive alerts."
    P.CheckBox { }
    P.Toggle { }
}
```

Both `title` and `description` are optional. An empty title hides the title text; an empty description hides the description row.

## Collapsible

Set `collapsible: true` to make the header a click target. A right-aligned chevron appears that rotates 180° when the section opens. The whole header row also becomes keyboard-activatable via `Space` or `Return` when focused.

```qml
P.GroupBox {
    title: "Appearance"
    description: "Theme and density preferences."
    collapsible: true
    expanded: true   // start open

    P.Toggle { }
    P.Select { model: ["Light", "Dark"] }
}
```

The `expanded` property is read-write — bind it to your own state if you need external control:

```qml
P.GroupBox {
    title: "Filters"
    collapsible: true
    expanded: settingsModel.filtersOpen
    onExpandedChanged: settingsModel.filtersOpen = expanded
    /* ... */
}
```

Collapse animates the inner content height and opacity over 180 ms with `Easing.OutCubic`. The header→content gap (24 px) animates out simultaneously so the closed section is compact.

## Advanced visibility pattern

`GroupBox` exposes two properties for the DALI-style "show advanced settings" toggle:

| Property | Meaning |
|---|---|
| `advanced` | Marks the section as advanced (default `false`). |
| `advancedVisible` | When `advanced: true`, gates whether the section is rendered (default `true`). |

The component computes its own `visible` as `!advanced || advancedVisible`. Bind `advancedVisible` to your global toggle:

```qml
P.Toggle { id: showAdvanced }

P.GroupBox {
    title: "Diagnostics"
    description: "Power-user options."
    advanced: true
    advancedVisible: showAdvanced.checked
    /* ... */
}
```

When `advanced: true && advancedVisible: false`, the GroupBox sets `visible: false`, which collapses the layout slot — no empty space is left behind. Sections without `advanced` set are always visible regardless of the toggle.

## States

| State | Trigger | Visual |
|---|---|---|
| Default | idle | Card-style frame, 24 px padding |
| Collapsed | `expanded: false` (collapsible only) | Header only, animated height + opacity |
| Focus (keyboard, collapsible) | Tab | 3 px focus ring around the section |
| Hover (collapsible header) | Pointer over header | `PointingHandCursor` |
| Disabled | `enabled: false` | Header + body content at 50 % opacity |
| Hidden (advanced) | `advanced && !advancedVisible` | Not rendered, layout slot collapses |

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | `""` | Section heading (16 px, semibold). Hidden when empty. |
| `description` | `string` | `""` | Optional subtitle below the title (14 px, muted). Hidden when empty. |
| `collapsible` | `bool` | `false` | When `true`, header is interactive and a rotating chevron appears. |
| `expanded` | `bool` | `true` | Open / closed state. Read-write — bind for external control. |
| `advanced` | `bool` | `false` | Marks the section as advanced for the visibility gate. |
| `advancedVisible` | `bool` | `true` | When `advanced: true`, controls render. Bind to a global toggle. |
| `enabled` | `bool` | `true` | Standard QML disabled flag. Fades header + body, suppresses interaction. |
| `content` (default) | `list<Item>` | `[]` | Children land in an internal Column at 12 px spacing. |

## Accessibility

- **Keyboard activation** — when `collapsible: true`, the GroupBox participates in the Tab focus chain. `Space` and `Return` toggle `expanded`.
- **Click target** — when `collapsible: true`, the entire header row is a click target with `PointingHandCursor`. Non-collapsible sections do not capture pointer input on the header.
- **Disabled state** — `enabled: false` suppresses keyboard and pointer interaction on the header (chevron toggle disabled) but does **not** disable inner children. Disable individual fields explicitly.
- **Focus ring** — only appears for collapsible sections, only on keyboard focus (`activeFocus` while `collapsible: true`). Matches shadcn's `focus-visible:` semantics.

## Under the hood

Unlike most pearl-kit components, `GroupBox` does **not** inherit from a `QtQuick.Templates.*` base. The collapse animation requires fine-grained control over the inner content's clipped height and opacity, so the root is a plain `Item` with a child `Column` for layout.

The component composes from existing pearl-kit atoms:

- **`PearlText`** for the title (16 px semibold) and description (14 px muted).
- **`PearlChevron`** for the collapsible indicator. Rotates 180° via `Behavior on rotation` when `expanded` changes.
- **`PearlFocusRing`** for the keyboard focus indicator (visible only when `collapsible && activeFocus`).
- **`Tokens.card`** for the background, **`Tokens.border`** for the 1 px border, **`Tokens.radius.lg`** (8 px) for the corner — slightly tighter than shadcn's `rounded-xl` Card to feel more "form section" than "marketing card".

The collapse animation runs three concurrent transitions:

1. The inner content wrapper's `height` drops from `_innerColumn.implicitHeight` to `0`.
2. Its `opacity` drops from `1.0` to `0.0`.
3. The outer Column's `spacing` drops from 24 px to 0 px.

All three use `Tokens.motion.base` (180 ms) with `Easing.OutCubic`. The wrapper sets `clip: true` so children don't leak during the height transition.

## Deliberate divergences from shadcn

- **No shadcn primitive named `GroupBox`** — `GroupBox` is a pearl-kit composition. The visual frame mirrors shadcn `Card`, the collapse pattern mirrors shadcn `Accordion`, and the `advanced` gate is unique to pearl-kit (DALI's `_mark_advanced` parity).
- **`Tokens.radius.lg` (8 px) instead of `Tokens.radius.xl` (12 px)** — shadcn `Card` uses `rounded-xl`. Settings sections look better with a tighter corner; large rounding pushes them toward "marketing surface" territory.
- **No `shadow-sm`** — shadcn `Card` has a subtle shadow. Settings sections sit flat against the tab background; adding shadow muddies the grid of multiple sections in a single tab.
- **No header action slot** — shadcn `CardAction` reserves a top-right corner for an action element. Deferred — use a dedicated row at the top of the body if you need an action. May be added in a future revision.
- **No footer slot** — shadcn `CardFooter`. Same rationale as the action slot.
