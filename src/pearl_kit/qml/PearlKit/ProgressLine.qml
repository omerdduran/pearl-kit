import QtQuick
import PearlKit 1.0

Item {
    id: control

    property real value: 0
    property real from: 0
    property real to: 100
    property color trackColor: "#E6EAF0"
    property color fillStart: "#2563EB"
    property color fillEnd: "#3B82F6"
    property int lineHeight: 3

    readonly property real _norm: {
        const span = to - from
        if (span <= 0) return 0
        return Math.max(0, Math.min(1, (value - from) / span))
    }

    implicitWidth: 360
    implicitHeight: lineHeight

    Rectangle {
        id: track
        anchors.fill: parent
        radius: 1
        color: control.trackColor
        clip: true

        Rectangle {
            id: fill
            height: parent.height
            width: parent.width * control._norm
            radius: 1
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: control.fillStart }
                GradientStop { position: 1.0; color: control.fillEnd }
            }

            Behavior on width {
                NumberAnimation { duration: 55; easing.type: Easing.Linear }
            }
        }
    }

    Rectangle {
        anchors.fill: track
        radius: 1
        color: "transparent"
        border.color: Qt.rgba(37 / 255, 99 / 255, 235 / 255, 0.25)
        border.width: 0
    }
}
