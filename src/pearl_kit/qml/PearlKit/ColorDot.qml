// Source: design_handoff_settings/src/settings.jsx:185-190
// 22×22 color swatch with a 2 px white inner border + 1 px outer ring.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property color color: "#2563EB"
    property int size: 22
    property color ringColor: "#E2E8F0"
    property color innerBorderColor: "#FFFFFF"

    signal clicked()

    implicitWidth: size
    implicitHeight: size
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: control.ringColor
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: width / 2
        color: control.innerBorderColor
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 3
        radius: width / 2
        color: control.color
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: control.clicked()
    }
}
