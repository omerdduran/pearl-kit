import QtQuick
import PearlKit 1.0

Item {
    id: control

    // ---- public API
    property string variant: "default"
    // variants: "default" | "destructive" | "warning" | "success" | "info"

    property int accentWidth: variant === "default" ? 0 : 4
    property int padding: Tokens.space.x6    // 24 — shadcn py-6/px-6
    property int spacing: Tokens.space.x6    // 24 — shadcn gap-6

    default property alias contentData: _col.data

    // ---- variant resolver
    readonly property color _accentColor: {
        switch (variant) {
            case "destructive": return Tokens.destructive
            case "warning":     return Tokens.warning
            case "success":     return Tokens.success
            case "info":        return Tokens.primary
            default:            return "transparent"
        }
    }

    // ---- geometry
    implicitWidth:  Math.max(_col.implicitWidth + 2 * control.padding, 240)
    implicitHeight: _col.implicitHeight + 2 * control.padding

    // ---- surface (clip rounds the accent stripe's left corners)
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Tokens.radius.xl
        color: Tokens.card
        border.color: Tokens.border
        border.width: 1
        clip: true
        opacity: control.enabled ? 1.0 : 0.5

        Rectangle {
            id: accent
            visible: control.accentWidth > 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: control.accentWidth
            color: control._accentColor
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }
    }

    // ---- content column (sibling of bg, padding-inset)
    Column {
        id: _col
        x: control.padding
        y: control.padding
        width: parent.width - 2 * control.padding
        spacing: control.spacing
        opacity: control.enabled ? 1.0 : 0.5
    }
}
