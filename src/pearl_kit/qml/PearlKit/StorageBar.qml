// Source: design_handoff_settings/src/settings.jsx:571-584
// 3-row disk / storage meter: top row mono label + right-aligned
// percentage; middle 6 px track + blue fill; bottom mono muted caption.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property real used: 0
    property real total: 1
    property string unit: "GB"
    property string topLabel: ""
    property string bottomLabel: ""

    property string fontFamilyMono: Tokens.font.mono
    property color trackColor: "#F1F5F9"
    property color fillColor: "#2563EB"

    readonly property real _ratio: {
        if (control.total <= 0) return 0
        return Math.max(0, Math.min(1, control.used / control.total))
    }
    readonly property int _percent: Math.round(control._ratio * 100)

    implicitWidth: 340
    implicitHeight: _col.implicitHeight

    Column {
        id: _col
        width: parent.width
        spacing: 4

        // Top: label + percentage
        Item {
            width: parent.width
            height: Math.max(_top.implicitHeight, _pct.implicitHeight)

            Text {
                id: _top
                text: control.topLabel
                color: "#6B7280"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                renderType: Text.NativeRendering
                antialiasing: true
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                visible: control.topLabel !== ""
            }

            Text {
                id: _pct
                text: control._percent + "%"
                color: "#1A202C"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                renderType: Text.NativeRendering
                antialiasing: true
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Bar
        Rectangle {
            width: parent.width
            height: 6
            radius: 3
            color: control.trackColor
            clip: true

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * control._ratio
                color: control.fillColor
                Behavior on width { NumberAnimation { duration: 200 } }
            }
        }

        // Bottom caption
        Text {
            text: control.bottomLabel
            color: "#9CA3AF"
            font.family: control.fontFamilyMono
            font.pixelSize: 10
            font.letterSpacing: 0.4
            renderType: Text.NativeRendering
            antialiasing: true
            visible: control.bottomLabel !== ""
        }
    }
}
