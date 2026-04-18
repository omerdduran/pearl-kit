// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:169-193
// Per-structure safety distance row: label + value + threshold bar + min
// caption. Value goes green when value >= min, amber otherwise.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string label: ""
    property real value: 0
    property real min: 1.0
    property string unit: "mm"

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    readonly property bool _ok: control.value >= control.min
    readonly property real _ratio: {
        const denom = control.min * 2
        if (denom <= 0) return 0
        return Math.max(0, Math.min(1, control.value / denom))
    }
    readonly property color _valueColor: _ok ? "#047857" : "#B45309"
    readonly property color _fillColor: _ok ? "#10B981" : "#F59E0B"

    implicitWidth: 240
    implicitHeight: _col.implicitHeight + 16

    Column {
        id: _col
        width: parent.width
        y: 8
        spacing: 4

        Item {
            width: parent.width
            height: Math.max(_lbl.implicitHeight, _val.implicitHeight)

            Text {
                id: _lbl
                text: control.label
                color: "#4A5568"
                font.family: control.fontFamilyUI
                font.pixelSize: 12
                renderType: Text.NativeRendering
                antialiasing: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }

            Text {
                id: _val
                text: control.value.toFixed(1) + " " + control.unit
                color: control._valueColor
                font.family: control.fontFamilyMono
                font.pixelSize: 12
                font.weight: Font.Medium
                renderType: Text.NativeRendering
                antialiasing: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }
        }

        // Threshold bar — 3px track with safety fill + 50% mark
        Rectangle {
            width: parent.width
            height: 3
            radius: 2
            color: "#F1F5F9"

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * control._ratio
                color: control._fillColor
                Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
            }

            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                x: parent.width * 0.5
                width: 1
                color: Qt.rgba(15 / 255, 23 / 255, 42 / 255, 0.3)
            }
        }

        Text {
            text: "min safety · " + control.min.toFixed(1) + " " + control.unit
            color: "#9CA3AF"
            font.family: control.fontFamilyMono
            font.pixelSize: 10
            renderType: Text.NativeRendering
            antialiasing: true
        }
    }

    // 1px bottom hairline
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: "#F4F5F8"
    }
}
