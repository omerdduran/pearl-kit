import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.TextField {
    id: control

    // ---- public API
    property bool error: false
    property url iconLeft: ""
    property url iconRight: ""

    // ---- Qt template internals
    implicitHeight: 36
    implicitWidth: Math.max(
        implicitBackgroundWidth + leftInset + rightInset,
        contentWidth + leftPadding + rightPadding,
        200
    )
    topPadding: 4
    bottomPadding: 4
    leftPadding:  iconLeft  != "" ? 36 : 12
    rightPadding: iconRight != "" ? 36 : 12

    // ---- typography (shadcn: text-sm font-normal)
    font.family:    Tokens.font.ui
    font.pixelSize: Tokens.font.size.sm
    font.weight:    Tokens.font.weight.regular

    verticalAlignment: TextInput.AlignVCenter

    // ---- text + placeholder colors (disabled-aware)
    color: control.enabled
        ? Tokens.foreground
        : Qt.rgba(Tokens.foreground.r, Tokens.foreground.g, Tokens.foreground.b, 0.5)
    placeholderTextColor: control.enabled
        ? Tokens.mutedForeground
        : Qt.rgba(Tokens.mutedForeground.r, Tokens.mutedForeground.g, Tokens.mutedForeground.b, 0.5)

    selectionColor:    Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.35)
    selectedTextColor: Tokens.foreground

    selectByMouse:      true
    activeFocusOnPress: true
    hoverEnabled:       true
    focusPolicy:        Qt.StrongFocus

    // ---- state resolvers
    readonly property color _borderColor: {
        if (error)        return Tokens.destructive
        if (activeFocus)  return Tokens.ring
        return Tokens.border
    }
    readonly property color _bgColor: Tokens.isLight
        ? "transparent"
        : Qt.rgba(Tokens.input.r, Tokens.input.g, Tokens.input.b, 0.3)

    // ---- background (with icon children)
    background: Rectangle {
        id: bg
        radius: Tokens.radius.md
        color: control._bgColor
        border.color: control._borderColor
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5

        Behavior on color        { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
        Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }

        Image {
            source: control.iconLeft
            visible: control.iconLeft != ""
            sourceSize: Qt.size(16, 16)
            width: 16
            height: 16
            fillMode: Image.PreserveAspectFit
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            source: control.iconRight
            visible: control.iconRight != ""
            sourceSize: Qt.size(16, 16)
            width: 16
            height: 16
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // ---- focus ring (shadcn 3px, destructive-if-error, on any focus source)
    PearlFocusRing {
        target: control
        offset: 0
        ringWidth: 3
        ringColor: control.error
            ? Qt.rgba(Tokens.destructive.r, Tokens.destructive.g, Tokens.destructive.b, 0.2)
            : Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.activeFocus
    }
}
