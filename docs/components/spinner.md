# Spinner

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=spinner"
        title="Live Spinner demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/spinner)'s Spinner. A small indeterminate indicator for inline loading states — a 3/4 circle arc that rotates continuously.

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

Row {
    spacing: 8
    P.Spinner { anchors.verticalCenter: parent.verticalCenter }
    P.PearlText {
        text: "Loading..."
        variant: "muted"
        anchors.verticalCenter: parent.verticalCenter
    }
}
```

## Basic usage

```qml
P.Spinner { }
```

The default is 16 × 16 — shadcn's `size-4`. Spins continuously at 1 revolution per second.

## Sizing

Spinner has no size scale. To change the size, set `width` / `height` directly:

```qml
P.Spinner { width: 12; height: 12 }   // 12 px — tightest inline
P.Spinner { }                          // 16 px — default (shadcn size-4)
P.Spinner { width: 20; height: 20 }   // 20 px — matches size-5
P.Spinner { width: 24; height: 24 }   // 24 px — matches size-6
P.Spinner { width: 32; height: 32; strokeWidth: 3 }  // scale the stroke too
```

For anything larger than ~20 px, consider increasing `strokeWidth` proportionally so the arc doesn't look too thin.

## Color

Spinner defaults to `Tokens.mutedForeground` — the conventional "loading" UX read — but accepts any color:

```qml
P.Spinner { color: P.Tokens.primary }
P.Spinner { color: P.Tokens.destructive }
P.Spinner { color: P.Tokens.foreground }
P.Spinner { color: "#22c55e" }
```

When used inside a `Button`, match the button's foreground:

```qml
P.Button {
    text: "Saving..."
    enabled: false
    leftPadding: 32
    P.Spinner {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12
        color: P.Tokens.primaryForeground
    }
}
```

## Pausing

Bind `running` to your state flag to pause the spin (useful when the work is stale or the UI is frozen for another reason):

```qml
P.Spinner { running: job.active }
```

When `running` flips back to `true`, the spinner restarts from 0°.

## Animation duration

The default 1 s per rotation matches shadcn's `animate-spin`. Override for a faster or slower feel:

```qml
P.Spinner { duration: 500 }   // 2× faster
P.Spinner { duration: 1800 }  // slower, more meditative
```

## Property reference

| Property | Type | Default | Description |
|---|---|---|---|
| `color` | `color` | `Tokens.mutedForeground` | Arc stroke color. Theme changes propagate automatically. |
| `strokeWidth` | `real` | `2` | Arc stroke width in pixels. |
| `running` | `bool` | `true` | When `false`, the rotation is paused (the arc stays visible at its current angle). |
| `duration` | `int` | `1000` | Milliseconds for a full 360° rotation. |
| `width` / `height` | `int` | `implicitWidth/Height: 16` | Override to resize. Spinner is square by default. |

## Accessibility

Spinner exposes itself as `Accessible.Indicator` with `Accessible.name: "Loading"`. Screen readers announce it as a status indicator. When pairing with visible text (recommended), the text is what users will actually read — use Spinner for the *visual* state, and let surrounding labels carry the message.

```qml
Row {
    spacing: 8
    P.Spinner { anchors.verticalCenter: parent.verticalCenter }
    P.PearlText {
        text: "Uploading 3 of 7..."
        variant: "muted"
        anchors.verticalCenter: parent.verticalCenter
    }
}
```

## Under the hood

Spinner is a plain `Item` wrapping a `Canvas`. The Canvas draws a 270° arc starting at the top (−π/2), with round line caps. Rotation is applied to the Canvas via a `RotationAnimator` — an `Animator`, not a `NumberAnimation`, so the rotation runs on the scenegraph thread without costing a main-thread tick per frame. The Canvas itself paints once and is re-used across all frames; only the transform changes.

Color and `strokeWidth` changes trigger a `requestPaint()` via `Connections`, so swapping the theme (`Tokens.mode = Tokens.DarkBlue`) or overriding `color` at runtime re-renders the arc cleanly.

When the Spinner becomes invisible (`visible: false`, parent collapsed, etc.), the animator pauses automatically — `running: control.running && control.visible` — so hidden spinners don't burn scenegraph time.

## Deliberate divergences from shadcn

- **Arc sweep is 270°** (a clean 3/4 circle). shadcn uses lucide's `Loader2Icon` path, which sweeps ~288°. The visual difference at 16–24 px is imperceptible, and 270° is cleaner geometrically.
- **`running` property exposed.** shadcn spins unconditionally. pearl-kit lets you pause for stale/frozen states.
- **`duration` property exposed.** shadcn hard-codes 1 s via `animate-spin`. pearl-kit makes it adjustable.
- **Explicit `color` property.** shadcn uses CSS `currentColor` (inherits from text). QML has no equivalent inheritance, so the color is passed explicitly; the default (`Tokens.mutedForeground`) matches the typical "loading" read.
