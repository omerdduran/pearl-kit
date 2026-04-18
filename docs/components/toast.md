# Toast

Sonner-style in-app notifications with an optional `QSystemTrayIcon` bridge for background notifications. Three cooperating pieces: `Toaster` (singleton API), `ToasterHost` (renderer placed inside your `ApplicationWindow`), and `Toast` (the delegate surface used internally — usable standalone if you need to build your own host).

## Import

```python
import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit

app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
pearl_kit.register_qml(engine)

# Optional — enables OS tray notifications when the app is backgrounded.
pearl_kit.register_notifications(engine, icon_path="path/to/my-tray-icon.png")
```

Inside your QML:

```qml
import QtQuick
import QtQuick.Controls
import PearlKit 1.0 as P

ApplicationWindow {
    width: 800
    height: 600

    // Place once. The host auto-parents to the window's overlay.
    P.ToasterHost { }

    P.Button {
        text: "Save"
        onClicked: P.Toaster.show({
            type: "success",
            title: "Saved",
            description: "Your changes are live."
        })
    }
}
```

## Showing toasts

`P.Toaster.show(opts)` accepts an object. All fields are optional except in practice you want at least a `title`.

| Field | Type | Default | Notes |
|---|---|---|---|
| `type` | `string` | `"default"` | One of `default` / `success` / `info` / `warning` / `error` / `loading` |
| `title` | `string` | `""` | Bold first line |
| `description` | `string` | `""` | Second line, wraps |
| `duration` | `int` | `4000` | Milliseconds. `0` disables auto-dismiss (loading toasts default to `0`). |

Returns an integer `id` you can later pass to `P.Toaster.dismiss(id)`.

```qml
var id = P.Toaster.show({type: "loading", title: "Processing..."})
// later:
P.Toaster.dismiss(id)
```

`P.Toaster.dismissAll()` closes every visible toast with animated exit.

## Positioning

Set `P.Toaster.position` to one of:

- `top-right` (default)
- `top-left`
- `top-center`
- `bottom-right`
- `bottom-left`
- `bottom-center`

The stack anchors to that corner with a 16 px inset. Changing position at runtime re-anchors the column immediately (the current toasts don't animate to the new corner — deferred to a future release).

```qml
Component.onCompleted: P.Toaster.position = "bottom-left"
```

## Stack limit

`P.Toaster.maxStack` defaults to `3`. When the stack is full, the oldest toast is silently removed before the new one is appended. Adjust for denser UIs:

```qml
Component.onCompleted: P.Toaster.maxStack = 5
```

## Types

| Type | Icon | Accent |
|---|---|---|
| `default` | none | `Tokens.foreground` |
| `success` | check in circle | `Tokens.success` |
| `info` | i in circle | `Tokens.primary` |
| `warning` | triangle + `!` | `Tokens.warning` |
| `error` | X in circle | `Tokens.destructive` |
| `loading` | spinning arc | `Tokens.mutedForeground` |

Loading toasts ignore the auto-dismiss timer; you must close them explicitly via `Toaster.dismiss(id)` when the underlying operation finishes.

## Hover pause

Moving the mouse over a toast pauses its auto-dismiss Timer. Moving away resumes it — note that the interval restarts from zero rather than preserving remaining time (deferred to a future release). Loading toasts are unaffected since they have no timer.

## OS tray notifications

Calling `pearl_kit.register_notifications(engine, icon_path)` exposes a Python `NotificationCenter` QObject as the `NotificationCenter` QML context property. `ToasterHost` probes for it at load time and forwards the wiring to the `Toaster` singleton.

The behavior split:

- **App focused** — `Toaster.show(...)` renders an in-app toast
- **App backgrounded** — the in-app toast is skipped and the tray icon emits a native OS notification instead (5 s timeout, error type = `QSystemTrayIcon.Critical`, everything else = `Information`)

Pass `icon_path=None` to opt into the focus-state split while still keeping OS notifications as no-ops — useful when you want toasts to appear only when the user is looking, without actually shipping a tray icon.

```python
center = pearl_kit.register_notifications(engine, icon_path=None)
# center.showOsNotification("t", "b", False) is now a no-op.
```

## States

| State | Trigger | Visual |
|---|---|---|
| Enter | `show()` called | 40 px slide + fade in, 180 ms OutCubic |
| Exit | `dismiss()` or timer | 40 px slide + fade out, 180 ms OutCubic, row removed after |
| Hover | mouse over card | Timer pauses |
| Focus (keyboard) | Tab onto close button | 2 px ring @ `ring / 50 %`, 2 px offset |

## Property reference — `Toaster` (singleton)

| Property | Type | Default | Description |
|---|---|---|---|
| `position` | `string` | `"top-right"` | See Positioning |
| `maxStack` | `int` | `3` | Hard cap on simultaneous toasts |
| `defaultDuration` | `int` | `4000` | Fallback duration when `show()` omits it |

| Method | Signature | Description |
|---|---|---|
| `show(opts)` | `var → int` | Appends a toast, returns its numeric `id` |
| `dismiss(id)` | `int → void` | Triggers exit animation + model removal |
| `dismissAll()` | `→ void` | Dismisses every toast currently in the stack |

## Property reference — `Toast` (delegate)

| Property | Type | Default | Description |
|---|---|---|---|
| `toastId` | `int` | `-1` | Internal id used by Toaster.dismiss |
| `type` | `string` | `"default"` | Routes icon + accent color |
| `title` | `string` | `""` | Bold first line |
| `description` | `string` | `""` | Secondary line |
| `duration` | `int` | `4000` | Auto-dismiss timer interval (ms) |

## Accessibility

Toast itself is a passive surface (`focusPolicy: Qt.NoFocus`, `activeFocusOnTab: false`) — it does not receive keyboard focus. The close button (X icon) is Tab-reachable and can be activated with Space or Return, which calls `Toaster.dismiss(toastId)`.

Screen readers announce the toast's `title` and `description` via the default `PearlText` text content. No separate ARIA role is set — Qt's accessibility stack exposes the visual text automatically.

## Under the hood

- **`Toaster.qml`** is a QML singleton (`pragma Singleton` + `singleton` keyword in `qmldir`). It owns the `ListModel _stack` and the `show` / `dismiss` / `dismissAll` API. It does **not** render anything — it dispatches a `dismissRequested(id)` signal and expects a host to listen.
- **`ToasterHost.qml`** is a plain `Item` whose `parent` is bound to `T.Overlay.overlay`. Placed inside `ApplicationWindow`, it auto-attaches to the window overlay, probes the `NotificationCenter` context property, and renders the `Toaster._stack` model through a `Repeater` inside a `Column` with `add` / `move` transitions for stack animation.
- **`Toast.qml`** is a plain `Item` with a `Rectangle` card + `RowLayout` (icon + text column + close button). It runs its own enter animation via `Component.onCompleted` (opacity 0 → 1, x +40 → 0) and its own exit via a `Connections` listener on `Toaster.dismissRequested`. The exit is two-phase: the delegate fades itself first, then a short `exitTimer` removes the row from `Toaster._stack` — the staggering prevents other toasts from jumping abruptly.
- The loading spinner is just the public `P.Spinner` constrained to 20 × 20, `Tokens.mutedForeground`.
- The 4 static icons (`success` / `info` / `warning` / `error`) are painted by `PearlKit.internal.PearlToastIcon`, a 20 × 20 Canvas atom that mirrors the `PearlChevron` / `PearlXIcon` / `PearlCheckIcon` pattern — no SVG assets, no `QtSvg` plugin dependency.

## Deliberate divergences from Sonner

- **No swipe-to-dismiss** (mouse drag gesture). Deferred — desktop mouse gesture ergonomics differ from Sonner's touch-first design.
- **No remaining-time preservation** on hover resume. The Timer restarts from zero, which is acceptable for the pearl-kit interaction model but noticeably different from Sonner's exact behavior.
- **No `action` button inside the card**. Composition via `Toaster.dismiss(id)` plus an externally placed `Button` is sufficient for most pearl-kit call sites.
- **No `promise()` convenience API**. Callers sequence loading → success/error themselves via `Toaster.dismiss(loadingId)` + a new `Toaster.show()`.
- **No rich content slot**. The card is title + description only; custom markup is out of scope.
