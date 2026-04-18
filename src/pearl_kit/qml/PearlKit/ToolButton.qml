// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:18-28
// 32×32 icon-only palette button. Active = blue-tinted background + blue
// border + blue icon.
import QtQuick
import PearlKit 1.0

Rectangle {
    id: control

    property url iconSource: ""
    property string label: ""
    property string hotkey: ""
    property bool checked: false

    signal toggled()
    signal clicked()

    implicitWidth: 32
    implicitHeight: 32
    width: implicitWidth
    height: implicitHeight

    radius: 4
    color: control.checked
        ? "#EFF6FF"
        : (_area.containsMouse ? "#F1F5F9" : "transparent")
    border.color: control.checked ? "#BFDBFE" : "transparent"
    border.width: 1

    Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
    Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast } }

    Image {
        source: control.iconSource
        sourceSize: Qt.size(16, 16)
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        width: 16
        height: 16
        visible: control.iconSource != ""
    }

    MouseArea {
        id: _area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            control.checked = !control.checked
            control.toggled()
            control.clicked()
        }
    }
}
