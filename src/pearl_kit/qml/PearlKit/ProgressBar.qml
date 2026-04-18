import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

T.ProgressBar {
    id: control

    focusPolicy: Qt.NoFocus

    from: 0
    to: 100
    value: 0
    indeterminate: false

    implicitWidth: 200
    implicitHeight: 8

    background: Rectangle {
        id: track
        implicitHeight: 8
        radius: height / 2
        color: Qt.rgba(Tokens.primary.r, Tokens.primary.g, Tokens.primary.b, 0.2)
        clip: true
        opacity: control.enabled ? 1.0 : 0.5

        Behavior on opacity {
            NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }

        Rectangle {
            id: determinateIndicator
            visible: !control.indeterminate
            height: parent.height
            width: parent.width
            color: Tokens.primary
            x: -(1 - control.visualPosition) * parent.width

            Behavior on x {
                NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        Rectangle {
            id: indeterminateIndicator
            visible: control.indeterminate
            height: parent.height
            width: parent.width * 0.4
            color: Tokens.primary

            NumberAnimation on x {
                running: control.indeterminate && control.visible
                loops: Animation.Infinite
                from: -indeterminateIndicator.width
                to: track.width
                duration: 1800
                easing.type: Easing.InOutCubic
            }
        }
    }

    contentItem: Item { }
}
