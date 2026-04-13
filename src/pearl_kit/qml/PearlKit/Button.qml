import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.Button {
    id: control

    // ---- public API
    property string variant: "default"  // default | destructive | outline | secondary | ghost | link
    property string size: "default"     // default | xs | sm | lg | icon
    property url iconLeft: ""
    property url iconRight: ""

    // ---- Qt template internals
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    leftPadding: _sizing.hpad
    rightPadding: _sizing.hpad
    topPadding: 0
    bottomPadding: 0
    implicitHeight: _sizing.h
    implicitWidth: size === "icon"
        ? _sizing.h
        : Math.max(implicitContentWidth + leftPadding + rightPadding, _sizing.h)

    // ---- size resolver
    readonly property bool _hasIcon: iconLeft != "" || iconRight != ""
    readonly property QtObject _sizing: QtObject {
        readonly property int h: {
            switch (control.size) {
                case "xs": return 24
                case "sm": return 32
                case "lg": return 40
                case "icon": return 36
                default: return 36
            }
        }
        readonly property int hpad: {
            if (control.size === "icon") return 0
            if (control.size === "xs")   return control._hasIcon ? 6  : 8
            if (control.size === "sm")   return control._hasIcon ? 10 : 12
            if (control.size === "lg")   return control._hasIcon ? 16 : 24
            return control._hasIcon ? 12 : 16
        }
        readonly property int gap: {
            switch (control.size) {
                case "xs": return 4
                case "sm": return 6
                default: return 8
            }
        }
    }

    // ---- variant resolver
    readonly property QtObject _v: QtObject {
        readonly property color bg: {
            switch (control.variant) {
                case "destructive": return Tokens.destructive
                case "secondary":   return Tokens.secondary
                case "outline":     return Tokens.background
                case "ghost":       return "transparent"
                case "link":        return "transparent"
                default:            return Tokens.primary
            }
        }
        readonly property color bgHover: {
            switch (control.variant) {
                case "destructive": return Qt.rgba(Tokens.destructive.r, Tokens.destructive.g, Tokens.destructive.b, 0.9)
                case "secondary":   return Qt.rgba(Tokens.secondary.r,   Tokens.secondary.g,   Tokens.secondary.b,   0.8)
                case "outline":     return Tokens.accent
                case "ghost":       return Tokens.accent
                case "link":        return "transparent"
                default:            return Qt.rgba(Tokens.primary.r, Tokens.primary.g, Tokens.primary.b, 0.9)
            }
        }
        readonly property color fg: {
            switch (control.variant) {
                case "destructive": return Tokens.destructiveForeground
                case "secondary":   return Tokens.secondaryForeground
                case "outline":     return Tokens.foreground
                case "ghost":       return Tokens.foreground
                case "link":        return Tokens.primary
                default:            return Tokens.primaryForeground
            }
        }
        readonly property color fgHover: {
            if (control.variant === "outline" || control.variant === "ghost")
                return Tokens.accentForeground
            return control._v.fg
        }
        readonly property color borderColor: control.variant === "outline" ? Tokens.border : "transparent"
        readonly property int  borderW:     control.variant === "outline" ? 1 : 0
    }

    // ---- background
    background: Rectangle {
        color: !control.enabled                   ? control._v.bg
             : (control.down || control.hovered)  ? control._v.bgHover
             :                                      control._v.bg
        radius: Tokens.radius.md
        border.color: control._v.borderColor
        border.width: control._v.borderW
        opacity: control.enabled ? 1.0 : 0.5
        Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
    }

    // ---- content
    contentItem: Row {
        spacing: control._sizing.gap
        opacity: control.enabled ? 1.0 : 0.5

        Image {
            source: control.iconLeft
            visible: control.iconLeft != ""
            sourceSize: Qt.size(16, 16)
            width: 16
            height: 16
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
        }

        PearlText {
            text: control.text
            visible: control.text !== ""
            color: (control.down || control.hovered) ? control._v.fgHover : control._v.fg
            font.underline: control.variant === "link" && control.hovered
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
        }

        Image {
            source: control.iconRight
            visible: control.iconRight != ""
            sourceSize: Qt.size(16, 16)
            width: 16
            height: 16
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // ---- focus ring (shadcn 3px @ ring/50, no offset, keyboard-only)
    PearlFocusRing {
        target: control
        offset: 0
        ringWidth: 3
        ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
