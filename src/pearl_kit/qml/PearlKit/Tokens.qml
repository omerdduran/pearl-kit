pragma Singleton
import QtQuick

QtObject {
    id: root

    enum Mode { Dark, DarkBlue, Light }
    property int mode: Tokens.DarkBlue

    readonly property bool isLight: mode === Tokens.Light

    // ---- palette tables (index by mode: Dark=0, DarkBlue=1, Light=2)
    readonly property var _bg:             ["#111111","#141822","#F5F6F8"]
    readonly property var _fg:             ["#E8E8E8","#E8ECF4","#1E293B"]
    readonly property var _muted:          ["#242424","#232942","#F0F1F4"]
    readonly property var _mutedFg:        ["#999999","#9AACC4","#64748B"]
    readonly property var _card:           ["#1A1A1A","#1B2033","#FFFFFF"]
    readonly property var _cardFg:         ["#E8E8E8","#E8ECF4","#1E293B"]
    readonly property var _popover:        ["#222222","#273050","#FFFFFF"]
    readonly property var _popoverFg:      ["#E8E8E8","#E8ECF4","#1E293B"]
    readonly property var _primary:        ["#3B82F6","#4B92FF","#2563EB"]
    readonly property var _primaryFg:      ["#FFFFFF","#FFFFFF","#FFFFFF"]
    readonly property var _secondary:      ["#A78BFA","#B49CFF","#7C3AED"]
    readonly property var _secondaryFg:    ["#FFFFFF","#FFFFFF","#FFFFFF"]
    readonly property var _accent:         ["#3A3A3A","#2A4A7A","#DBEAFE"]
    readonly property var _accentFg:       ["#E8E8E8","#E8ECF4","#1E293B"]
    readonly property var _destructive:    ["#EF4444","#EF4444","#DC2626"]
    readonly property var _destructiveFg:  ["#FFFFFF","#FFFFFF","#FFFFFF"]
    readonly property var _success:        ["#22C55E","#22C55E","#16A34A"]
    readonly property var _warning:        ["#F59E0B","#F59E0B","#D97706"]
    readonly property var _border:         ["#2A2A2A","#283050","#E2E5EA"]
    readonly property var _input:          ["#242424","#232942","#F0F1F4"]
    readonly property var _ring:           ["#3B82F6","#4B92FF","#3B82F6"]
    readonly property var _elev0:          ["#111111","#141822","#F5F6F8"]
    readonly property var _elev1:          ["#1A1A1A","#1B2033","#FFFFFF"]
    readonly property var _elev2:          ["#242424","#232942","#F0F1F4"]
    readonly property var _elev3:          ["#222222","#273050","#FFFFFF"]

    function _c(t) { return t[mode] }

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

    // ---- radius
    readonly property QtObject radius: QtObject {
        readonly property int sm:   4
        readonly property int md:   6
        readonly property int lg:   8
        readonly property int xl:  12
        readonly property int full: 9999
    }

    // ---- spacing (4-based)
    readonly property QtObject space: QtObject {
        readonly property int x0:  0
        readonly property int x1:  4
        readonly property int x2:  8
        readonly property int x3: 12
        readonly property int x4: 16
        readonly property int x5: 20
        readonly property int x6: 24
        readonly property int x8: 32
        readonly property int x10: 40
        readonly property int x12: 48
    }

    // ---- typography
    readonly property QtObject font: QtObject {
        readonly property string ui:   "SF Pro Display"
        readonly property string mono: "SF Mono"
        readonly property QtObject size: QtObject {
            readonly property int xs:  12
            readonly property int sm:  14
            readonly property int md:  16
            readonly property int lg:  18
            readonly property int xl:  20
            readonly property int xxl: 24
        }
        readonly property QtObject weight: QtObject {
            readonly property int regular:  Font.Normal
            readonly property int medium:   Font.Medium
            readonly property int semibold: Font.DemiBold
            readonly property int bold:     Font.Bold
        }
    }

    // ---- shadow (two-layer shadcn style)
    readonly property QtObject shadow: QtObject {
        readonly property color sm1: Qt.rgba(0, 0, 0, 0.10)
        readonly property color sm2: Qt.rgba(0, 0, 0, 0.06)
        readonly property color md1: Qt.rgba(0, 0, 0, 0.12)
        readonly property color md2: Qt.rgba(0, 0, 0, 0.08)
        readonly property color lg1: Qt.rgba(0, 0, 0, 0.16)
        readonly property color lg2: Qt.rgba(0, 0, 0, 0.10)
    }

    // ---- motion
    readonly property QtObject motion: QtObject {
        readonly property int fast: 150
        readonly property int base: 180
        readonly property int slow: 260
    }
}
