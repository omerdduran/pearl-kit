import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

T.AbstractButton {
    id: control

    property string label: ""
    property int count: 0
    property bool active: false
    property color stripColor: "#2563EB"
    property string monoFontFamily: Tokens.font.mono
    property string sansFontFamily: Tokens.font.ui

    implicitHeight: 32
    implicitWidth: 200
    hoverEnabled: true
    focusPolicy: Qt.NoFocus

    readonly property color _bg: control.active
        ? "#EFF6FF"
        : (control.hovered ? "#F4F6FA" : "transparent")
    readonly property color _labelColor: control.active ? "#1A202C" : "#4A5568"
    readonly property color _countColor: control.active ? "#2563EB" : "#8A93A0"

    background: Rectangle {
        radius: 4
        color: control._bg
        Behavior on color { ColorAnimation { duration: 120 } }

        Rectangle {
            visible: control.active
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 6
            anchors.bottomMargin: 6
            width: 2
            radius: 1
            color: control.stripColor
        }
    }

    contentItem: Item {
        anchors.fill: parent

        Text {
            text: control.label
            color: control._labelColor
            font.family: control.sansFontFamily
            font.pixelSize: 13
            font.weight: control.active ? Font.Medium : Font.Normal
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: String(control.count).padStart(2, "0")
            color: control._countColor
            font.family: control.monoFontFamily
            font.pixelSize: 11
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
