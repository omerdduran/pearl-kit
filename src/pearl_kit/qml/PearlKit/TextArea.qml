import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.TextArea {
    id: control

    // ---- public API
    property bool error: false
    property bool mono: false
    property int minHeight: 64     // shadcn min-h-16

    // ---- auto-grow (shadcn field-sizing-content parity)
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, 200)
    implicitHeight: Math.max(minHeight, contentHeight + topPadding + bottomPadding)

    // ---- shadcn px-3 py-2
    topPadding: 8
    bottomPadding: 8
    leftPadding: 12
    rightPadding: 12

    // ---- typography (shadcn text-sm; mono switches family for license keys / logs)
    font.family:    control.mono ? Tokens.font.mono : Tokens.font.ui
    font.pixelSize: Tokens.font.size.sm
    font.weight:    Tokens.font.weight.regular

    wrapMode: TextEdit.Wrap

    // ---- text + placeholder colors (disabled-aware, mirrors Input)
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

    // ---- background
    background: Rectangle {
        radius: Tokens.radius.md
        color: control._bgColor
        border.color: control._borderColor
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5

        Behavior on color        { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
        Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
    }

    // ---- focus ring (3 px, destructive-if-error, on any focus source — text-input rule)
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
