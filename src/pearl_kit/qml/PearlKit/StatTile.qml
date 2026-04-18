// Source:
//   report-tab.jsx:387-398 (Balanced 4-stat strip — size "md")
//   report-tab.jsx:497-509 (Editorial stat spread — size "lg")
// Mono eyebrow + serif value + mono subtitle. Warn tone turns the value red.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string eyebrow: ""
    property string value: ""
    property string subtitle: ""
    property string tone: "neutral"     // "neutral" | "warn" | "success"
    property string size: "md"          // "sm" | "md" | "lg"

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilySerif: "Times New Roman"

    readonly property QtObject _s: QtObject {
        readonly property int valueSize: {
            switch (control.size) {
                case "sm": return 20
                case "lg": return 54
                default:   return 26
            }
        }
        readonly property int eyebrowSize: control.size === "lg" ? 10 : 9
        readonly property int subtitleSize: control.size === "lg" ? 12 : 10
        readonly property int gap: control.size === "lg" ? 10 : 4
    }

    readonly property color _valueColor: {
        switch (control.tone) {
            case "warn":    return "#B45309"
            case "success": return "#047857"
            default:        return "#1A202C"
        }
    }

    implicitWidth: Math.max(_col.implicitWidth, 96)
    implicitHeight: _col.implicitHeight

    Column {
        id: _col
        spacing: 0

        Text {
            text: control.eyebrow
            color: "#9CA3AF"
            font.family: control.fontFamilyMono
            font.pixelSize: control._s.eyebrowSize
            font.letterSpacing: 0.12 * control._s.eyebrowSize
            font.capitalization: Font.AllUppercase
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Item { width: 1; height: control._s.gap }

        Text {
            text: control.value
            color: control._valueColor
            font.family: control.fontFamilySerif
            font.pixelSize: control._s.valueSize
            font.letterSpacing: -0.015 * control._s.valueSize
            renderType: Text.NativeRendering
            antialiasing: true
            lineHeight: 1.0
            lineHeightMode: Text.ProportionalHeight
        }

        Item { width: 1; height: 4 }

        Text {
            text: control.subtitle
            color: "#6B7280"
            font.family: control.fontFamilyMono
            font.pixelSize: control._s.subtitleSize
            font.letterSpacing: 0.04 * control._s.subtitleSize
            renderType: Text.NativeRendering
            antialiasing: true
            visible: control.subtitle !== ""
        }
    }
}
