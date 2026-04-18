import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.Button {
    id: control

    // ---- public API
    property string size: "default"      // "default" | "sm" | "lg"
    property bool active: false          // selected state (consumer-managed)
    property url iconLeft: ""
    property url iconRight: ""

    // ---- Qt template internals
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    leftPadding: 8
    rightPadding: 8
    topPadding: 0
    bottomPadding: 0
    implicitHeight: _sizing.h
    implicitWidth: Math.max(implicitContentWidth + leftPadding + rightPadding, 160)

    // ---- size resolver
    readonly property QtObject _sizing: QtObject {
        readonly property int h: {
            switch (control.size) {
                case "sm": return 28
                case "lg": return 48
                default:   return 32
            }
        }
        readonly property int fontSize: control.size === "sm" ? Tokens.font.size.xs
                                                              : Tokens.font.size.sm
    }

    // ---- state resolver (shadcn: hover == active background; active adds font-medium)
    readonly property bool _highlighted: control.active || control.down || control.hovered
    readonly property color _bg: control._highlighted ? Tokens.accent           : "transparent"
    readonly property color _fg: control._highlighted ? Tokens.accentForeground : Tokens.foreground
    readonly property int   _fw: control.active ? Tokens.font.weight.medium
                                                : Tokens.font.weight.regular

    // ---- background
    background: Rectangle {
        color: control._bg
        radius: Tokens.radius.md
        opacity: control.enabled ? 1.0 : 0.5
        Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
    }

    // ---- content: leading icon · label (truncates) · trailing icon
    contentItem: Row {
        spacing: 8
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

        PearlBaseText {
            text: control.text
            visible: control.text !== ""
            color: control._fg
            font.pixelSize: control._sizing.fontSize
            font.weight: control._fw
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(0,
                control.availableWidth
                - (control.iconLeft  != "" ? (16 + parent.spacing) : 0)
                - (control.iconRight != "" ? (16 + parent.spacing) : 0))
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

    // ---- focus ring (shadcn focus-visible:ring-2 — keyboard-only, flush, ring/50)
    PearlFocusRing {
        target: control
        offset: 0
        ringWidth: 3
        ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
