# StackedView

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=stacked-view"
        title="Live StackedView demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A layout primitive that shows exactly one of its children at a time — the "content host" half of the classic Sidebar / Tabs + pane pattern. Children stay alive across switches, so their local state (scroll position, input focus, form data) survives every navigation.

`StackedView` is pearl-kit-specific — shadcn/ui has no direct equivalent (its React `Tabs` primitive couples the trigger UI and the pane host into a single tree). pearl-kit splits them so any trigger shape — a Sidebar, a TabBar, a command palette, a programmatic state machine — can drive the same pane host.

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
import QtQuick.Layouts
import PearlKit 1.0 as P

RowLayout {
    // sidebar
    ColumnLayout {
        Layout.alignment: Qt.AlignTop
        spacing: 4
        P.Button {
            text: "Home"
            onClicked: stack.currentIndex = 0
            variant: stack.currentIndex === 0 ? "secondary" : "ghost"
        }
        P.Button {
            text: "Settings"
            onClicked: stack.currentIndex = 1
            variant: stack.currentIndex === 1 ? "secondary" : "ghost"
        }
    }

    // content host
    P.StackedView {
        id: stack
        Layout.fillWidth: true
        Layout.fillHeight: true

        Rectangle { color: P.Tokens.card }   // home pane
        Rectangle { color: P.Tokens.muted }  // settings pane
    }
}
```

The `QtQuick.Layouts` import is mandatory — `StackedView` is a `StackLayout` subclass and its direct children participate in layout sizing (`Layout.fillWidth`, `Layout.preferredHeight`, etc.).

## Index-based switching

Bind `currentIndex` from any trigger source. The default is `0`, so the first child is shown on load.

```qml
P.StackedView {
    id: stack
    currentIndex: selectedTab   // any external state
    Rectangle { color: "red" }
    Rectangle { color: "green" }
    Rectangle { color: "blue" }
}
```

Setting `currentIndex` to a value outside `[0, count)` is a no-op — no exception, no crash, the previous selection stays visible. This matches `QtQuick.Layouts.StackLayout`'s native safety contract.

## Key-based switching

Assign each pane a `property string stackKey` and drive the stack by name instead of position:

```qml
P.StackedView {
    id: stack
    currentKey: "settings"

    Rectangle { property string stackKey: "home";     color: "red" }
    Rectangle { property string stackKey: "settings"; color: "green" }
    Rectangle { property string stackKey: "about";    color: "blue" }
}

// later, from anywhere:
stack.currentKey = "about"
```

`currentKey` and `currentIndex` stay in two-way sync. Assigning either one updates the other. Reading `currentKey` always returns the `stackKey` of the currently-visible child — if a pane has no `stackKey`, the property reads as `""`.

Assigning an unknown key is a soft no-op: the assignment takes hold briefly but the initial-sync step (and any subsequent `currentIndex` change) snaps it back to the actual visible child's key. Use this to detect misses by reading back:

```qml
stack.currentKey = "ghost"
if (stack.currentKey !== "ghost") {
    // key wasn't found; stack is still on the previous pane
}
```

Mixing keyed and un-keyed children is allowed — children without a `stackKey` simply can't be reached by key assignment, only by index.

## Cross-fade transition

By default pane switches are instant — `animated: false` matches shadcn Tabs and the VS Code pane-switch idiom. Set `animated: true` for a 150 ms opacity fade-in on the incoming pane:

```qml
P.StackedView {
    animated: true
    currentKey: "inbox"

    Rectangle { property string stackKey: "inbox" }
    Rectangle { property string stackKey: "sent" }
}
```

The fade runs at `Tokens.motion.fast` with `Easing.OutCubic` — the same timing as Button's color transitions and Toggle's thumb travel, for a consistent motion language across the kit.

Only the incoming pane animates. The outgoing pane snaps to invisible instantly, which is what `StackLayout`'s visibility semantics enforce — mirrors shadcn's `data-[state=active]:animate-in` + `data-[state=inactive]:hidden` pattern (no "fade-out" on the exiting pane).

## Composition with other pearl-kit primitives

### Pair with `Splitter` for resizable sidebar layouts

```qml
P.Splitter {
    anchors.fill: parent

    // navigator
    P.ScrollArea {
        SplitView.preferredWidth: 200
        SplitView.minimumWidth: 120

        ColumnLayout {
            // sidebar items drive stack.currentKey...
        }
    }

    // content host
    P.StackedView {
        id: stack
        SplitView.fillWidth: true
        animated: true

        Item { property string stackKey: "files" }
        Item { property string stackKey: "search" }
        Item { property string stackKey: "git" }
    }
}
```

### Pair with `TabBar` for top-aligned trigger UI

```qml
ColumnLayout {
    P.TabBar {
        Layout.fillWidth: true
        currentIndex: stack.currentIndex
        onCurrentIndexChanged: stack.currentIndex = currentIndex

        P.TabButton { text: "Overview" }
        P.TabButton { text: "Analytics" }
        P.TabButton { text: "Reports" }
    }

    P.StackedView {
        id: stack
        Layout.fillWidth: true
        Layout.fillHeight: true

        // three panes, any content
    }
}
```

## State preservation

Unlike imperative `Loader` / re-creation patterns, `StackedView` keeps every child alive at all times. Each pane's internal state survives every switch:

- Scroll positions inside `ScrollArea` panes
- Focus and caret position in `Input` / `TextArea` fields
- Expansion state of `GroupBox` sections
- In-flight animations and timers
- Any `property` you declared on the child

This is the single most important behavioral difference from a conditional-render approach — "without unmounting" is the literal implementation.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `currentIndex` | `int` | `0` | Zero-based index of the visible child. Out-of-range values are no-ops. Inherited from `QtQuick.Layouts.StackLayout`. |
| `currentKey` | `string` | `""` | Reflects the visible child's `stackKey`. Assigning updates `currentIndex`. Unknown keys are soft no-ops. |
| `animated` | `bool` | `false` | If `true`, incoming panes fade in over 150 ms. If `false`, pane switches are instant. |

## Method reference

| Method | Returns | Description |
|---|---|---|
| `indexOfKey(key)` | `int` | Returns the index of the first child whose `stackKey` equals `key`, or `-1` if none match. Used internally to implement `currentKey`. |

## Child contract

Any direct `Item`-descended child counts as a pane. To participate in key-based switching, a child declares:

```qml
Item {
    property string stackKey: "my-pane-name"
    // ...pane content
}
```

A child's layout sizing uses the normal `Layout.*` attached properties inherited from `StackLayout` (`Layout.fillWidth`, `Layout.preferredHeight`, `Layout.minimumWidth`, etc.). When a pane is not the current one, `StackLayout` hides it via `visible: false` — its layout contribution is ignored until it becomes current.

## Under the hood

`StackedView` is a `QtQuick.Layouts.StackLayout` subclass with two added properties (`animated`, `currentKey`), one helper function (`indexOfKey`), and a tiny state machine that keeps `currentKey` and `currentIndex` in sync.

The state machine uses a `_ready` flag set during `Component.onCompleted` to gate the key ↔ index binding loop — without it, `StackLayout`'s internal `currentIndex` initialization fires `onCurrentIndexChanged` during construction, which would overwrite a consumer-supplied initial `currentKey` before the children are fully parsed. Guarding both change handlers behind `_ready` makes construction behave as "set whatever the consumer wrote, then start syncing." The `Component.onCompleted` block first resolves `currentKey` → `currentIndex` (if the consumer wrote a key), then flips `_ready = true`, then calls `_syncKeyFromIndex()` so the initial `currentKey` is always authoritative from the visible child.

The cross-fade uses a single shared `NumberAnimation { id: _fadeAnim }` whose `target` is reassigned on each index change — cheaper than declaring one animation per child. The outgoing pane receives no fade because `StackLayout` snaps `visible: false` on it instantly; attempting to animate the outgoing opacity first would require overriding `StackLayout`'s visibility management and introducing a custom layout loop, which is out of scope for a kit-level primitive.

Deliberate divergences from shadcn / other UI kits:

- **No shadcn parity** — shadcn composes pane content inline inside `TabsContent` nested under a `Tabs` root with implicit context. pearl-kit splits the trigger and pane host so any trigger UI can drive any pane host; the primitives don't share a provider / context component.
- **Key semantics** — `currentKey` is a pearl-kit extension for named routing. React patterns typically use a `value` prop on the parent and compare against each pane's `value`; pearl-kit surfaces this as a QML property on each child for ergonomic string-based switching.
- **Fade-only transition** — no slide, no scale, no direction-aware transition. A bi-directional slide (left when going forward, right when going back) would require tracking switch direction and introduces edge cases for wrap-around and programmatic non-adjacent jumps. Fade is direction-agnostic and composes cleanly.
- **No built-in chrome** — no background, no border, no padding. `StackedView` is a pure content host. Pair it with `Card` or a plain `Rectangle` if you need visible bounds.
