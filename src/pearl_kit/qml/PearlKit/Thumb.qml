import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string kind: "axial"
    // kind: "axial" | "coronal" | "sagittal" | "pano" | "3d"
    property bool accent: false
    property string monoFontFamily: Tokens.font.mono

    readonly property string _label: {
        switch (kind) {
            case "coronal":  return "CO"
            case "sagittal": return "SA"
            case "pano":     return "PN"
            case "3d":       return "3D"
            default:         return "AX"
        }
    }
    readonly property color _cross: {
        switch (kind) {
            case "coronal":  return "#F87171"
            case "sagittal": return "#34D399"
            default:         return "#3B82F6"
        }
    }
    readonly property bool _showCross: kind !== "3d" && kind !== "pano"

    implicitWidth: 56
    implicitHeight: 40

    Rectangle {
        id: base
        anchors.fill: parent
        radius: 3
        color: "#0B111E"
        border.color: control.accent ? "#2563EB" : Qt.rgba(15/255, 23/255, 42/255, 0.18)
        border.width: 1
        clip: true

        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 1.3
            height: parent.height * 1.3
            radius: width / 2
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#2A3650" }
                GradientStop { position: 0.7; color: "#121A2B" }
                GradientStop { position: 1.0; color: "#0B111E" }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.55
            height: parent.height * 0.6
            radius: height / 2
            opacity: 0.55
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.rgba(160/255, 180/255, 220/255, 0.55) }
                GradientStop { position: 0.6; color: Qt.rgba(60/255, 75/255, 105/255, 0.1) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0) }
            }
        }

        Rectangle {
            visible: control._showCross
            width: 1
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: control._cross
            opacity: 0.5
        }

        Rectangle {
            visible: control._showCross
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            color: control._cross
            opacity: 0.5
        }

        Text {
            text: control._label
            color: Qt.rgba(203/255, 213/255, 225/255, 0.85)
            font.family: control.monoFontFamily
            font.pixelSize: 8
            font.weight: Font.Medium
            font.letterSpacing: 0.8
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 4
            anchors.topMargin: 3
        }
    }
}
