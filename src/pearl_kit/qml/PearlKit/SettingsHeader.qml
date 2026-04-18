// Source: design_handoff_settings/src/settings.jsx:213-227
// Page-level section header: mono eyebrow + 28 px serif title + 13 px
// muted description (max-width 640 px). Smaller sibling of EditorialHero.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string eyebrow: ""
    property string title: ""
    property string description: ""
    property int maxDescriptionWidth: 640

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui
    property string fontFamilySerif: "Times New Roman"

    property color eyebrowColor: "#9CA3AF"
    property color titleColor: "#1A202C"
    property color descriptionColor: "#6B7280"

    implicitWidth: 640
    implicitHeight: _col.implicitHeight + 20

    Column {
        id: _col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 8

        Text {
            text: control.eyebrow
            color: control.eyebrowColor
            font.family: control.fontFamilyMono
            font.pixelSize: 10
            font.letterSpacing: 1.5
            font.capitalization: Font.AllUppercase
            renderType: Text.NativeRendering
            antialiasing: true
            visible: control.eyebrow !== ""
        }

        Text {
            text: control.title
            color: control.titleColor
            font.family: control.fontFamilySerif
            font.pixelSize: 28
            font.letterSpacing: -0.015 * 28
            lineHeight: 1.15
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.WordWrap
            width: parent.width
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Text {
            text: control.description
            color: control.descriptionColor
            font.family: control.fontFamilyUI
            font.pixelSize: 13
            lineHeight: 1.55
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.WordWrap
            width: Math.min(parent.width, control.maxDescriptionWidth)
            renderType: Text.NativeRendering
            antialiasing: true
            visible: control.description !== ""
        }
    }
}
