// Source: design_handoff_onboarding/README.md (Primitives section)
// Welcome-step list row: 32x32 outlined icon square + title + optional
// secondary description. Static read-only display atom.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property url iconSource: ""
    property string title: ""
    property string description: ""
    property int iconSize: 32
    property int iconRadius: 6
    property int columnGap: 12

    property color iconBackground: "#FFFFFF"
    property color iconBorder: "#E2E8F0"
    property color iconTint: "#1A202C"
    property color titleColor: "#1A202C"
    property color descriptionColor: "#6B7280"

    property string fontFamilyUI: Tokens.font.ui

    implicitWidth: _row.implicitWidth
    implicitHeight: Math.max(iconSize, _text.implicitHeight)

    RowLayout {
        id: _row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: control.columnGap

        Rectangle {
            Layout.preferredWidth: control.iconSize
            Layout.preferredHeight: control.iconSize
            Layout.alignment: Qt.AlignTop
            radius: control.iconRadius
            color: control.iconBackground
            border.color: control.iconBorder
            border.width: 1

            Image {
                anchors.centerIn: parent
                source: control.iconSource
                visible: control.iconSource.toString() !== ""
                width: control.iconSize - 12
                height: control.iconSize - 12
                sourceSize: Qt.size(control.iconSize - 12, control.iconSize - 12)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
        }

        ColumnLayout {
            id: _text
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: control.title
                color: control.titleColor
                font.family: control.fontFamilyUI
                font.pixelSize: 13
                font.weight: Font.Medium
                renderType: Text.NativeRendering
                antialiasing: true
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Text {
                visible: control.description !== ""
                text: control.description
                color: control.descriptionColor
                font.family: control.fontFamilyUI
                font.pixelSize: 12
                lineHeight: 1.5
                lineHeightMode: Text.ProportionalHeight
                renderType: Text.NativeRendering
                antialiasing: true
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}
