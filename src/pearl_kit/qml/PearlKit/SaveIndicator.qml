// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:258-261
// 6×6 colored dot + mono 10px muted label. State drives dot color.
import QtQuick
import PearlKit 1.0

Row {
    id: control

    property string state: "saved"   // "saved" | "saving" | "error" | "offline"
    property string text: ""
    property string fontFamily: Tokens.font.mono
    property color textColor: "#6B7280"

    spacing: 6

    readonly property color _dotColor: {
        switch (control.state) {
            case "saving":  return "#F59E0B"
            case "error":   return "#DC2626"
            case "offline": return "#9CA3AF"
            default:        return "#10B981"
        }
    }

    Rectangle {
        width: 6
        height: 6
        radius: 3
        color: control._dotColor
        anchors.verticalCenter: parent.verticalCenter

        Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
    }

    Text {
        text: control.text
        color: control.textColor
        font.family: control.fontFamily
        font.pixelSize: 10
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.verticalCenter: parent.verticalCenter
    }
}
