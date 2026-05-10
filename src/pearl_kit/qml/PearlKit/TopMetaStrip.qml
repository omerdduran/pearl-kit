import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string leftText: ""
    property string rightText: ""
    // Defaults bound to Tokens so the strip follows Dark / Light. Override
    // from the call site to pin a specific value.
    property color textColor: Tokens.mutedForeground
    property color borderColor: Tokens.border
    property string monoFontFamily: Tokens.font.mono

    implicitHeight: 42

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: control.borderColor
        }
    }

    Text {
        text: control.leftText
        color: control.textColor
        font.family: control.monoFontFamily
        font.pixelSize: 11
        font.letterSpacing: 0.4
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: control.rightText
        color: control.textColor
        font.family: control.monoFontFamily
        font.pixelSize: 11
        font.letterSpacing: 0.4
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
    }
}
