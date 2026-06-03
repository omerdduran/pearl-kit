pragma Singleton
import QtQuick

QtObject {
    id: root

    enum Mode { Dark, DarkBlue, Light }
    property int mode: Tokens.Light

    readonly property bool isLight: mode === Tokens.Light

    // ---- palette tables (index by mode: Dark=0, DarkBlue=1, Light=2)
    // Mutable so downstream consumers (e.g. DALI) can override palettes at
    // runtime via applyColors(palette). Treat as private — mutate via the
    // applyColors() API, never assign these properties directly.
    property var _bg:             ["#111111","#141822","#F5F6F8"]
    property var _fg:             ["#E8E8E8","#E8ECF4","#1E293B"]
    property var _muted:          ["#242424","#232942","#F0F1F4"]
    property var _mutedFg:        ["#999999","#9AACC4","#64748B"]
    property var _card:           ["#1A1A1A","#1B2033","#FFFFFF"]
    property var _cardFg:         ["#E8E8E8","#E8ECF4","#1E293B"]
    property var _popover:        ["#222222","#273050","#FFFFFF"]
    property var _popoverFg:      ["#E8E8E8","#E8ECF4","#1E293B"]
    property var _primary:        ["#3B82F6","#4B92FF","#2563EB"]
    property var _primaryFg:      ["#FFFFFF","#FFFFFF","#FFFFFF"]
    property var _secondary:      ["#A78BFA","#B49CFF","#7C3AED"]
    property var _secondaryFg:    ["#FFFFFF","#FFFFFF","#FFFFFF"]
    property var _accent:         ["#3A3A3A","#2A4A7A","#DBEAFE"]
    property var _accentFg:       ["#E8E8E8","#E8ECF4","#1E293B"]
    property var _destructive:    ["#EF4444","#EF4444","#DC2626"]
    property var _destructiveFg:  ["#FFFFFF","#FFFFFF","#FFFFFF"]
    property var _success:        ["#22C55E","#22C55E","#16A34A"]
    property var _warning:        ["#F59E0B","#F59E0B","#D97706"]
    property var _border:         ["#2A2A2A","#283050","#E2E5EA"]
    property var _input:          ["#242424","#232942","#F0F1F4"]
    property var _ring:           ["#3B82F6","#4B92FF","#3B82F6"]
    property var _elev0:          ["#111111","#141822","#F5F6F8"]
    property var _elev1:          ["#1A1A1A","#1B2033","#FFFFFF"]
    property var _elev2:          ["#242424","#232942","#F0F1F4"]
    property var _elev3:          ["#222222","#273050","#FFFFFF"]

    function _c(t) { return t[mode] }

    // ---- runtime palette override (downstream consumer hook)
    // Pass an object with the palette table names as keys; each value is a
    // 3-element array indexed by mode (Dark=0, DarkBlue=1, Light=2). Unspecified
    // tables keep their defaults. All bound `background`/`primary`/etc. colors
    // re-evaluate automatically since they bind through _c(_<table>).
    //
    //     Tokens.applyColors({ _primary: ["#3B82F6","#4B92FF","#2563EB"], ... })
    //
    // Stage 1 of pearl-kit's JSON-driven theming refactor — sub-objects
    // (radius/space/font/shadow/motion) remain readonly until Stage 2.
    function applyColors(palette) {
        if (!palette) return;
        if (palette._bg)            _bg            = palette._bg;
        if (palette._fg)            _fg            = palette._fg;
        if (palette._muted)         _muted         = palette._muted;
        if (palette._mutedFg)       _mutedFg       = palette._mutedFg;
        if (palette._card)          _card          = palette._card;
        if (palette._cardFg)        _cardFg        = palette._cardFg;
        if (palette._popover)       _popover       = palette._popover;
        if (palette._popoverFg)     _popoverFg     = palette._popoverFg;
        if (palette._primary)       _primary       = palette._primary;
        if (palette._primaryFg)     _primaryFg     = palette._primaryFg;
        if (palette._secondary)     _secondary     = palette._secondary;
        if (palette._secondaryFg)   _secondaryFg   = palette._secondaryFg;
        if (palette._accent)        _accent        = palette._accent;
        if (palette._accentFg)      _accentFg      = palette._accentFg;
        if (palette._destructive)   _destructive   = palette._destructive;
        if (palette._destructiveFg) _destructiveFg = palette._destructiveFg;
        if (palette._success)       _success       = palette._success;
        if (palette._warning)       _warning       = palette._warning;
        if (palette._border)        _border        = palette._border;
        if (palette._input)         _input         = palette._input;
        if (palette._ring)          _ring          = palette._ring;
        if (palette._elev0)         _elev0         = palette._elev0;
        if (palette._elev1)         _elev1         = palette._elev1;
        if (palette._elev2)         _elev2         = palette._elev2;
        if (palette._elev3)         _elev3         = palette._elev3;
    }

    readonly property color background:             _c(_bg)
    readonly property color foreground:             _c(_fg)
    readonly property color muted:                  _c(_muted)
    readonly property color mutedForeground:        _c(_mutedFg)
    readonly property color card:                   _c(_card)
    readonly property color cardForeground:         _c(_cardFg)
    readonly property color popover:                _c(_popover)
    readonly property color popoverForeground:      _c(_popoverFg)
    readonly property color primary:                _c(_primary)
    readonly property color primaryForeground:      _c(_primaryFg)
    readonly property color secondary:              _c(_secondary)
    readonly property color secondaryForeground:    _c(_secondaryFg)
    readonly property color accent:                 _c(_accent)
    readonly property color accentForeground:       _c(_accentFg)
    readonly property color destructive:            _c(_destructive)
    readonly property color destructiveForeground:  _c(_destructiveFg)
    readonly property color success:                _c(_success)
    readonly property color warning:                _c(_warning)
    readonly property color border:                 _c(_border)
    readonly property color input:                  _c(_input)
    readonly property color ring:                   _c(_ring)
    readonly property color elevation0:             _c(_elev0)
    readonly property color elevation1:             _c(_elev1)
    readonly property color elevation2:             _c(_elev2)
    readonly property color elevation3:             _c(_elev3)

    // ---- radius / space / font / shadow / motion
    // Stage 2 of the JSON-driven theming refactor: these are now plain JS
    // objects (was: nested `QtObject` children with readonly fields). Existing
    // dot-access (`Tokens.radius.md`, `Tokens.space.x4`, `Tokens.font.size.sm`)
    // is unchanged. Reactivity contract: bindings re-evaluate when the WHOLE
    // sub-object is reassigned. `applyTheme()` always reassigns via
    // `Object.assign({}, current, override)`, so consumers must NEVER mutate
    // an inner field directly — always go through `applyTheme()` (or assign
    // a new object literal to the sub-property).
    property var radius: ({
        sm:   4,
        md:   6,
        lg:   8,
        xl:  12,
        full: 9999
    })

    property var space: ({
        x0:  0,
        x1:  4,
        x2:  8,
        x3: 12,
        x4: 16,
        x5: 20,
        x6: 24,
        x8: 32,
        x10: 40,
        x12: 48
    })

    property var font: ({
        ui:   "SF Pro Display",
        mono: "SF Mono",
        size: {
            xs:  12,
            sm:  14,
            md:  16,
            lg:  18,
            xl:  20,
            xxl: 24,
            // display / hero rungs — large titles & splash headings above the
            // body scale (consumed by downstream apps; exact values, no rounding).
            xxxl:      28,
            display:   30,
            displayLg: 36,
            hero:      44,
            heroLg:    48
        },
        weight: {
            regular:  Font.Normal,
            medium:   Font.Medium,
            semibold: Font.DemiBold,
            bold:     Font.Bold
        }
    })

    property var shadow: ({
        sm1: Qt.rgba(0, 0, 0, 0.10),
        sm2: Qt.rgba(0, 0, 0, 0.06),
        md1: Qt.rgba(0, 0, 0, 0.12),
        md2: Qt.rgba(0, 0, 0, 0.08),
        lg1: Qt.rgba(0, 0, 0, 0.16),
        lg2: Qt.rgba(0, 0, 0, 0.10)
    })

    property var motion: ({
        fast: 150,
        base: 180,
        slow: 260
    })

    // ---- DALI domain slots (Sıkı yol — see DALI repo grill log)
    // Empty by default so OSS consumers see no DALI bagaj. DALI populates
    // these via applyTheme() at startup; component slots like `Tokens.anatomy.bone`
    // and `Tokens.crosshair.axial` then resolve to Penpot-sourced colors.
    property var anatomy: ({})
    property var crosshair: ({})

    // ---- runtime full-theme override (downstream consumer hook)
    // Pass a theme object with any subset of:
    //   { palette: {...},  // forwarded to applyColors()
    //     radius, space, font, shadow, motion,
    //     anatomy, crosshair }
    //
    // Sub-objects shallow-merge with current values (deep-merge for `font.size`
    // and `font.weight`). Whole sub-property is reassigned to trigger QML
    // binding refresh. Stage 2 of pearl-kit's JSON-driven theming refactor —
    // covers everything Tokens.qml exposes.
    function applyTheme(theme) {
        if (!theme) return;
        if (theme.palette)   applyColors(theme.palette);
        if (theme.radius)    radius    = Object.assign({}, radius,    theme.radius);
        if (theme.space)     space     = Object.assign({}, space,     theme.space);
        if (theme.shadow)    shadow    = Object.assign({}, shadow,    theme.shadow);
        if (theme.motion)    motion    = Object.assign({}, motion,    theme.motion);
        if (theme.anatomy)   anatomy   = Object.assign({}, anatomy,   theme.anatomy);
        if (theme.crosshair) crosshair = Object.assign({}, crosshair, theme.crosshair);
        if (theme.font) {
            var newFont = Object.assign({}, font, theme.font);
            if (theme.font.size)   newFont.size   = Object.assign({}, font.size,   theme.font.size);
            if (theme.font.weight) newFont.weight = Object.assign({}, font.weight, theme.font.weight);
            font = newFont;
        }
    }
}
