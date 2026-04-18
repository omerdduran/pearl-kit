# MessageBox

An opinionated modal-message primitive built on top of [Dialog](dialog.md) — four variants (`info`, `warning`, `error`, `confirm`), a tinted badge icon, and auto-generated footer buttons. The pearl-kit equivalent of PyQt6 `QMessageBox`, approximating shadcn/ui's `AlertDialog` composition with a single component call.

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

## Basic usage

```qml
import QtQuick
import QtQuick.Controls
import PearlKit 1.0 as P

ApplicationWindow {
    visible: true
    width: 600; height: 400

    P.Button {
        text: "Save"
        onClicked: {
            // ... save logic ...
            saveFeedback.open()
        }
    }

    P.MessageBox {
        id: saveFeedback
        variant: "info"
        heading: "Saved"
        message: "Your changes have been written to the project file."
    }
}
```

`MessageBox` must be hosted by an `ApplicationWindow` (inherited from `Dialog`'s `T.Overlay.overlay` parenting).

## Variants

| Variant | Icon glyph | Tint | Footer | Typical use |
|---|---|---|---|---|
| `info` (default) | lowercase `i` | `Tokens.primary` @ 15 % | `[OK]` | Save feedback, notices |
| `warning` | `!` | `Tokens.warning` @ 15 % | `[OK]` | Unsaved changes, caveats |
| `error` | `×` | `Tokens.destructive` @ 15 % | `[OK]` (auto destructive) | Load failures, errors |
| `confirm` | `?` | `Tokens.muted` (neutral) | `[OK] [Cancel]` | Destructive confirmations |

```qml
P.MessageBox {
    id: deleteConfirm
    variant: "confirm"
    heading: "Delete annotation?"
    message: "This will permanently remove the implant placement from the current case."
    okText: "Delete"
    okVariant: "destructive"
    cancelText: "Keep"
    onAccepted: annotationModel.remove(index)
}
```

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `variant` | `string` | `"info"` | One of `"info" \| "warning" \| "error" \| "confirm"` |
| `heading` | `string` | `""` | Title line (18 px semibold, hidden if empty) |
| `message` | `string` | `""` | Body text (14 px muted, hidden if empty) |
| `okText` | `string` | `"OK"` | Primary action label |
| `cancelText` | `string` | `"Cancel"` | Secondary action label (only shown for `confirm`) |
| `okVariant` | `string` | auto | `"destructive"` when `variant === "error"`, otherwise `"default"`. Consumer may override. |
| `maxWidth` | `int` | `420` | Overrides Dialog's `512` default |
| `showCloseButton` | `bool` | `false` | Hardcoded — X in the top-right is suppressed |

Inherited from `Dialog`: `modal`, `closePolicy`, `open()`, `close()`, `visible`, `opened()`, `closed()`, `initialFocusItem`.

## Signals

| Signal | Fired when |
|---|---|
| `accepted()` | OK button clicked, or Enter pressed on focused OK |
| `rejected()` | Cancel button clicked (confirm only), or Escape / overlay dismiss for `confirm` variant |

```qml
P.MessageBox {
    id: confirmBox
    variant: "confirm"
    heading: "Proceed?"
    onAccepted: doTheThing()
    onRejected: console.log("user cancelled")
}
```

For `info`, `warning`, `error`: dismissing via Escape or clicking outside closes the dialog **silently** — no signal emitted. `accepted()` fires only when the OK button is explicitly clicked.

## Dismiss semantics

| Variant | Overlay click | Escape | X button |
|---|---|---|---|
| `info` / `warning` / `error` | Closes silently | Closes silently | (none) |
| `confirm` | **Blocked** (modal forces choice) | Closes + `rejected()` | (none) |

The `confirm` variant is intentionally sticky — the user must actively pick OK or Cancel. This matches PyQt6 `QMessageBox` modal-question behavior.

## Focus management

On `open()`, focus goes straight to the OK button. Pressing Enter immediately triggers `accepted()` — no mouse required. For `confirm`, Tab cycles between OK and Cancel.

## Accessibility

- Inherits `Dialog`'s `focus: true` and `Qt.StrongFocus`.
- OK button is focused on open via `initialFocusItem: okButton`.
- ESC honored by all variants; dismisses with `rejected()` for confirm, silent close otherwise.
- Overlay click blocked for `confirm` via `closePolicy: T.Popup.CloseOnEscape` override.

## Under the hood

`MessageBox` extends `Dialog` via QML inheritance (`Dialog { ... }` root). It:

- **Suppresses Dialog's header** (`title: ""`, `description: ""`) and builds its own layout in Dialog's body column via the inherited `default property alias _bodyContent: bodyColumn.data`.
- **Renders an icon + heading + message `ColumnLayout`** inside the body slot; the icon is a new `PearlKit.internal.PearlAlertIcon` Canvas atom (48×48 tinted badge with a per-variant stroke glyph).
- **Auto-generates the footer** as a `Row` with `layoutDirection: Qt.RightToLeft` — `[OK]` always, `[Cancel]` only for `confirm`. OK button uses `okVariant`; Cancel uses shadcn's `"outline"`.
- **Tracks dismiss type** via an inner `QtObject { id: _state; property bool resolved }`. The OK / Cancel handlers set `resolved = true` before closing; `onClosed` emits `rejected()` only if `!resolved && variant === "confirm"`, so Escape / overlay dismiss on `confirm` still yield a signal.
- **Overrides `closePolicy`** to `T.Popup.CloseOnEscape` for `confirm` (no outside-click dismiss) and leaves the default flags for the other variants.

The icon atom `PearlAlertIcon` follows the `PearlXIcon` / `PearlCheckIcon` canvas-drawing pattern — no SVG assets, no Qt5Compat dependency, colors driven by `Tokens`.

## Deliberate differences from shadcn

1. **Single component, not 12 primitives.** shadcn `AlertDialog` exports `AlertDialogContent`, `AlertDialogHeader`, `AlertDialogTitle`, `AlertDialogDescription`, `AlertDialogMedia`, `AlertDialogFooter`, `AlertDialogAction`, `AlertDialogCancel`, `AlertDialogOverlay`, `AlertDialogPortal`, `AlertDialogTrigger`, `AlertDialog`. MessageBox collapses all of that into one component with a `variant` string.
2. **4-variant taxonomy.** shadcn ships `default`/`destructive` only. pearl-kit extends to `info | warning | error | confirm`, matching PyQt6 `QMessageBox::Icon`.
3. **Variant-tinted badge** (15 % α bg + variant-colored glyph). shadcn's `AlertDialogMedia` is neutral `bg-muted` with the color carried by the inner SVG — pearl-kit tints the badge so the variant signal is stronger.
4. **Auto footer.** shadcn treats action/cancel as opt-in primitives. MessageBox emits them automatically based on `variant`.
5. **`confirm` blocks overlay-click dismiss** (PyQt6 idiom). shadcn has no equivalent policy.
6. **Narrower `maxWidth: 420`.** shadcn `sm:max-w-lg` = 512 — MessageBox defaults narrower because alert messages are short.
7. **No close button.** `showCloseButton: false` hardcoded. shadcn AlertDialog doesn't have one either.

## Related

- [Dialog](dialog.md) — use directly for non-message modals (forms, free-compose footers, custom layouts)
- [Button](button.md) — the footer buttons are internally pearl-kit Button with the same variant taxonomy
- [PearlText](pearl-text.md) — heading / message text use the internal `PearlBaseText` which underlies `PearlText`
