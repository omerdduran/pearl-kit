// Source: design_handoff_settings/src/settings.jsx:756-780
// 120 px wide theme picker tile: 70 px preview box with a serif "Aa"
// glyph + mono label below. Active state adds 2 px blue border + 3 px
// outer glow + label weight/color changes.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string label: ""
    property color previewBackground: "#FFFFFF"
    property color inkColor: "#1A202C"
    property string previewGlyph: "Aa"
    property bool checked: false

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilySerif: "Times New Roman"

    signal clicked()

    implicitWidth: 120
    implicitHeight: 70 + 6 + 14
    width: implicitWidth

    Column {
        anchors.fill: parent
        spacing: 6

        // Preview
        Item {
            width: parent.width
            height: 70

            // Outer glow (3 px at 15% blue)
            Rectangle {
                visible: control.checked
                anchors.fill: parent
                anchors.margins: -3
                radius: 7
                color: "transparent"
                border.color: Qt.rgba(37 / 255, 99 / 255, 235 / 255, 0.15)
                border.width: 3
            }

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: control.previewBackground
                border.color: control.checked ? "#2563EB" : "#E2E8F0"
                border.width: 2
                Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast } }

                Text {
                    anchors.centerIn: parent
                    text: control.previewGlyph
                    color: control.inkColor
                    font.family: control.fontFamilySerif
                    font.pixelSize: 18
                    renderType: Text.NativeRendering
                    antialiasing: true
                }
            }
        }

        // Label
        Text {
            width: parent.width
            text: control.label.toUpperCase()
            color: control.checked ? "#2563EB" : "#6B7280"
            font.family: control.fontFamilyMono
            font.pixelSize: 11
            font.letterSpacing: 0.88
            font.weight: control.checked ? Font.DemiBold : Font.Normal
            renderType: Text.NativeRendering
            antialiasing: true
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: control.clicked()
    }
}
