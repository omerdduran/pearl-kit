import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.CheckBox {
    id: control

    // ---- public API
    property bool error: false

    // ---- Qt template internals
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    spacing: 0
    implicitWidth: 16
    implicitHeight: 16

    // ---- state resolvers
    readonly property color _borderColor: {
        if (error)                       return Tokens.destructive
        if (checkState !== Qt.Unchecked) return Tokens.primary
        return Tokens.input
    }
    readonly property color _bgColor: {
        if (checkState !== Qt.Unchecked) return Tokens.primary
        if (Tokens.isLight)              return "transparent"
        return Qt.rgba(Tokens.input.r, Tokens.input.g, Tokens.input.b, 0.3)
    }

    // ---- indicator (the 16x16 box + check/dash glyph)
    indicator: Rectangle {
        x: 0
        y: (control.height - height) / 2
        implicitWidth: 16
        implicitHeight: 16
        width: 16
        height: 16
        radius: Tokens.radius.sm
        color: control._bgColor
        border.color: control._borderColor
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5

        PearlCheckIcon {
            anchors.centerIn: parent
            width: 14
            height: 14
            mode: control.checkState === Qt.PartiallyChecked ? "dash" : "check"
            visible: control.checkState !== Qt.Unchecked
            strokeColor: Tokens.primaryForeground
            strokeWidth: 2.0
        }
    }

    // ---- contentItem (no label — shadcn composes externally)
    contentItem: Item {
        implicitWidth: 0
        implicitHeight: 0
    }

    // ---- focus ring (shadcn 3px @ ring/50, keyboard-only)
    PearlFocusRing {
        target: control.indicator
        offset: 0
        ringWidth: 3
        ringColor: control.error
            ? Qt.rgba(Tokens.destructive.r, Tokens.destructive.g, Tokens.destructive.b,
                      Tokens.isLight ? 0.2 : 0.4)
            : Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
