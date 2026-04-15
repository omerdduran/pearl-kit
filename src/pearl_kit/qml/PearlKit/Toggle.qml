import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.Switch {
    id: control

    // ---- public API
    property string size: "default"   // sm | default

    // ---- Qt template internals
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    implicitWidth: _sizing.trackW
    implicitHeight: _sizing.trackH

    // ---- size resolver
    readonly property QtObject _sizing: QtObject {
        readonly property int trackW:    control.size === "sm" ? 24 : 32
        readonly property int trackH:    control.size === "sm" ? 14 : 18
        readonly property int thumbSize: control.size === "sm" ? 12 : 16
        readonly property int thumbXOff: 1
        readonly property int thumbXOn:  trackW - thumbSize - 1
    }

    // ---- indicator: rounded-full track + animated thumb
    indicator: Rectangle {
        id: track
        implicitWidth: control._sizing.trackW
        implicitHeight: control._sizing.trackH
        width: control._sizing.trackW
        height: control._sizing.trackH
        radius: height / 2
        color: control.checked ? Tokens.primary : Tokens.input
        border.color: "transparent"
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5

        Behavior on color {
            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }

        Rectangle {
            id: thumb
            width: control._sizing.thumbSize
            height: control._sizing.thumbSize
            radius: height / 2
            y: (parent.height - height) / 2
            x: control.checked ? control._sizing.thumbXOn : control._sizing.thumbXOff
            color: control.checked ? Tokens.primaryForeground : Tokens.foreground

            Behavior on x {
                NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }
    }

    // ---- focus ring (shadcn 3px @ ring/50, no offset, keyboard-only)
    // target: control.indicator so rounded-full radius wraps correctly (not md fallback)
    PearlFocusRing {
        target: control.indicator
        offset: 0
        ringWidth: 3
        ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
