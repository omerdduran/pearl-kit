// Source: design_handoff_settings/src/settings.jsx:254-280
// 96 px gradient avatar with initials (serif) + 28 px "+" overlay
// button + vertical block with serif name + muted title + mono stats
// strip (LICENSE / SINCE / PLANS slots).
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string initials: ""
    property string name: ""
    property string title: ""
    // [{ key: "LICENSE", value: "TR-DDS-21487" }]
    property var stats: []

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui
    property string fontFamilySerif: "Times New Roman"

    signal avatarClicked()

    implicitWidth: 480
    implicitHeight: 96

    RowLayout {
        anchors.fill: parent
        spacing: 28

        // Avatar
        Item {
            Layout.preferredWidth: 96
            Layout.preferredHeight: 96
            Layout.alignment: Qt.AlignTop

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: "#DBEAFE" }
                    GradientStop { position: 1.0; color: "#93C5FD" }
                }

                Text {
                    anchors.centerIn: parent
                    text: control.initials
                    color: "#1E3A8A"
                    font.family: control.fontFamilySerif
                    font.pixelSize: 36
                    font.letterSpacing: -0.02 * 36
                    renderType: Text.NativeRendering
                    antialiasing: true
                }
            }

            // "+" overlay add button at bottom-right
            Rectangle {
                width: 28
                height: 28
                radius: 14
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "#1A202C"
                border.color: "#FFFFFF"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "+"
                    color: "#FFFFFF"
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    renderType: Text.NativeRendering
                    antialiasing: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: control.avatarClicked()
                }
            }
        }

        // Right block: name + title + stats strip
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 6
            spacing: 2

            Text {
                text: control.name
                color: "#1A202C"
                font.family: control.fontFamilySerif
                font.pixelSize: 22
                font.letterSpacing: -0.01 * 22
                renderType: Text.NativeRendering
                antialiasing: true
            }

            Text {
                text: control.title
                color: "#6B7280"
                font.family: control.fontFamilyUI
                font.pixelSize: 13
                renderType: Text.NativeRendering
                antialiasing: true
            }

            RowLayout {
                Layout.topMargin: 8
                spacing: 20

                Repeater {
                    model: control.stats

                    delegate: Row {
                        spacing: 4

                        Text {
                            text: modelData && modelData.key ? String(modelData.key) + " " : ""
                            color: "#9CA3AF"
                            font.family: control.fontFamilyMono
                            font.pixelSize: 11
                            font.letterSpacing: 0.66
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }

                        Text {
                            text: modelData && modelData.value !== undefined ? String(modelData.value) : ""
                            color: "#6B7280"
                            font.family: control.fontFamilyMono
                            font.pixelSize: 11
                            font.letterSpacing: 0.66
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }
                    }
                }
            }
        }
    }
}
