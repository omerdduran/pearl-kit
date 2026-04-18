import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string text: ""
    property string state: "ready"
    property string fontFamily: Tokens.font.mono

    readonly property QtObject _v: QtObject {
        readonly property color dot: {
            switch (control.state) {
                case "processing": return "#F59E0B"
                case "reviewed":   return "#10B981"
                case "neutral":    return "#64748B"
                default:           return "#2563EB"
            }
        }
        readonly property color bg: {
            switch (control.state) {
                case "processing": return "#FFFBEB"
                case "reviewed":   return "#ECFDF5"
                case "neutral":    return "#F4F5F8"
                default:           return "#EFF6FF"
            }
        }
        readonly property color fg: {
            switch (control.state) {
                case "processing": return "#B45309"
                case "reviewed":   return "#047857"
                case "neutral":    return "#475569"
                default:           return "#2563EB"
            }
        }
    }

    implicitHeight: 22
    implicitWidth: _row.implicitWidth + 18

    Rectangle {
        anchors.fill: parent
        radius: Tokens.radius.full
        color: control._v.bg
    }

    Row {
        id: _row
        anchors.centerIn: parent
        spacing: 6

        Rectangle {
            width: 6; height: 6; radius: 3
            color: control._v.dot
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: control.text
            color: control._v.fg
            font.family: control.fontFamily
            font.pixelSize: 10
            font.weight: Font.Medium
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
