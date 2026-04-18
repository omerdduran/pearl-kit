# TabBar

<!-- pearl-demo:start -->
<iframe class="pearl-demo"
        src="../../wasm/pearl_kit_gallery.html?demo=tabbar"
        title="Live TabBar demo"
        loading="lazy"
        width="100%" height="460"
        style="border:1px solid var(--md-default-fg-color--lightest);border-radius:8px;background:transparent;margin:16px 0 24px 0;"></iframe>
<!-- pearl-demo:end -->

A pixel-accurate port of [shadcn/ui](https://ui.shadcn.com/docs/components/tabs)'s Tabs — ships as two public components (`TabBar` + `TabButton`) with pearl-kit extensions for document-mode styling, closable tabs, and content-sized tab strips.

`TabBar` styles shadcn's `TabsList`, `TabButton` styles shadcn's `TabsTrigger`. Content-panel switching is left to the consumer via `StackLayout { currentIndex: tabBar.currentIndex }` — the Qt idiom, no equivalent to React's `TabsContent` is needed.

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

ColumnLayout {
    P.TabBar {
        id: tabs
        P.TabButton { text: "Overview" }
        P.TabButton { text: "Analytics" }
        P.TabButton { text: "Reports" }
    }
    StackLayout {
        currentIndex: tabs.currentIndex
        // one child per tab — each becomes a panel
    }
}
```

## Variants

```qml
// default — shadcn bg-muted pill strip, rounded-lg, active trigger gets bg-background + subtle shadow
P.TabBar {
    variant: "default"
    P.TabButton { text: "One" }
    P.TabButton { text: "Two" }
}

// line — document-mode: transparent strip, 1 px bottom hairline, active trigger gets 2 px underline
P.TabBar {
    variant: "line"
    P.TabButton { text: "Code" }
    P.TabButton { text: "Issues" }
}
```

| Variant | Surface | Active indicator |
|---|---|---|
| `"default"` | `Tokens.muted` pill, 8 px radius, 3 px inner padding | `Tokens.background` fill on active trigger + 1 px subtle shadow |
| `"line"` | transparent, 1 px bottom hairline in `Tokens.border` | 2 px underline at `Tokens.foreground` |

## Expanding vs content-sized

By default `TabBar` matches shadcn's `flex-1` behavior — tabs stretch to equal widths across the strip. For editor-style "document tabs" where each tab is sized to its label, set `expanding: false`.

```qml
// Content-sized (document tabs)
P.TabBar {
    variant: "line"
    expanding: false
    P.TabButton { text: "report.pdf";       closable: true }
    P.TabButton { text: "untitled-1.txt";   closable: true }
    P.TabButton { text: "implant-plan.dali"; closable: true }
}
```

## Closable tabs

Set `closable: true` on a `TabButton` to append a small × icon. Clicking × emits `closeRequested()` without triggering a tab switch.

```qml
P.TabButton {
    text: "report.pdf"
    closable: true
    onCloseRequested: {
        // remove this tab from your model
    }
}
```

The close icon is rendered via the internal `PearlXIcon` Canvas atom — no SVG asset, no `QtSvg` dependency.

## Icon slot

```qml
P.TabButton {
    text: "Home"
    iconSource: "qrc:/icons/home.svg"
}
```

Icons are 16 × 16, `Image.PreserveAspectFit`, and rasterized at final size (`sourceSize: Qt.size(16, 16)`). `iconSource` is a `url` property — supports `qrc:`, `file:`, and `http(s)` schemes like any Qt Image.

## States

| State | Trigger | Visual |
|---|---|---|
| Idle | — | text at `Tokens.foreground @ 60%` |
| Hover | pointer over | text fades to `Tokens.foreground @ 100%` |
| Active | `checked === true` (auto-bound to `TabBar.currentIndex`) | default: `bg-background` fill; line: 2 px underline |
| Focus (keyboard) | Tab navigation | 3 px ring at `Tokens.ring @ 50%` (keyboard-only via `visualFocus`) |
| Disabled | `enabled: false` on TabBar or TabButton | 50 % opacity on background and contentItem |

Keyboard navigation inside a `TabBar` uses Qt's native T.TabBar handlers — Left / Right / Home / End move the current index without custom `Keys.on*` wiring.

## Property reference

### TabBar

| Property | Type | Default | Description |
|---|---|---|---|
| `variant` | `string` | `"default"` | `"default"` (shadcn filled pill) \| `"line"` (document-mode underline) |
| `expanding` | `bool` | `true` | When `true`, tabs share width equally (shadcn `flex-1`). When `false`, each tab is sized to its contents. |
| `currentIndex` | `int` | `0` | Inherited from `T.TabBar`. Writable. |
| `count` | `int` | — | Inherited from `T.TabBar`. Number of TabButton children. |

### TabButton

| Property | Type | Default | Description |
|---|---|---|---|
| `text` | `string` | `""` | Tab label. Rendered as `PearlBaseText` with `font-medium`. |
| `iconSource` | `url` | `""` | Optional 16 × 16 icon rendered at the leading edge of the content row. |
| `closable` | `bool` | `false` | When `true`, renders a trailing 12 × 12 × button that emits `closeRequested()` on click. |
| `checked` | `bool` | — | Inherited from `T.TabButton`. Auto-bound to `TabBar.currentIndex === myIndex`. |
| `signal closeRequested()` | — | — | Emitted when the user clicks the × button. Does not trigger a tab switch. |

## Accessibility

`T.TabBar` + `T.TabButton` inherit Qt's accessibility pipeline — each TabButton has `Accessible.role: Accessible.PageTab` and participates in the focus ring of the bar. The close × button has its own `MouseArea` but no independent `Accessible` role — consumers who need screen-reader announcement for "Close tab" should add `Accessible.name: "Close"` on the button explicitly via QML-side override.

## Under the hood

- `TabBar` is a `QtQuick.Templates.TabBar` with custom `background` (variant-aware `Tokens.muted` pill or transparent strip with bottom hairline) and preserved default `contentItem` (`ListView` over `contentModel`) so flicking, `currentIndex` tracking, and keyboard nav all work natively.
- `TabButton` is a `QtQuick.Templates.TabButton` with full overrides:
  - `background` handles the per-variant active surface and the line-variant underline
  - `contentItem` is a `Row` of icon + `PearlBaseText` label + optional close × via `PearlXIcon`
  - Close button uses a sibling `MouseArea` with `preventStealing: true` + `ev.accepted = true` to intercept clicks without propagating to the TabButton's click handler
  - Focus ring uses the standard `PearlFocusRing` atom at 3 px, `ring@50%`, `offset: 0`, keyboard-only via `visualFocus`

## Deliberate divergences from shadcn

- **Two components instead of four.** shadcn ships `Tabs`, `TabsList`, `TabsTrigger`, `TabsContent`. Qt's `T.TabBar` self-manages `currentIndex`, and `StackLayout` is the idiomatic content switcher — both the `Tabs` root and `TabsContent` wrapper are unnecessary in QML.
- **`closable: bool` on `TabButton`** — not in shadcn. Driven by editor-style call sites (open documents, implant plans, editable annotations) that need a one-click × affordance.
- **`expanding: bool` on `TabBar`** — shadcn always uses `flex-1`. Pearl-kit defaults to `true` (parity) but exposes `false` for content-sized tabs.
- **Line variant underline flush at bottom** instead of shadcn's `bottom-[-5px]` offset. shadcn's 5 px overhang relies on CSS overflow; pearl-kit's 36 px strip has no overflow context, so the underline sits flush against the bar's bottom hairline for a clean document-mode look.
- **Horizontal-only.** Vertical tab bars deferred to v0.4.x+ (shadcn supports both via `orientation` prop, but the DALI call sites are all horizontal).
- **No drag-to-reorder.** Not in shadcn either; would require custom drag state machinery that's out of scope for v1.
