# DetachableTabView

A tab view whose tabs can pop out into floating windows with a custom titlebar and re-dock on close. Pearl-kit-specific — shadcn/ui has no equivalent primitive. Built as a thin orchestrator over `TabBar` + a dynamic `FloatingWindow` dict, preserving each tab's content state across detach / re-dock cycles through a single-parent reparenting strategy.

Ships as three public components: `DetachableTabView` (the orchestrator), `DetachableTab` (declarative tab container), `FloatingWindow` (the frameless floating panel primitive). `FloatingWindow` is reusable standalone for any "pop out an Item into its own window" use case.

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

P.DetachableTabView {
    width: 800
    height: 500
    variant: "line"

    P.DetachableTab {
        title: "Home"
        stackKey: "home"
        permanent: true

        Rectangle { anchors.fill: parent; color: P.Tokens.card }
    }

    P.DetachableTab {
        title: "Viewer"
        stackKey: "viewer"

        Rectangle { anchors.fill: parent; color: P.Tokens.card }
    }

    P.DetachableTab {
        title: "Editor"
        stackKey: "editor"

        Rectangle { anchors.fill: parent; color: P.Tokens.card }
    }
}
```

Double-click any tab to detach it. The tab becomes a `FloatingWindow` at ~70 % of the host window's size, offset +50 / +50. Closing or docking the floating window brings the tab back.

## How content is preserved across detach / re-dock

Each `DetachableTab` is the stable parent of its content children. When a tab is detached, the `DetachableTab` Item itself is reparented from the internal host into the floating window's content area, carrying all its children with it. No `Loader` re-instantiation, no `Component.onCompleted` re-firing — running timers, scroll positions, selection state, anything stateful stays alive.

When docked back, the `DetachableTab` is reparented into the host again and made current.

## Tab modifiers

| Property | Effect |
|---|---|
| `permanent: true` | Tab cannot be detached. If somehow reparented (e.g. via manual `_dockItem` path), re-docks at index 0. Good for a "Home" / "Main" tab that must always stay in place. |
| `nonDetachable: true` | Tab cannot be detached. Unlike `permanent`, no special re-dock positioning. Good for "Settings" / system tabs that shouldn't be torn off. |
| `stackKey: "key"` | Named addressability — `detachTabByKey("viewer")`, `dockTabByKey("viewer")`, `tabByKey("viewer")` all dispatch on this. Also populates `currentKey` following the `StackedView` pattern. |
| `iconSource: url` | Optional 16 × 16 icon shown at the leading edge of the tab. |

## Detach triggers

Pearl-kit v1 supports one detach affordance:

- **Double-click a tab** — fires `T.AbstractButton.doubleClicked`, view calls `_detachItem(tab)` if not permanent / non-detachable.

Deliberately omitted from v1 (DALI's Python widget has all three; deferred to reduce v1 surface):

- Per-tab detach icon button (left-side ↗ arrow)
- Drag-to-detach (drag a tab > 40 px vertically)
- Right-click "Detach to Window" context menu

Consumers who need one of those today can compose it themselves — call `view.detachTabByKey(key)` from their own trigger.

## Floating window chrome

`FloatingWindow` is a frameless top-level `Window` with a 32 px custom titlebar:

- **Drag** the titlebar to move the window.
- **Double-click** the titlebar to toggle maximize / restore.
- **Dock** button (↓) — re-docks the tab, destroys the window.
- **Maximize** button (□) — toggles maximize / restore (same as double-click).
- **Close** button (×) — re-docks the tab (never destroys content). `close = dock` is DALI parity: a detached tab is never lost, only rehomed.
- Bottom-right corner has a 16 × 16 resize grip when not maximized.

The `onClosing` handler always intercepts native close attempts and emits `dockRequested()` instead — so even if the OS sends a close signal (e.g. Cmd-Q), the tab survives.

## Public API

### DetachableTabView

| Property | Type | Default | Description |
|---|---|---|---|
| `variant` | `string` | `"default"` | Passed through to the internal `TabBar`. `"default"` or `"line"`. |
| `currentIndex` | `int` | `0` | Index in the docked tabs (floating tabs are filtered out). |
| `currentKey` | `string` | `""` | Two-way synced with `currentIndex` via `stackKey` lookup — `StackedView` pattern. |
| `floatingCount` | `int` | `0` | Read-only. Number of tabs currently in floating windows. |
| `dockedCount` | `int` | — | Read-only. Number of tabs currently docked. |

Signals:

| Signal | Emitted when |
|---|---|
| `tabDetached(Item tab, string title)` | A tab has been moved to a floating window. |
| `tabRedocked(Item tab, string title)` | A floating tab has been moved back to the tab bar. |

Methods:

| Method | Description |
|---|---|
| `detachTab(index)` | Detach the docked tab at `index`. |
| `detachTabByKey(key)` | Detach the tab whose `stackKey === key`. |
| `dockTab(tab)` | Dock a currently-floating tab back. |
| `dockTabByKey(key)` | Dock by key. |
| `raiseFloating(tab)` | Raise the floating window of `tab` to the front. |
| `closeAllFloating()` | Dock every floating tab at once — for app-shutdown or "return to single-window mode" actions. |
| `tabAtIndex(index)` | Lookup helper. Returns the docked `DetachableTab` at `index` or `null`. |
| `tabByKey(key)` | Lookup helper. Returns the first `DetachableTab` whose `stackKey === key`. |
| `indexOfKey(key)` | Index lookup among docked tabs. `-1` if not found or floating. |

### DetachableTab

| Property | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | `""` | Label rendered in the tab button. Also the floating window's title. |
| `stackKey` | `string` | `""` | Unique key for `currentKey` routing and `*ByKey` methods. |
| `iconSource` | `url` | `""` | Optional 16 × 16 icon in the tab button. |
| `permanent` | `bool` | `false` | Cannot detach. |
| `nonDetachable` | `bool` | `false` | Cannot detach. |

Children declared inside a `DetachableTab` become its content. The `DetachableTab` itself is `anchors.fill: parent`, so content children can use `anchors.fill: parent` or a fill-parent `Layout`.

### FloatingWindow

Usable standalone for non-tab pop-out scenarios:

| Property | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | `""` | Rendered in the custom titlebar's leading label. |
| `content` | `Item` | `null` | Assigning an Item reparents it into the window's content area. |
| `minWidth` | `int` | `400` | Minimum drag-resize width. |
| `minHeight` | `int` | `300` | Minimum drag-resize height. |

Signals:

| Signal | Emitted when |
|---|---|
| `dockRequested()` | Dock / close button clicked, or OS close intercepted. Consumer is expected to either reparent `content` back and destroy the window, or dismiss the window in some other way. |
| `maximizeToggled()` | Maximize button clicked or titlebar double-clicked. |

## Under the hood

- `DetachableTabView` is a plain `Item` root (no `QtQuick.Templates` base) with a `ColumnLayout` containing `TabBar` + a host `Item`. Tab children land in the host via `default property alias _tabsContent: _host.data`.
- The tab strip is a `Repeater` over a `_dockedModel` list property, rebuilt manually on detach / dock. `TabButton.onDoubleClicked` triggers detach.
- Detach creates a `FloatingWindow` via `Qt.createObject` and sets `content = tab`. The `FloatingWindow.onContentChanged` handler reparents the `DetachableTab` to its internal content area.
- `Window.window` attached property is used to derive the host window for sizing / positioning the floating window (~70 % of host, offset +50 / +50) and setting `transientParent`.
- `dockTab` reverses the parent assignment — content goes back to the host, the floating window is closed and destroyed.
- `TabBar ⇔ currentIndex` synchronization uses the `StackedView` pattern — equality-guarded writeback handlers on both sides, gated by a `_ready` flag set in `Component.onCompleted`.

## Deliberate divergences from DALI's existing widget

pearl-kit's DetachableTabView ships a reduced feature set relative to airontgen's `ui/detachable_tab_widget.py`:

- **Detach triggers reduced to double-click only.** DALI adds a per-tab ↗ icon button, drag-to-detach, and right-click context menu. Pearl-kit v1 defers all three.
- **`FloatingWindow` is frameless with a custom titlebar.** DALI's `FloatingTabWindow` uses `Qt.WindowType.Window` with native OS chrome. The custom titlebar class exists in DALI but isn't wired into the floating window. Pearl-kit ships the custom chrome as the default since the user task explicitly asks for "custom titlebar (dock/maximize/close)".
- **No `replace_tab_widget` API.** DALI has a helper for swapping a tab's content in-place; pearl-kit consumers can reassign `DetachableTab` children directly.
- **No placeholder-aware wake logic.** DALI integrates with a `TabPlaceholder` + sleep manager; pearl-kit has neither primitive in kit.
- **No persistence.** DALI's widget doesn't persist either; this is a call-out.

## Deliberate divergences from shadcn

shadcn/ui has no detachable-tabs component. `DetachableTabView` is a pearl-kit original, documented as a non-shadcn extension driven by DALI's viewer / editor group call-sites.
