// TextAnnotation — anchored text label with delete affordance.
//
// Two modes:
//  * editing: true  → TextInput is focused; Enter commits via
//    committed(text), Escape cancels via cancelled(). The consumer
//    spawns this in "editing" mode when the user clicks in text-tool.
//  * editing: false → static label with the supplied `text`.
//
// Position (x, y) is in image-space; the label and marker dot anchor
// to it.

import QtQuick

Item {
    id: control

    property real x_pos: 0
    property real y_pos: 0
    property string text: ""
    property bool editing: false
    property color strokeColor: "#00D2D2"
    property color labelBg: "#0F172A"

    signal committed(string text)
    signal cancelled()
    signal removed()

    anchors.fill: parent

    // Marker dot
    Rectangle {
        x: control.x_pos - 4
        y: control.y_pos - 4
        width: 8
        height: 8
        radius: 4
        color: control.strokeColor
        border.color: "#0F172A"
        border.width: 1
    }

    // Either the TextInput (editing) or the static label.
    Rectangle {
        x: control.x_pos + 8
        y: control.y_pos - 10
        width: Math.max(60, (_label.visible ? _label.implicitWidth : _input.implicitWidth) + 14)
        height: 22
        radius: 3
        color: control.labelBg
        border.color: control.strokeColor
        border.width: 1
        opacity: 0.95

        Text {
            id: _label
            visible: !control.editing
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.right: parent.right
            anchors.rightMargin: 20
            text: control.text
            color: control.strokeColor
            font.family: Tokens.font.ui
            font.pixelSize: 11
            elide: Text.ElideRight
        }

        TextInput {
            id: _input
            visible: control.editing
            focus: control.editing
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 6
            width: Math.max(80, implicitWidth + 12)
            color: control.strokeColor
            selectByMouse: true
            font.family: Tokens.font.ui
            font.pixelSize: 11
            onAccepted: control.committed(text)
            Keys.onEscapePressed: control.cancelled()
        }

        // "×" delete button (static mode only)
        Rectangle {
            visible: !control.editing && control.text !== ""
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            width: 14
            height: 14
            radius: 7
            color: "transparent"
            border.color: control.strokeColor
            border.width: 1
            opacity: _delete.containsMouse ? 1.0 : 0.8
            Text {
                anchors.centerIn: parent
                text: "×"
                color: control.strokeColor
                font.pixelSize: 10
            }
            MouseArea {
                id: _delete
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: control.removed()
            }
        }
    }
}
