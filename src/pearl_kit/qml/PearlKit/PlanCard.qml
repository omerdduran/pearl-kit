// Source: design_handoff_settings/src/settings.jsx:676-693
// Tinted horizontal card: eyebrow + serif title + vertical divider +
// mono price + outline action chip. Drop-in card for billing / plan
// panels.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string eyebrow: "CURRENT"
    property string title: ""
    property string price: ""
    property string priceSuffix: "/ mo"
    property string actionLabel: "UPGRADE"

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui
    property string fontFamilySerif: "Times New Roman"

    signal actionRequested()

    implicitWidth: Math.max(320, _row.implicitWidth + 28)
    implicitHeight: 56

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: "#EFF6FF"
        border.color: "#BFDBFE"
        border.width: 1
    }

    RowLayout {
        id: _row
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        spacing: 14

        ColumnLayout {
            spacing: 2

            Text {
                text: control.eyebrow
                color: "#2563EB"
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                font.letterSpacing: 1.2
                font.capitalization: Font.AllUppercase
                renderType: Text.NativeRendering
                antialiasing: true
            }

            Text {
                text: control.title
                color: "#1E3A8A"
                font.family: control.fontFamilySerif
                font.pixelSize: 18
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 32
            color: "#BFDBFE"
        }

        Text {
            text: control.price + " " + control.priceSuffix
            color: "#1E3A8A"
            font.family: control.fontFamilyMono
            font.pixelSize: 12
            renderType: Text.NativeRendering
            antialiasing: true
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true }

        Rectangle {
            Layout.preferredWidth: _actionText.implicitWidth + 20
            Layout.preferredHeight: 26
            radius: 3
            color: _actionArea.containsMouse ? "#F0F7FF" : "#FFFFFF"
            border.color: "#BFDBFE"
            border.width: 1

            Text {
                id: _actionText
                anchors.centerIn: parent
                text: control.actionLabel
                color: "#2563EB"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.letterSpacing: 0.88
                font.weight: Font.DemiBold
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _actionArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: control.actionRequested()
            }
        }
    }
}
