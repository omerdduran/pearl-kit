// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:216-218
// Mono 11px / 0.04em letter-spacing trail. Last segment marked `current: true`
// rendered in primary blue, medium weight. Penultimate rendered darker grey
// than earlier segments; separator glyphs in the lightest grey.
import QtQuick
import PearlKit 1.0

Row {
    id: control

    // segments: [{ label: string, current?: bool }]
    // When `current` is omitted, the last segment is auto-treated as current.
    property var segments: []
    property string separatorChar: "/"
    property string fontFamily: Tokens.font.mono
    property int fontPixelSize: 11
    property real letterSpacing: 0.04 * fontPixelSize

    property color separatorColor: "#D1D5DB"
    property color pastColor: "#9CA3AF"
    property color penultimateColor: "#6B7280"
    property color currentColor: "#2563EB"

    spacing: 0

    Repeater {
        model: control.segments

        Row {
            spacing: 0

            readonly property int _i: index
            readonly property int _count: control.segments.length
            readonly property bool _explicitCurrent: modelData && modelData.current === true
            readonly property bool _isCurrent: _explicitCurrent || (_i === _count - 1)
            readonly property bool _isPenultimate: (!_isCurrent) && (_i === _count - 2)
            readonly property color _segColor: _isCurrent
                ? control.currentColor
                : (_isPenultimate ? control.penultimateColor : control.pastColor)

            Text {
                text: "  " + control.separatorChar + "  "
                visible: parent._i !== 0
                color: control.separatorColor
                font.family: control.fontFamily
                font.pixelSize: control.fontPixelSize
                font.letterSpacing: control.letterSpacing
                renderType: Text.NativeRendering
                antialiasing: true
            }

            Text {
                text: modelData ? (modelData.label !== undefined ? modelData.label : String(modelData)) : ""
                color: parent._segColor
                font.family: control.fontFamily
                font.pixelSize: control.fontPixelSize
                font.letterSpacing: control.letterSpacing
                font.weight: parent._isCurrent ? Font.Medium : Font.Normal
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }
    }
}
