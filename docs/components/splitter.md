# Splitter

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=splitter"
        title="Live Splitter demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/resizable)'s Resizable — two or more panes with a draggable handle between them, horizontal or vertical orientation, and built-in size persistence.

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
import QtQuick.Controls                  // required for SplitView.* attached properties
import PearlKit 1.0 as P

P.Splitter {
    width: 600
    height: 400

    Rectangle {
        SplitView.preferredWidth: 180
        SplitView.minimumWidth: 80
        color: "#20202a"
    }
    Rectangle {
        SplitView.fillWidth: true
        color: "#2a2a34"
    }
    Rectangle {
        SplitView.preferredWidth: 140
        color: "#20202a"
    }
}
```

The `QtQuick.Controls` import is mandatory — `SplitView.preferredWidth`, `SplitView.fillWidth`, and the rest of the size-hint attached properties live in that module, not in `PearlKit`.

## Orientation

`orientation: Qt.Horizontal` (default) lays panels side by side with vertical hairline handles between them. `orientation: Qt.Vertical` stacks panels with horizontal handles.

```qml
P.Splitter {
    orientation: Qt.Vertical
    width: 400; height: 400

    Rectangle { SplitView.preferredHeight: 160; color: "#20202a" }
    Rectangle { SplitView.fillHeight: true;     color: "#2a2a34" }
}
```

## Handle styling

The default handle is a 1 px hairline in `Tokens.border`, centered inside a 6 px drag-hit area. On hover or drag, the hairline transitions to `Tokens.ring @ 60 %` alpha over 150 ms — VS Code / IDE-style feedback without shadcn's bare default.

Set `withHandle: true` to add a centered 16 × 12 grip rectangle with three dots — useful when the handle needs to be obviously grabbable (media players, photo editors).

```qml
P.Splitter {
    withHandle: true
    orientation: Qt.Vertical

    Rectangle { SplitView.fillHeight: true }
    Rectangle { SplitView.preferredHeight: 120 }
}
```

## Size persistence

`Splitter` exposes two convenience methods that wrap Qt's native `saveState()` / `restoreState()`:

| Method | Returns | Purpose |
|---|---|---|
| `saveLayout()` | `QByteArray` | Serialize current handle positions |
| `restoreLayout(state)` | `bool` | Apply a previously saved state; returns `true` on success |

A typical persistence pattern with Qt's `Settings`:

```qml
import Qt.labs.settings

P.Splitter {
    id: editorSplitter
    width: parent.width; height: parent.height

    Rectangle { SplitView.preferredWidth: 220 }
    Rectangle { SplitView.fillWidth: true }

    Settings {
        property alias state: editorSplitter.layoutState
    }

    property var layoutState: null
    onLayoutStateChanged: if (layoutState) restoreLayout(layoutState)

    Component.onCompleted: {
        if (layoutState) restoreLayout(layoutState)
    }
    Component.onDestruction: {
        layoutState = saveLayout()
    }
}
```

`saveState()` / `restoreState()` from the underlying `T.SplitView` stay accessible if you prefer the native names.

### Caveats

- Restore is a silent no-op when the child count at restore time does not match the child count at save time. If panels are added or removed dynamically, rekey the saved state per configuration.
- An orientation flip invalidates saved state — `preferredWidth` / `preferredHeight` are orientation-specific. Save and restore under a key that includes `orientation` if the orientation is user-switchable.
- Each nested `Splitter` saves and restores independently. A top-level `saveLayout()` does not recurse; walk the tree yourself.

## Nested splitters

`Splitter` nests arbitrarily for VS Code-style group layouts:

```qml
P.Splitter {
    width: 800; height: 500

    Rectangle { SplitView.preferredWidth: 200 }   // file tree

    P.Splitter {
        orientation: Qt.Vertical
        SplitView.fillWidth: true                  // inner gets the remaining width

        Rectangle { SplitView.fillHeight: true }   // editor
        Rectangle { SplitView.preferredHeight: 160 } // terminal
    }
}
```

Always give the inner `Splitter` a size hint (`SplitView.fillWidth` / `fillHeight` / `preferredWidth` / `preferredHeight`) — without one it collapses to 0 on that axis.

## Attached size hints

These come from `QtQuick.Controls.SplitView` and apply to each direct child of the `Splitter`:

| Attached property | Type | Purpose |
|---|---|---|
| `SplitView.preferredWidth` | `real` | Initial width (horizontal orientation) |
| `SplitView.preferredHeight` | `real` | Initial height (vertical orientation) |
| `SplitView.minimumWidth` / `minimumHeight` | `real` | Drag floor |
| `SplitView.maximumWidth` / `maximumHeight` | `real` | Drag ceiling |
| `SplitView.fillWidth` / `fillHeight` | `bool` | Pane absorbs extra space (at most one per axis) |

## States

| State | Trigger | Visual |
|---|---|---|
| Default | idle | 1 px line, `Tokens.border` |
| Hover | pointer over the 6 px hit area | Line transitions to `Tokens.ring @ 60 %` |
| Pressed (dragging) | mouse down | Same as hover; cursor becomes `SplitHCursor` / `SplitVCursor` |
| Focus (keyboard) | Tab to handle | 3 px ring at `Tokens.ring / 50 %`, flush to handle |
| Disabled | `enabled: false` on the Splitter | Line fades to 50 % alpha, drag disabled |

Arrow-key resizing of a focused handle is native `T.SplitView` behavior — no extra wiring.

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `orientation` | `Qt.Orientation` | `Qt.Horizontal` | `Qt.Horizontal` (side-by-side panes) or `Qt.Vertical` (stacked panes) |
| `withHandle` | `bool` | `false` | Show a 16 × 12 grip rectangle with three dots on each handle |

## Method reference

| Method | Returns | Description |
|---|---|---|
| `saveLayout()` | `QByteArray` | Serialize current handle positions |
| `restoreLayout(state)` | `bool` | Apply a previously saved state |
| `saveState()` | `QByteArray` | Native `T.SplitView` method — identical to `saveLayout()` |
| `restoreState(state)` | `bool` | Native `T.SplitView` method — identical to `restoreLayout()` |

## Accessibility

Handles receive keyboard focus via Tab. When focused, left/right (horizontal) or up/down (vertical) arrow keys resize in 1-pixel increments; Home / End snap to the minimum / maximum. Screen-readers see each handle with the role `Splitter`, native to `T.SplitView`.

## Under the hood

`Splitter` is a `QtQuick.Templates.SplitView` with a custom `handle: Item` delegate and two passthrough convenience methods (`saveLayout` / `restoreLayout`). The delegate implements shadcn's 1 px-visible + multi-pixel-hit pattern as a 6 px `Item` with a centered 1 px `Rectangle` child — hit-testing uses the outer Item's implicit size, visual rendering uses the inner Rectangle. `T.SplitHandle.pressed` and `T.SplitHandle.hovered` attached properties drive the hover-color ternary.

Orientation inside the handle delegate is read as `control.orientation === Qt.Horizontal`, referencing the outer `T.SplitView` by id — the canonical Qt pattern (the `T.SplitView.view` attached property only resolves on direct children, not on handle delegates, so an id reference is the reliable approach).

Cursor shape is overridden via an interior `MouseArea` with `acceptedButtons: Qt.NoButton` — this preserves Qt's native drag handling while letting us swap `Qt.SplitHCursor` for `Qt.SplitVCursor` based on orientation. Pressing a button on that `MouseArea` is explicitly rejected so the drag events continue to reach the `T.SplitView` drag implementation.

Focus ring targets the handle delegate root, not the outer `SplitView`, so Tab-navigation between handles gives per-handle feedback. The ring uses pearl-kit's standard 3 px @ `ring / 50 %` geometry (`offset: 0`) rather than shadcn's literal `ring-1 ring-offset-1` — a deliberate divergence to stay consistent with Button, Input, Toggle, and the rest of the kit.

Deliberate divergences from shadcn:

- **Hover tint** — shadcn's default `ResizableHandle` class uses `bg-border` with no explicit hover color. `Splitter` transitions to `Tokens.ring @ 60 %` on hover and drag, matching the VS Code / Qt Creator / Xcode pattern. The user-facing interaction is noticeably different without it.
- **Focus ring geometry** — shadcn uses `ring-1 ring-offset-1` specifically on the resizable handle. `Splitter` uses pearl-kit's standard 3 px / offset 0 for intra-kit consistency.
- **Handle hit area** — shadcn's 1 px visible + 4 px hit. `Splitter` uses 1 px visible + 6 px hit, slightly more generous for touch-screen Macs and imprecise pointers.
