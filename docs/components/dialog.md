# Dialog

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=dialog"
        title="Live Dialog demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A modal popover for focused user interactions — confirmations, forms, notices. Ports [shadcn/ui v4 Dialog](https://ui.shadcn.com/docs/components/dialog) with shadcn-accurate geometry, animations, and overlay semantics.

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
import QtQuick.Controls
import PearlKit 1.0 as P

ApplicationWindow {
    visible: true
    width: 600; height: 400

    P.Button {
        text: "Open"
        onClicked: myDialog.open()
    }

    P.Dialog {
        id: myDialog
        title: "Delete file?"
        description: "This action cannot be undone."
        footer: Row {
            spacing: 8
            layoutDirection: Qt.RightToLeft
            P.Button { text: "Delete"; variant: "destructive"; onClicked: myDialog.close() }
            P.Button { text: "Cancel"; variant: "outline"; onClicked: myDialog.close() }
        }
    }
}
```

`Dialog` must be hosted by an `ApplicationWindow` (not a plain `Window`) because it parents itself to `T.Overlay.overlay`, which only `ApplicationWindow` provides.

## Basic usage

`Dialog` derives from `QtQuick.Templates.Popup`. Use `open()` / `close()` to show/hide. The dialog is modal by default — a 50 % black overlay dims the content behind it, and clicks outside close it.

Children declared inside `Dialog { ... }` become body content, stacked vertically with 16 px spacing.

```qml
P.Dialog {
    id: dialog
    title: "Profile settings"
    description: "Update your account information."

    P.Input { placeholderText: "Full name" }
    P.Input { placeholderText: "Email" }
    P.Toggle { }
}
```

## Anatomy

| Slot | Purpose | How it's set |
|---|---|---|
| `title` | `string` — large heading (18 px semibold) | `title: "Hello"` |
| `description` | `string` — muted body text below title (14 px muted) | `description: "Short explainer."` |
| body | free-form QML children | default slot — put Items as children of `Dialog { ... }` |
| `footer` | `Component` — rendered at the bottom via `Loader` | `footer: Row { ... }` |
| close button | built-in X in top-right | toggle via `showCloseButton: false` |

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | `""` | Heading text (hidden if empty) |
| `description` | `string` | `""` | Muted body text below title (hidden if empty) |
| `showCloseButton` | `bool` | `true` | Whether the top-right X icon is shown |
| `maxWidth` | `int` | `512` | Maximum dialog width in px (shadcn `sm:max-w-lg`) |
| `footer` | `Component` | `null` | Footer slot — typically a `Row` of buttons |
| `initialFocusItem` | `Item` | `null` | Which item to focus when the dialog opens |
| `modal` | `bool` | `true` | Inherited from `T.Popup`; overlay blocks background interaction |
| `closePolicy` | flags | `CloseOnEscape \| CloseOnPressOutside` | Inherited from `T.Popup` |

Everything else is whatever `QtQuick.Templates.Popup` exposes — `open()`, `close()`, `visible`, `opened()`, `closed()`, etc.

## Footer pattern

The `footer` property takes a `Component` (not an `Item`) — define your footer inline with `footer: Row { ... }`. Use `layoutDirection: Qt.RightToLeft` for shadcn-style right-aligned buttons; the visual order reads left-to-right when rendered.

```qml
P.Dialog {
    id: dialog
    title: "Confirm"
    footer: Row {
        spacing: 8
        layoutDirection: Qt.RightToLeft
        P.Button { text: "Accept"; onClicked: dialog.close() }
        P.Button { text: "Cancel"; variant: "outline"; onClicked: dialog.close() }
    }
}
```

## Animation

- Overlay: fade 0 → 1 over 200 ms via `Behavior on opacity`.
- Content: parallel `NumberAnimation` on `opacity` (0 → 1) and `scale` (0.95 → 1.0) over 200 ms, `Easing.OutCubic`. Matches shadcn's `fade-in-0 zoom-in-95`.
- Exit mirrors the entry.

## States

| State | Trigger | Visual |
|---|---|---|
| Closed | `visible: false` (initial) | Dialog and overlay both hidden |
| Opening | `open()` called | Overlay fades 0→1, content fades + scales 0.95→1.0 over 200 ms |
| Open | settled | Full opacity, scale 1.0, keyboard focus on `initialFocusItem` (or dialog root) |
| Closing | `close()` / ESC / click outside | Reverse of opening transition |

## Accessibility

- `focus: true` + `Qt.StrongFocus` — dialog receives keyboard focus when opened.
- ESC closes via `T.Popup.CloseOnEscape`.
- Click outside closes via `T.Popup.CloseOnPressOutside` (the overlay intercepts clicks).
- Close button (X) is focusable via Tab and activates on Space / Return.
- Focus ring on the close button: 2 px, 2 px offset, `Tokens.ring @ 50 %`, on active focus (shadcn `focus:ring-2 focus:ring-offset-2`).
- Set `initialFocusItem: someInput` to steer focus on open; without it, focus goes to the dialog root so ESC still works.

## Under the hood

`Dialog` is a `QtQuick.Templates.Popup` (not `QtQuick.Templates.Dialog`) with:

- **Background**: a `Rectangle` with `Tokens.radius.lg` + 1 px `Tokens.border` + `layer.effect: MultiEffect` for the drop shadow. Requires `import QtQuick.Effects`.
- **Overlay**: attached `T.Overlay.modal` property set to a `Rectangle` with 50 % black + `Behavior on opacity` for the fade.
- **contentItem**: an `Item` that hosts a `ColumnLayout` (header → body → footer) and an absolutely-positioned close button as the column's sibling.
- **Body slot**: `default property alias _bodyContent: bodyColumn.data` — child declarations on `Dialog { ... }` land inside the body Column.
- **Footer slot**: `property Component footer: null` + a `Loader` at the bottom of the `ColumnLayout`. The Loader is `active` only when the consumer provides a footer.
- **Close button**: a `Rectangle` (not a `T.Button`, because the size is 16×16 and `T.Button.implicitHeight` is 36 and not overridable) with a `MouseArea` for hit-testing, a `PearlXIcon` Canvas atom centered inside, and a `PearlFocusRing` for keyboard focus feedback.
- **Positioning**: `T.Popup` does not support `anchors`. `x = round((parent.width - width) / 2)` and the same for `y`, parented to `T.Overlay.overlay`. `Math.round` avoids subpixel blur in the shadow and border.
- **Focus management**: `onOpened` calls `initialFocusItem.forceActiveFocus()` if set, otherwise the dialog itself takes focus so ESC works.

## Deliberate differences from shadcn

1. **Single `Dialog` component, not DialogHeader / DialogFooter / DialogTitle / DialogDescription.** shadcn exports each as a separate React component for maximum composition flexibility. Pearl-kit bundles them into `title`, `description`, default body slot, and `footer: Component` to keep the API small and match Qt idioms.
2. **Base type is `T.Popup`, not `T.Dialog`.** `T.Dialog` bundles `standardButtons` + `accepted()` / `rejected()` signals tied to a fixed button taxonomy (Ok / Cancel / Apply). shadcn has none of that — the consumer composes footer buttons freely. Using `T.Popup` avoids the bagage.
3. **Single-layer shadow via `MultiEffect`.** shadcn's `shadow-lg` is two layered shadows in CSS. `MultiEffect` is a single-pass approximation; cascading two layers adds complexity for negligible visual gain at this scale.
4. **`maxWidth` as a property, not a class.** shadcn uses Tailwind's responsive `sm:max-w-lg`. Pearl-kit exposes `maxWidth: 512` as an overridable int — the desktop equivalent, easier than overriding className inheritance.

## Related

- [Button](button.md) — trigger dialogs via `onClicked: myDialog.open()`
- [Input](input.md) — common body content for form dialogs
- [Select](select.md) — another modal pattern for single choice
