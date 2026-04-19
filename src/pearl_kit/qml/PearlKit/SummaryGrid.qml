// Source: design_handoff_onboarding/src/onboarding.jsx:423-438
// Ready-step "YOUR SETUP" card: grey-surface bordered rectangle, mono
// eyebrow on top, 2-column mono key-value grid below. Each entry can
// override its value color via valueColor for OK/warn coloring.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string eyebrow: "YOUR SETUP"
    // [{ key: "NAME", value: "Dr. Mehmet Kaya", valueColor: "#1A202C" }]
    property var model: []
    property int columns: 2
    property color background: "#F7F8FA"
    property color borderColor: "#E2E8F0"
    property color eyebrowColor: "#9CA3AF"
    property color keyColor: "#9CA3AF"
    property color valueColor: "#1A202C"
    property int radius: 5
    property int padding: 16

    property string fontFamilyMono: Tokens.font.mono

    implicitWidth: 540
    implicitHeight: _col.implicitHeight + padding * 2

    Rectangle {
        anchors.fill: parent
        radius: control.radius
        color: control.background
        border.color: control.borderColor
        border.width: 1
    }

    ColumnLayout {
        id: _col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: control.padding + 2
        anchors.rightMargin: control.padding + 2
        anchors.topMargin: control.padding
        spacing: 8

        Text {
            visible: control.eyebrow !== ""
            text: control.eyebrow
            color: control.eyebrowColor
            font.family: control.fontFamilyMono
            font.pixelSize: 10
            font.letterSpacing: 1.3
            font.capitalization: Font.AllUppercase
            renderType: Text.NativeRendering
            antialiasing: true
        }

        GridLayout {
            Layout.fillWidth: true
            columns: control.columns
            rowSpacing: 8
            columnSpacing: 20

            Repeater {
                model: control.model

                delegate: RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        text: modelData && modelData.key !== undefined ? String(modelData.key) + " " : ""
                        color: control.keyColor
                        font.family: control.fontFamilyMono
                        font.pixelSize: 11
                        font.letterSpacing: 0.5
                        font.capitalization: Font.AllUppercase
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }

                    Text {
                        text: modelData && modelData.value !== undefined ? String(modelData.value) : ""
                        color: modelData && modelData.valueColor !== undefined ? modelData.valueColor : control.valueColor
                        font.family: control.fontFamilyMono
                        font.pixelSize: 11
                        renderType: Text.NativeRendering
                        antialiasing: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
