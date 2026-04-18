import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.Slider {
    id: control

    // ---- public API
    property bool showTicks: false
    property int  tickCount: 0   // 0 = auto from stepSize (capped at 21)

    // ---- Qt template internals
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    // defaults: horizontal 200x20, vertical 20x176 (shadcn min-h-44)
    implicitWidth:  horizontal ? 200 : 20
    implicitHeight: horizontal ? 20  : 176

    from: 0
    to: 100
    value: 0
    stepSize: 0
    snapMode: T.Slider.SnapOnRelease

    Accessible.role: Accessible.Slider
    Accessible.focusable: true

    // ---- tick count resolver
    readonly property int _tickCount: {
        if (!showTicks) return 0
        if (tickCount > 0) return tickCount
        if (stepSize <= 0) return 5
        return Math.min(21, Math.round((to - from) / stepSize) + 1)
    }

    // ---- background = track + filled range + optional ticks
    background: Rectangle {
        id: track
        x: control.leftPadding + (control.horizontal
            ? 0
            : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
            ? (control.availableHeight - height) / 2
            : 0)
        implicitWidth:  control.horizontal ? 200 : 6
        implicitHeight: control.horizontal ? 6   : 176
        width:  control.horizontal ? control.availableWidth  : 6
        height: control.horizontal ? 6 : control.availableHeight
        radius: Tokens.radius.full
        color: Tokens.muted
        opacity: control.enabled ? 1.0 : 0.5

        Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }

        // filled portion (primary-colored). horizontal fills left-to-right,
        // vertical fills bottom-to-top (medical window/level natural direction)
        Rectangle {
            id: range
            x: 0
            y: control.horizontal ? 0 : parent.height - height
            width:  control.horizontal ? control.position * parent.width : parent.width
            height: control.horizontal ? parent.height : control.position * parent.height
            radius: parent.radius
            color: Tokens.primary

            Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
        }

        // optional tick marks on the far side of the track
        Repeater {
            model: control._tickCount
            delegate: Rectangle {
                readonly property real _t: control._tickCount > 1
                    ? index / (control._tickCount - 1)
                    : 0.0
                width:  control.horizontal ? 1 : 4
                height: control.horizontal ? 4 : 1
                color: Tokens.mutedForeground
                x: control.horizontal
                    ? _t * (track.width - width)
                    : track.width + 4
                y: control.horizontal
                    ? track.height + 4
                    : (1.0 - _t) * (track.height - height)
            }
        }
    }

    // ---- handle (thumb): 16x16 white circle with primary border
    handle: Rectangle {
        id: thumb
        implicitWidth: 16
        implicitHeight: 16
        width: 16
        height: 16
        radius: width / 2
        x: control.leftPadding + (control.horizontal
            ? control.visualPosition * (control.availableWidth - width)
            : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
            ? (control.availableHeight - height) / 2
            : control.visualPosition * (control.availableHeight - height))
        color: "#FFFFFF"
        border.color: Tokens.primary
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5
        scale: control.pressed ? 1.05 : 1.0

        Behavior on scale        { NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
        Behavior on border.color { ColorAnimation  { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
    }

    // ---- focus ring (keyboard-only, wraps handle)
    PearlFocusRing {
        target: control.handle
        offset: 0
        ringWidth: 4
        ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
