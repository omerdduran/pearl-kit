// Source: design_handoff_planning_workspace/src/report-tab.jsx:162-200
// Tap-to-acknowledge checklist row with severity dot + uppercase label +
// title + multi-line body. Checked items fade to 60% opacity.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string text: ""
    property string severity: "info"      // "warn" | "info" | "note"
    property bool checked: false
    property bool showBody: true
    property string body: ""

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    signal toggled()

    implicitWidth: 480
    implicitHeight: _content.implicitHeight + 24

    readonly property color _dotColor: {
        switch (control.severity) {
            case "warn": return "#B45309"
            case "note": return "#6B7280"
            default:     return "#2563EB"
        }
    }
    readonly property string _severityLabel: {
        switch (control.severity) {
            case "warn": return "ACTION"
            case "note": return "NOTE"
            default:     return "CONFIRM"
        }
    }

    // Bottom hairline
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: "#F1F5F9"
    }

    Item {
        id: _content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: _row.implicitHeight
        opacity: control.checked ? 0.6 : 1.0
        Behavior on opacity { NumberAnimation { duration: Tokens.motion.fast } }

        RowLayout {
            id: _row
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 12

            // Checkbox
            Rectangle {
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                Layout.topMargin: 2
                radius: 3
                color: control.checked ? "#10B981" : "#FFFFFF"
                border.color: control.checked ? "#10B981" : "#CBD5E1"
                border.width: 2
                Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
                Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast } }

                Text {
                    visible: control.checked
                    text: "\u2713"
                    anchors.centerIn: parent
                    color: "#FFFFFF"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    renderType: Text.NativeRendering
                    antialiasing: true
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        Layout.preferredWidth: 5
                        Layout.preferredHeight: 5
                        Layout.alignment: Qt.AlignVCenter
                        radius: 3
                        color: control._dotColor
                    }

                    Text {
                        text: control._severityLabel
                        color: control._dotColor
                        font.family: control.fontFamilyMono
                        font.pixelSize: 10
                        font.letterSpacing: 1.2
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                        antialiasing: true
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: control.text
                        color: "#1A202C"
                        font.family: control.fontFamilyUI
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        renderType: Text.NativeRendering
                        antialiasing: true
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }

                Text {
                    text: control.body
                    color: "#6B7280"
                    font.family: control.fontFamilyUI
                    font.pixelSize: 12
                    lineHeight: 1.6
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.WordWrap
                    renderType: Text.NativeRendering
                    antialiasing: true
                    Layout.fillWidth: true
                    Layout.leftMargin: 13
                    visible: control.showBody && control.body !== ""
                }
            }
        }
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
