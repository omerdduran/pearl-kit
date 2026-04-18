import QtQuick
import PearlKit 1.0
import PearlKit.internal 1.0

Item {
    id: control

    property int tileSize: 28
    property int iconSize: 16
    property color gradientStart: "#DBEAFE"
    property color gradientEnd: "#93C5FD"
    property color toothStroke: "#1E3A8A"
    property real toothStrokeWidth: 1.6
    property int radius: 6

    implicitWidth: tileSize
    implicitHeight: tileSize

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: control.radius
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: control.gradientStart }
            GradientStop { position: 1.0; color: control.gradientEnd }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: control.radius
        color: "transparent"
        border.color: Qt.rgba(1, 1, 1, 0.7)
        border.width: 1
        anchors.topMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: parent.height - 1
    }

    PearlToothIcon {
        anchors.centerIn: parent
        width: control.iconSize
        height: control.iconSize
        strokeColor: control.toothStroke
        strokeWidth: control.toothStrokeWidth
    }
}
