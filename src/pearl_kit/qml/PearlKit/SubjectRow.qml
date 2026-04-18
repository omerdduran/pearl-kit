// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:349-378
// Implant-list row: 28×28 colored ID square + title + caption + optional
// status dot. Selected row gets tinted blue; warn status gets amber square
// + glowing dot.
import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

T.AbstractButton {
    id: control

    property string identifier: "I1"
    property string title: ""
    property string caption: ""
    property string status: "neutral"     // "ok" | "warn" | "info" | "neutral"
    property bool selected: false

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    implicitHeight: _row.implicitHeight + 20
    implicitWidth: 280

    readonly property color _statusColor: {
        switch (control.status) {
            case "warn": return "#F59E0B"
            case "info": return "#3B82F6"
            case "ok":   return "#2563EB"
            default:     return "#2563EB"
        }
    }

    readonly property color _squareBg: control.selected
        ? control._statusColor
        : "#F1F5F9"
    readonly property color _squareFg: control.selected ? "#FFFFFF" : "#6B7280"

    readonly property color _rowBg: control.selected
        ? "#EFF6FF"
        : (control.hovered ? "#F7FAFE" : "transparent")
    readonly property color _rowBorder: control.selected ? "#BFDBFE" : "#F1F5F9"

    background: Rectangle {
        radius: 6
        color: control._rowBg
        border.color: control._rowBorder
        border.width: 1
        Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
    }

    contentItem: Row {
        id: _row
        spacing: 12
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12

        Rectangle {
            width: 28
            height: 28
            radius: 4
            color: control._squareBg
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }

            Text {
                anchors.centerIn: parent
                text: control.identifier
                color: control._squareFg
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.weight: Font.Bold
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            width: _row.width - 28 - 12 - (control.status === "warn" ? 18 : 0)

            Text {
                text: control.title
                color: "#1A202C"
                font.family: control.fontFamilyUI
                font.pixelSize: 13
                font.weight: Font.Medium
                renderType: Text.NativeRendering
                antialiasing: true
                elide: Text.ElideRight
                width: parent.width
            }

            Text {
                text: control.caption
                color: "#6B7280"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                renderType: Text.NativeRendering
                antialiasing: true
                elide: Text.ElideRight
                width: parent.width
                visible: control.caption !== ""
            }
        }

        Rectangle {
            visible: control.status === "warn"
            width: 8
            height: 8
            radius: 4
            color: "#F59E0B"
            anchors.verticalCenter: parent.verticalCenter
            // Glow simulated via a larger, lower-opacity ring behind
            Rectangle {
                anchors.centerIn: parent
                width: 16
                height: 16
                radius: 8
                color: "transparent"
                border.color: Qt.rgba(245 / 255, 158 / 255, 11 / 255, 0.5)
                border.width: 2
                opacity: 0.5
                z: -1
            }
        }
    }
}
