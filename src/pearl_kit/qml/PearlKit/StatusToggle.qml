// Source: design_handoff_settings/src/settings.jsx:145-165
// 34x18 pill toggle with a 14x14 white thumb + mono uppercase status
// label to the right. labelOn/labelOff let callers use "Enabled"/
// "Disabled" on security-style toggles instead of the default ON/OFF.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property bool checked: false
    property string labelOn: "ON"
    property string labelOff: "OFF"
    property string fontFamilyMono: Tokens.font.mono

    signal toggled()

    implicitWidth: _pill.width + 10 + _label.implicitWidth
    implicitHeight: 18

    Rectangle {
        id: _pill
        width: 34
        height: 18
        radius: 10
        anchors.verticalCenter: parent.verticalCenter
        color: control.checked ? "#2563EB" : "#CBD5E1"
        Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }

        Rectangle {
            id: _thumb
            width: 14
            height: 14
            radius: 7
            color: "#FFFFFF"
            anchors.verticalCenter: parent.verticalCenter
            x: control.checked ? 18 : 2
            Behavior on x { NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }

            // Soft shadow (two offset rings)
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.color: Qt.rgba(0, 0, 0, 0.12)
                border.width: 1
            }
        }
    }

    Text {
        id: _label
        anchors.left: _pill.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: control.checked
            ? control.labelOn.toUpperCase()
            : control.labelOff.toUpperCase()
        color: control.checked ? "#2563EB" : "#6B7280"
        font.family: control.fontFamilyMono
        font.pixelSize: 11
        font.letterSpacing: 0.88
        font.weight: control.checked ? Font.DemiBold : Font.Normal
        renderType: Text.NativeRendering
        antialiasing: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
            control.checked = !control.checked
            control.toggled()
        }
    }
}
