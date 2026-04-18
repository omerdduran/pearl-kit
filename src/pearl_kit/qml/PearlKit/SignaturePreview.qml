// Source: design_handoff_settings/src/settings.jsx:300-312
// 180×54 framed cursive signature preview + outline mono REDRAW button.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string text: ""
    property string actionLabel: "REDRAW"
    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyCursive: "Dancing Script"
    property int frameWidth: 180
    property int frameHeight: 54

    signal redrawRequested()

    implicitWidth: frameWidth + 12 + _btn.implicitWidth
    implicitHeight: Math.max(frameHeight, _btn.implicitHeight)

    RowLayout {
        anchors.fill: parent
        spacing: 12

        Rectangle {
            Layout.preferredWidth: control.frameWidth
            Layout.preferredHeight: control.frameHeight
            radius: 4
            color: "#FAFBFC"
            border.color: "#E2E8F0"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: control.text
                color: "#1A202C"
                font.family: control.fontFamilyCursive
                font.pixelSize: 28
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }

        Rectangle {
            id: _btn
            Layout.preferredWidth: _btnText.implicitWidth + 24
            Layout.preferredHeight: 30
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: _btnArea.containsMouse ? "#F7F8FA" : "#FFFFFF"
            border.color: "#E2E8F0"
            border.width: 1

            Text {
                id: _btnText
                anchors.centerIn: parent
                text: control.actionLabel
                color: "#4A5568"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.letterSpacing: 0.66
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _btnArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: control.redrawRequested()
            }
        }
    }
}
