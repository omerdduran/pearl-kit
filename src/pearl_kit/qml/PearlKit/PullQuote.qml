// Source: design_handoff_planning_workspace/src/report-tab.jsx:527-533
// Editorial pull-quote — large " glyph on the left + italic wrapped text.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string text: ""
    property string quoteGlyph: "\u201C"
    property int maxWidth: 720

    property string fontFamilyUI: Tokens.font.ui
    property string fontFamilySerif: "Times New Roman"

    property color quoteColor: "#1A202C"
    property color textColor: "#4A5568"

    implicitWidth: Math.min(maxWidth, _glyph.implicitWidth + 16 + _text.implicitWidth)
    implicitHeight: Math.max(_glyph.implicitHeight, _text.implicitHeight)

    Text {
        id: _glyph
        text: control.quoteGlyph
        color: control.quoteColor
        font.family: control.fontFamilySerif
        font.pixelSize: 42
        font.letterSpacing: -0.02 * 42
        lineHeight: 0.9
        lineHeightMode: Text.ProportionalHeight
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.left: parent.left
        anchors.top: parent.top
        width: 40
    }

    Text {
        id: _text
        text: control.text
        color: control.textColor
        font.family: control.fontFamilyUI
        font.pixelSize: 13
        font.italic: true
        lineHeight: 1.65
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.WordWrap
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.left: _glyph.right
        anchors.leftMargin: 16
        anchors.right: parent.right
        anchors.top: parent.top
    }
}
