import QtQuick
import QtQuick.Effects
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
    // Track outer dimensions are unchanged from v0.4.x (32×18 / 24×14) so
    // existing layouts and assertion-based tests stay intact. Thumb shrinks
    // by 2px so it sits with 2px breathing room on every side instead of
    // dominating the track — kills the "chunky" look.
    readonly property QtObject _sizing: QtObject {
        readonly property int trackW:    control.size === "sm" ? 24 : 32
        readonly property int trackH:    control.size === "sm" ? 14 : 18
        readonly property int thumbSize: control.size === "sm" ? 10 : 14
        readonly property int thumbInset: 2
        readonly property int thumbXOff: thumbInset
        readonly property int thumbXOn:  trackW - thumbSize - thumbInset
    }

    // ---- indicator: pill track + circular white thumb with soft shadow
    indicator: Rectangle {
        id: track
        implicitWidth: control._sizing.trackW
        implicitHeight: control._sizing.trackH
        width: control._sizing.trackW
        height: control._sizing.trackH
        radius: height / 2
        color: control.checked
                 ? (control.hovered ? Qt.darker(Tokens.primary, 1.06) : Tokens.primary)
                 : (control.hovered ? Qt.darker(Tokens.input, 1.05)   : Tokens.input)
        border.color: control.checked ? "transparent" : Tokens.border
        border.width: control.checked ? 0 : 1
        opacity: control.enabled ? 1.0 : 0.5

        Behavior on color {
            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
        Behavior on border.color {
            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }

        Rectangle {
            id: thumb
            width: control._sizing.thumbSize
            height: control._sizing.thumbSize
            radius: width / 2
            y: (parent.height - height) / 2
            x: control.checked ? control._sizing.thumbXOn : control._sizing.thumbXOff
            color: "#FFFFFF"
            antialiasing: true

            // Soft drop shadow — same MultiEffect pattern Dialog/Menu/Toast use.
            // shadowVerticalOffset: 1 + shadowBlur: 0.6 produces a subtle lift
            // that reads as "elevated thumb" without looking like a button.
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowBlur: 0.6
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 1
                shadowColor: Qt.rgba(0, 0, 0, 0.22)
                shadowScale: 1.0
                paddingRect: Qt.rect(-3, -3, control._sizing.thumbSize + 6, control._sizing.thumbSize + 6)
            }

            // Spring slide — small overshoot gives a tactile "snap" feel.
            Behavior on x {
                NumberAnimation {
                    duration: Tokens.motion.base
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.4
                }
            }
        }
    }

    // ---- focus ring (shadcn 3px @ ring/50, no offset, keyboard-only)
    PearlFocusRing {
        target: control.indicator
        offset: 0
        ringWidth: 3
        ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
