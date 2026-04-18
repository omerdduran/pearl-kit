// Source: design_handoff_settings/src/settings.jsx:558-564
// 8 px glowing dot + mono bold uppercase state label + mono muted
// caption. Distinct from SaveIndicator (6 px dot, single muted text).
import QtQuick
import PearlKit 1.0

Row {
    id: control

    property string state: "online"      // "online" | "offline" | "error"
    property string label: ""            // falls back to uppercased state
    property string caption: ""

    property string fontFamilyMono: Tokens.font.mono

    spacing: 10

    readonly property color _dotColor: {
        switch (control.state) {
            case "offline": return "#9CA3AF"
            case "error":   return "#DC2626"
            default:        return "#10B981"
        }
    }
    readonly property color _labelColor: {
        switch (control.state) {
            case "offline": return "#6B7280"
            case "error":   return "#B91C1C"
            default:        return "#047857"
        }
    }
    readonly property color _glowColor: {
        switch (control.state) {
            case "offline": return Qt.rgba(156 / 255, 163 / 255, 175 / 255, 0.35)
            case "error":   return Qt.rgba(220 / 255, 38 / 255, 38 / 255, 0.4)
            default:        return Qt.rgba(16 / 255, 185 / 255, 129 / 255, 0.5)
        }
    }
    readonly property string _labelText: control.label !== ""
        ? control.label
        : control.state.toUpperCase()

    Item {
        width: 16
        height: 16
        anchors.verticalCenter: parent.verticalCenter

        // Glow ring
        Rectangle {
            anchors.centerIn: parent
            width: 16
            height: 16
            radius: 8
            color: "transparent"
            border.color: control._glowColor
            border.width: 2
            opacity: 0.5
        }

        Rectangle {
            anchors.centerIn: parent
            width: 8
            height: 8
            radius: 4
            color: control._dotColor
            Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
        }
    }

    Text {
        text: control._labelText
        color: control._labelColor
        font.family: control.fontFamilyMono
        font.pixelSize: 11
        font.letterSpacing: 0.88
        font.weight: Font.DemiBold
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: control.caption
        color: "#6B7280"
        font.family: control.fontFamilyMono
        font.pixelSize: 11
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.verticalCenter: parent.verticalCenter
        visible: control.caption !== ""
    }
}
