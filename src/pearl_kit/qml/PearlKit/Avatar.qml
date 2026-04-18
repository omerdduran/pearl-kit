import QtQuick
import PearlKit 1.0

Item {
    id: control

    // ---- public API
    property string size: "default"
    // sizes: "sm" | "default" | "lg"  (24 / 32 / 40 — shadcn size-6/8/10)

    property string variant: "default"
    // variants: "default" | "primary" | "secondary"
    // default = shadcn bg-muted + text-muted-foreground (neutral chat avatar)
    // primary = assistant role tint (Tokens.primary)
    // secondary = user role tint (Tokens.secondary)

    property url source: ""
    property url iconSource: ""
    property string initials: ""

    // ---- size resolver — shadcn size-6/8/10 + text-xs for sm
    readonly property QtObject _sizing: QtObject {
        readonly property int d: {
            switch (control.size) {
                case "sm": return 24
                case "lg": return 40
                default:   return 32
            }
        }
        readonly property int textPx: control.size === "sm"
            ? Tokens.font.size.xs
            : Tokens.font.size.sm
        readonly property int iconPx: {
            switch (control.size) {
                case "sm": return 14
                case "lg": return 20
                default:   return 16
            }
        }
    }

    // ---- variant resolver
    readonly property QtObject _v: QtObject {
        readonly property color bg: {
            switch (control.variant) {
                case "primary":   return Tokens.primary
                case "secondary": return Tokens.secondary
                default:          return Tokens.muted
            }
        }
        readonly property color fg: {
            switch (control.variant) {
                case "primary":   return Tokens.primaryForeground
                case "secondary": return Tokens.secondaryForeground
                default:          return Tokens.mutedForeground
            }
        }
    }

    // ---- geometry
    implicitWidth:  _sizing.d
    implicitHeight: _sizing.d

    // ---- surface (circle, clips image overflow)
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: width / 2
        color: control._v.bg
        clip: true
        opacity: control.enabled ? 1.0 : 0.5

        Behavior on color {
            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }

        // 1. Image source (highest priority — fills square, aspect-preserving crop)
        Image {
            id: img
            anchors.fill: parent
            source: control.source
            visible: control.source != ""
            fillMode: Image.PreserveAspectCrop
            sourceSize: Qt.size(control._sizing.d * 2, control._sizing.d * 2)
            asynchronous: true
            smooth: true
            mipmap: true
        }

        // 2. Icon (middle priority — centered SVG glyph)
        Image {
            id: icon
            anchors.centerIn: parent
            source: control.iconSource
            visible: !img.visible && control.iconSource != ""
            width: control._sizing.iconPx
            height: control._sizing.iconPx
            sourceSize: Qt.size(control._sizing.iconPx, control._sizing.iconPx)
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        // 3. Initials (fallback — centered text)
        Text {
            id: label
            anchors.centerIn: parent
            visible: !img.visible && !icon.visible && control.initials !== ""
            text: control.initials
            color: control._v.fg
            font.family: Tokens.font.ui
            font.pixelSize: control._sizing.textPx
            font.weight: Tokens.font.weight.medium
            renderType: Text.NativeRendering
            antialiasing: true
        }
    }
}
