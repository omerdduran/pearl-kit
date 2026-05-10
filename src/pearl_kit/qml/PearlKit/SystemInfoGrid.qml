import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property var items: []
    // [{ label: "Host", value: "MacBook Pro · M3 Max", dot: "" }, ...]
    // Defaults bound to Tokens so the strip follows Dark / Light. Override
    // any of these from the call site to pin a specific value.
    property color labelColor: Tokens.mutedForeground
    property color valueColor: Tokens.foreground
    property color borderColor: Tokens.border
    property color background: Tokens.background
    property string monoFontFamily: Tokens.font.mono

    implicitHeight: 62

    Rectangle {
        anchors.fill: parent
        color: control.background
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: control.borderColor
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.topMargin: 12
        anchors.bottomMargin: 12
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        rows: 1
        columns: Math.max(1, control.items.length)
        columnSpacing: 24

        Repeater {
            model: control.items

            delegate: Column {
                required property var modelData
                spacing: 3
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: modelData.label
                    color: control.labelColor
                    font.family: control.monoFontFamily
                    font.pixelSize: 10
                    font.letterSpacing: 0.5
                    font.capitalization: Font.AllUppercase
                    renderType: Text.NativeRendering
                    antialiasing: true
                }

                Row {
                    spacing: 6

                    Rectangle {
                        visible: modelData.dot !== undefined && modelData.dot !== ""
                        width: 6; height: 6; radius: 3
                        color: modelData.dot !== undefined ? modelData.dot : "transparent"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: modelData.value
                        color: control.valueColor
                        font.family: control.monoFontFamily
                        font.pixelSize: 11
                        renderType: Text.NativeRendering
                        antialiasing: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
