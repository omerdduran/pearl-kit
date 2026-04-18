// Source: design_handoff_planning_workspace/src/report-tab.jsx:100-124
// Chat turn. User = blue DR. KAYA label + muted panel bubble. AI = grey
// DALI label + 2px left-border text block. Optional outline action chip.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string role: "ai"           // "user" | "ai"
    property string author: ""           // e.g. "DR. KAYA" or "DALI"
    property string text: ""
    property string actionLabel: ""

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    signal action()

    readonly property bool _isUser: role === "user"

    implicitWidth: 320
    implicitHeight: _col.implicitHeight

    ColumnLayout {
        id: _col
        width: parent.width
        spacing: 4

        Text {
            text: control.author
            color: control._isUser ? "#2563EB" : "#6B7280"
            font.family: control.fontFamilyMono
            font.pixelSize: 10
            font.letterSpacing: 0.8
            font.capitalization: Font.AllUppercase
            renderType: Text.NativeRendering
            antialiasing: true
            visible: control.author !== ""
        }

        Rectangle {
            Layout.fillWidth: true
            color: control._isUser ? "#F7F8FA" : "transparent"
            radius: control._isUser ? 3 : 0
            implicitHeight: _body.implicitHeight + (control._isUser ? 16 : 0)
            Layout.preferredHeight: _body.implicitHeight + (control._isUser ? 16 : 0)

            Rectangle {
                visible: !control._isUser
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 2
                color: "#E2E8F0"
            }

            Text {
                id: _body
                text: control.text
                color: "#1A202C"
                font.family: control.fontFamilyUI
                font.pixelSize: 13
                lineHeight: 1.6
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.WordWrap
                renderType: Text.NativeRendering
                antialiasing: true
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: control._isUser ? 8 : 0
            }
        }

        RowLayout {
            Layout.leftMargin: 12
            spacing: 8
            visible: control.actionLabel !== ""

            Chip {
                text: control.actionLabel
                variant: "outline"
                onClicked: control.action()
            }
        }
    }
}
