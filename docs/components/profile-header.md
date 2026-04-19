# ProfileHeader

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=profile-header"
        title="Live ProfileHeader demo"
        loading="lazy"
        width="100%" height="320"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

!!! warning "Experimental"
    This component is in the experimental tab — its API and visual design
    may change without a deprecation cycle. See [Experimental overview](../experimental.md)
    for the stability caveats.

Compound profile header: a 96×96 gradient avatar with serif initials and
a corner `+` overlay, plus a vertical block of serif name + muted title +
mono stats strip (`LICENSE / SINCE / PLANS` etc.).

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

```qml
import QtQuick
import PearlKit 1.0 as P

P.ProfileHeader {
    initials: "MK"
    name: "Dr. Mehmet Kaya"
    title: "Oral & Maxillofacial Surgeon"
    stats: [
        { key: "LICENSE", value: "TR-DDS-21487" },
        { key: "SINCE",   value: "MAR 2024" },
        { key: "PLANS",   value: "1,247" }
    ]
    onAvatarClicked: console.log("upload avatar")
}
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `initials` | `string` | `""` | Serif initials inside the gradient avatar. |
| `name` | `string` | `""` | Serif name line. |
| `title` | `string` | `""` | UI subtitle under the name. |
| `stats` | `var` | `[]` | Array of `{ key, value }`; rendered as mono `KEY value` pairs separated by 20 px. |
| `fontFamilyMono` | `string` | `Tokens.font.mono` | Mono typeface for the stats strip. |
| `fontFamilyUI` | `string` | `Tokens.font.ui` | UI typeface for the title. |
| `fontFamilySerif` | `string` | `"Times New Roman"` | Serif typeface for initials + name. |

## Signals

- `avatarClicked()` — emitted when the corner `+` overlay is clicked.
  Wire to your avatar-upload modal.

## Notes

- Source: `settings.jsx:254-280` in the DALI settings handoff.
- The gradient (`#DBEAFE → #93C5FD`) is hardcoded to match the handoff.
  If you need per-user tones, swap the inner `Rectangle.gradient`.
