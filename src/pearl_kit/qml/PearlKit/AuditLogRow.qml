// Source: design_handoff_settings/src/settings.jsx:862-870
// 3-col audit log row: time (mono 11, #1A202C) | date (mono 10.5 muted)
// | severity dot + event description. 1 px bottom hairline.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string time: ""
    property string date: ""
    property string event: ""
    property string severity: "info"      // "ok" | "info" | "warn"
    property bool showBottomHairline: true

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    readonly property color _dotColor: {
        switch (control.severity) {
            case "ok":   return "#10B981"
            case "warn": return "#F59E0B"
            default:     return "#2563EB"
        }
    }

    implicitWidth: 520
    implicitHeight: 36

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"

        Rectangle {
            visible: control.showBottomHairline
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: "#F1F5F9"
        }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14

        Text {
            id: _time
            text: control.time
            color: "#1A202C"
            font.family: control.fontFamilyMono
            font.pixelSize: 11
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 80
        }

        Text {
            id: _date
            text: control.date
            color: "#9CA3AF"
            font.family: control.fontFamilyMono
            font.pixelSize: 11
            font.letterSpacing: 0.44
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.left: _time.right
            anchors.verticalCenter: parent.verticalCenter
            width: 90
        }

        Row {
            anchors.left: _date.right
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Rectangle {
                width: 5
                height: 5
                radius: 3
                color: control._dotColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: control.event
                color: "#4A5568"
                font.family: control.fontFamilyUI
                font.pixelSize: 12
                renderType: Text.NativeRendering
                antialiasing: true
                elide: Text.ElideRight
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 13
            }
        }
    }
}
