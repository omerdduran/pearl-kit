// Source: design_handoff_settings/src/settings.jsx:97-111
// 2-column settings form row: label (+ optional hint) on the left,
// control in a single default-property slot on the right. Bottom
// hairline between rows. Inline mode uses a 200px label column; when
// inline is false the label stacks above the control.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string label: ""
    property string hint: ""
    property bool inline: true
    property int labelWidth: 200
    property int columnGap: 24
    property int verticalPadding: 16

    property string fontFamilyUI: Tokens.font.ui

    default property alias slotContent: _slot.data

    implicitWidth: 640
    implicitHeight: _content.implicitHeight + verticalPadding * 2 + 1

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
        anchors.top: parent.top
        anchors.topMargin: control.verticalPadding
        implicitHeight: control.inline
            ? Math.max(_labelCol.implicitHeight, _slot.implicitHeight)
            : (_labelCol.implicitHeight + 8 + _slot.implicitHeight)
        height: implicitHeight

        ColumnLayout {
            id: _labelCol
            anchors.left: parent.left
            anchors.top: parent.top
            width: control.inline ? control.labelWidth : parent.width
            spacing: 3

            Text {
                text: control.label
                color: "#1A202C"
                font.family: control.fontFamilyUI
                font.pixelSize: 13
                font.weight: Font.Medium
                renderType: Text.NativeRendering
                antialiasing: true
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }

            Text {
                text: control.hint
                color: "#6B7280"
                font.family: control.fontFamilyUI
                font.pixelSize: 12
                lineHeight: 1.5
                lineHeightMode: Text.ProportionalHeight
                renderType: Text.NativeRendering
                antialiasing: true
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                visible: control.hint !== ""
            }
        }

        Item {
            id: _slot
            anchors.left: control.inline ? undefined : parent.left
            anchors.leftMargin: control.inline ? 0 : 0
            anchors.top: control.inline ? parent.top : _labelCol.bottom
            anchors.topMargin: control.inline ? 0 : 8
            anchors.right: parent.right
            anchors.rightMargin: 0
            x: control.inline ? (control.labelWidth + control.columnGap) : 0
            width: control.inline
                ? (parent.width - control.labelWidth - control.columnGap)
                : parent.width
            implicitHeight: children.length > 0 ? children[0].implicitHeight : 0
            height: implicitHeight
        }
    }
}
