import QtQuick
import PearlKit 1.0

Text {
    id: control

    property string fontFamily: Tokens.font.mono

    text: ""
    color: "#8A93A0"
    font.family: control.fontFamily
    font.pixelSize: 10
    font.weight: Font.Medium
    font.letterSpacing: 0.8
    font.capitalization: Font.AllUppercase
    renderType: Text.NativeRendering
    antialiasing: true
    lineHeight: 1.0
    lineHeightMode: Text.ProportionalHeight
}
