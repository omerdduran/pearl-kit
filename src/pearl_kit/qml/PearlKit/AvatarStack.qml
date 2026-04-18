// Source: design_handoff_settings/src/settings.jsx:635-650
// Horizontal row of overlapping 34×34 circular avatars + optional
// dashed "+" add button. Each avatar is an initials chip colored per
// entry.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    // avatars: [{ initials: string, background: color, foreground: color }]
    property var avatars: []
    property bool showAddButton: true
    property int avatarSize: 34
    property int overlap: 8
    property int addSpacing: 8

    property string fontFamilyMono: Tokens.font.mono
    property color addBorderColor: "#CBD5E1"
    property color addTextColor: "#6B7280"

    signal addRequested()

    implicitWidth: (avatars.length > 0
            ? (avatarSize + (avatars.length - 1) * (avatarSize - overlap))
            : 0)
        + (showAddButton ? (addSpacing + avatarSize) : 0)
    implicitHeight: avatarSize

    Row {
        spacing: 0
        height: parent.height

        Repeater {
            model: control.avatars

            delegate: Item {
                width: control.avatarSize - (index === 0 ? 0 : control.overlap)
                height: control.avatarSize

                Rectangle {
                    width: control.avatarSize
                    height: control.avatarSize
                    radius: width / 2
                    anchors.right: parent.right
                    color: modelData && modelData.background
                        ? modelData.background
                        : "#DBEAFE"
                    border.color: "#FFFFFF"
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: modelData && modelData.initials ? modelData.initials : ""
                        color: modelData && modelData.foreground
                            ? modelData.foreground
                            : "#1E3A8A"
                        font.family: control.fontFamilyMono
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                }
            }
        }

        // Add button
        Item {
            width: control.showAddButton ? (control.addSpacing + control.avatarSize) : 0
            height: control.avatarSize
            visible: control.showAddButton

            Rectangle {
                width: control.avatarSize
                height: control.avatarSize
                radius: width / 2
                anchors.right: parent.right
                color: "transparent"
                border.color: control.addBorderColor
                border.width: 2
                // Dashed border not supported directly; we rely on solid
                // 2 px border and rely on consumer to infer affordance.

                Text {
                    anchors.centerIn: parent
                    text: "+"
                    color: control.addTextColor
                    font.pixelSize: 16
                    renderType: Text.NativeRendering
                    antialiasing: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: control.addRequested()
                }
            }
        }
    }
}
