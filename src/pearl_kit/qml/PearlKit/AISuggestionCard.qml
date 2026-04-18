// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:456-473
// Tinted info card with icon badge + eyebrow + model tag + body + primary
// action button. Compound of IconBadge + Button inside an InfoCard-like
// shell. Hardcoded #EFF6FF / #DBEAFE mirrors the handoff exactly.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string title: "AI suggests"
    property string modelTag: ""
    property string body: ""
    property string actionLabel: ""
    property url iconSource: ""

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    signal applied()

    implicitWidth: 280
    implicitHeight: _col.implicitHeight + 24

    Rectangle {
        anchors.fill: parent
        radius: 6
        color: "#EFF6FF"
        border.color: "#DBEAFE"
        border.width: 1
    }

    ColumnLayout {
        id: _col
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            IconBadge {
                tone: "info"
                gradient: true
                iconSource: control.iconSource
            }

            Text {
                text: control.title
                color: "#1E3A8A"
                font.family: control.fontFamilyUI
                font.pixelSize: 12
                font.weight: Font.DemiBold
                renderType: Text.NativeRendering
                antialiasing: true
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            Text {
                text: control.modelTag
                color: "#3B82F6"
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                renderType: Text.NativeRendering
                antialiasing: true
                Layout.alignment: Qt.AlignVCenter
                visible: control.modelTag !== ""
            }
        }

        Text {
            text: control.body
            color: "#1E3A8A"
            font.family: control.fontFamilyUI
            font.pixelSize: 12
            lineHeight: 1.55
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.WordWrap
            renderType: Text.NativeRendering
            antialiasing: true
            Layout.fillWidth: true
        }

        Button {
            text: control.actionLabel
            variant: "default"
            size: "sm"
            visible: control.actionLabel !== ""
            onClicked: control.applied()
        }
    }
}
