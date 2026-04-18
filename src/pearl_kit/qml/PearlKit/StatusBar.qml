import QtQuick
import PearlKit 1.0

Rectangle {
    id: control

    // ---- public API
    property Component leftContent: null
    property Component centerContent: null
    property Component rightContent: null

    // statusKind drives the derived statusColor; consumer binds it from rightContent
    property string statusKind: "default"
    // variants: "default" | "success" | "warning" | "error"

    readonly property color statusColor: {
        switch (statusKind) {
            case "success": return Tokens.success
            case "warning": return Tokens.warning
            case "error":   return Tokens.destructive
            default:        return Tokens.mutedForeground
        }
    }

    property int hpad: Tokens.space.x3   // 12 — macOS footer side padding

    // ---- geometry (macOS footer: 28 px, 1 px top hairline, muted fill)
    implicitHeight: 28
    implicitWidth: 480

    color: Tokens.muted

    // top hairline divider
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Tokens.border
    }

    // ---- left region (anchored to left edge)
    Loader {
        id: _leftSlot
        sourceComponent: control.leftContent
        anchors.left: parent.left
        anchors.leftMargin: control.hpad
        anchors.verticalCenter: parent.verticalCenter
        opacity: control.enabled ? 1.0 : 0.5
    }

    // ---- center region (absolute horizontal center of the bar, independent of left/right widths)
    Loader {
        id: _centerSlot
        sourceComponent: control.centerContent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: control.enabled ? 1.0 : 0.5
    }

    // ---- right region (anchored to right edge)
    Loader {
        id: _rightSlot
        sourceComponent: control.rightContent
        anchors.right: parent.right
        anchors.rightMargin: control.hpad
        anchors.verticalCenter: parent.verticalCenter
        opacity: control.enabled ? 1.0 : 0.5
    }

    Behavior on color {
        ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
    }
}
