import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string text: ""
    property string variant: "default"
    property url iconLeft: ""
    property url iconRight: ""

    readonly property int _hpad: 8
    readonly property int _vpad: 2
    readonly property int _gap: 4
    readonly property int _iconSize: 12

    readonly property QtObject _v: QtObject {
        readonly property color bg: {
            switch (control.variant) {
                case "secondary":   return Tokens.secondary
                case "destructive": return Tokens.destructive
                case "outline":     return "transparent"
                case "ghost":       return "transparent"
                case "link":        return "transparent"
                default:            return Tokens.primary
            }
        }
        readonly property color fg: {
            switch (control.variant) {
                case "secondary":   return Tokens.secondaryForeground
                case "destructive": return "#FFFFFF"
                case "outline":     return Tokens.foreground
                case "ghost":       return Tokens.foreground
                case "link":        return Tokens.primary
                default:            return Tokens.primaryForeground
            }
        }
        readonly property color borderColor:
            control.variant === "outline" ? Tokens.border : "transparent"
    }

    implicitHeight: Math.max(_row.implicitHeight + 2 * _vpad, 20)
    implicitWidth:  _row.implicitWidth + 2 * _hpad

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Tokens.radius.full
        color: control._v.bg
        border.color: control._v.borderColor
        border.width: 1
        clip: true
        opacity: control.enabled ? 1.0 : 0.5
        Behavior on color {
            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
    }

    Row {
        id: _row
        anchors.centerIn: parent
        spacing: control._gap
        opacity: control.enabled ? 1.0 : 0.5

        Image {
            source: control.iconLeft
            visible: control.iconLeft != ""
            sourceSize: Qt.size(control._iconSize, control._iconSize)
            width: control._iconSize
            height: control._iconSize
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: control.text
            visible: control.text !== ""
            color: control._v.fg
            font.family: Tokens.font.ui
            font.pixelSize: Tokens.font.size.xs
            font.weight: Tokens.font.weight.medium
            font.underline: control.variant === "link"
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        Image {
            source: control.iconRight
            visible: control.iconRight != ""
            sourceSize: Qt.size(control._iconSize, control._iconSize)
            width: control._iconSize
            height: control._iconSize
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: control.text
}
