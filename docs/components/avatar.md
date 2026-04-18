# Avatar

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=avatar"
        title="Live Avatar demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A compact circular identity chip for chat UIs, contact lists, and user menus — displays an image, an icon, or initials inside a themed circle. Priority-resolves between the three content sources so a single `Avatar` gracefully falls back from image → icon → initials.

The API is a pixel-accurate port of shadcn/ui's [Avatar](https://ui.shadcn.com/docs/components/avatar) (new-york style, v4 registry), extended with a `variant` property for role-based tinting (assistant vs user in chat) since shadcn's fallback is uniformly `bg-muted`.

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

Avatar {
    initials: "OD"
    variant: "secondary"
}
```

## Content priority

When multiple content sources are set, `source` wins over `iconSource` wins over `initials`:

| `source` set | `iconSource` set | `initials` set | Renders |
|---|---|---|---|
| ✓ | — | — | Image (crop-filled) |
| — | ✓ | — | Icon (centered glyph) |
| — | — | ✓ | Text (centered initials) |
| ✓ | ✓ | ✓ | Image |
| — | ✓ | ✓ | Icon |
| — | — | — | Empty themed circle |

This mirrors shadcn's `AvatarImage` → `AvatarFallback` priority chain and means you can wire one `Avatar` to a user object that may or may not have a profile picture, without branching in the consumer.

```qml
Avatar {
    source: user.profilePicture        // falls through if ""
    iconSource: "qrc:/default-user.svg" // falls through if ""
    initials: user.name.substring(0, 2).toUpperCase()
}
```

## Sizes

Three sizes matching shadcn's `size-6`, `size-8`, `size-10`:

| Size | Diameter | Text | Icon |
|---|---|---|---|
| `"sm"` | 24 px | 12 px (`text-xs`) | 14 px |
| `"default"` | 32 px | 14 px (`text-sm`) | 16 px |
| `"lg"` | 40 px | 14 px (`text-sm`) | 20 px |

```qml
Row {
    spacing: 12
    Avatar { size: "sm";      initials: "OD" }
    Avatar { size: "default"; initials: "OD" }
    Avatar { size: "lg";      initials: "OD" }
}
```

## Variants (role indicator)

Three variants for role-based tinting. This is a pearl-kit extension over shadcn — useful when you need visual separation between actors in a chat log, or to signal account type in a contact list.

| Variant | Background | Foreground | Use |
|---|---|---|---|
| `"default"` | `Tokens.muted` | `Tokens.mutedForeground` | Neutral / generic user |
| `"primary"` | `Tokens.primary` | `Tokens.primaryForeground` | Assistant / system / brand |
| `"secondary"` | `Tokens.secondary` | `Tokens.secondaryForeground` | User / counterparty |

```qml
Column {
    spacing: 8
    Row {
        spacing: 8
        Avatar { variant: "primary"; initials: "AI" }
        PearlText { text: "Here's what I found."; anchors.verticalCenter: parent.verticalCenter }
    }
    Row {
        spacing: 8
        Avatar { variant: "secondary"; initials: "OD" }
        PearlText { text: "Can you summarize it?"; anchors.verticalCenter: parent.verticalCenter }
    }
}
```

## States

| State | Trigger | Visual |
|---|---|---|
| Default | idle | Full-opacity themed circle |
| Disabled | `enabled: false` | 50 % background opacity |

`Avatar` has no hover, pressed, or focus state — it is a pure display primitive, not interactive. Wrap it in a `MouseArea` or a `Button` if you need click behavior.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `size` | `string` | `"default"` | `"sm"` (24 px) / `"default"` (32 px) / `"lg"` (40 px) |
| `variant` | `string` | `"default"` | `"default"` / `"primary"` / `"secondary"` — role tint |
| `source` | `url` | `""` | Image URL (highest content priority) |
| `iconSource` | `url` | `""` | Icon URL (middle priority, rendered centered at size-dependent dimensions) |
| `initials` | `string` | `""` | Text fallback (lowest priority, 1–2 characters recommended) |

Inherited from `Item`: `width`, `height`, `enabled`, `visible`, `opacity`, `anchors.*`, `Layout.*` — override `implicitWidth` / `implicitHeight` is honored but breaks size parity.

## Accessibility

`Avatar` is a passive decorative element. When it accompanies a name label, rely on the label for screen-reader content. When the avatar is the only identity indicator (e.g. in a chat bubble), set `Accessible.role: Accessible.Graphic` and `Accessible.name` from the consumer:

```qml
Avatar {
    initials: "OD"
    Accessible.role: Accessible.Graphic
    Accessible.name: "Ömer Duran"
}
```

## Under the hood

`Avatar` is a plain `Item` (no `QtQuick.Templates` base — it has no interactive contract) with a single `Rectangle` child whose `radius: width / 2` produces the circle and whose `clip: true` crops any content overflow. The three content sources are sibling children of the surface rectangle, visibility-gated so only one is shown at a time:

- `Image` with `fillMode: Image.PreserveAspectCrop` and `sourceSize` set to `2 × diameter` for retina sharpness, bound to `source`
- `Image` centered with `fillMode: Image.PreserveAspectFit` and `sourceSize` matching the resolved icon pixel size, bound to `iconSource`
- `Text` centered with `Text.NativeRendering`, `Tokens.font.weight.medium`, theme-reactive color, bound to `initials`

Size, text pixel size, and icon pixel size resolve through a private `_sizing` `QtObject` — extend it if you add a new size bucket. Variant colors resolve through a private `_v` `QtObject` — extend it to add a new role tint.

## Deliberate divergences from shadcn

- **`variant` property added.** shadcn's fallback is uniformly `bg-muted` + `text-muted-foreground`; pearl-kit's most common Avatar use is chat UI where assistant-vs-user distinction matters. `primary` and `secondary` variants cover that cleanly without requiring the consumer to compose external wrapping.
- **Single-component API.** shadcn splits into `Avatar`, `AvatarImage`, `AvatarFallback`, `AvatarBadge`, `AvatarGroup`, `AvatarGroupCount`. Pearl-kit collapses the image / icon / initials variants into one component with priority-resolved `source` / `iconSource` / `initials` slots. The `AvatarBadge` (presence dot) and `AvatarGroup` (overlapping stack) primitives are deferred — add them when a real consumer ask emerges.
- **`iconSource` slot.** shadcn has no icon variant (only image or text). Pearl-kit adds `iconSource` as the middle-priority fallback to cover "user has no photo, show a generic user glyph" without forcing the consumer to rasterize SVG into PNG first.
- **No `select-none` equivalent.** Qt's default `Text` already does not participate in mouse selection unless wrapped in a `TextInput` / `TextEdit`; no explicit property needed.
