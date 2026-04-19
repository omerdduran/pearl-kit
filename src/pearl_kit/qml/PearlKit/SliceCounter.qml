// SliceCounter — top-right `142 / 512` mono label chip for a 2D viewport.
//
// A standalone variant of the slice counter Viewport2D draws internally.
// Use this when you want to overlay a counter onto a custom viewport host
// (e.g. the native ImageViewport) where the built-in chrome isn't desired.

import QtQuick

Rectangle {
    id: control

    property int slice: 0
    property int total: 0

    visible: total > 0
    color: Qt.rgba(3 / 255, 8 / 255, 22 / 255, 0.55)
    radius: 2
    width: _label.implicitWidth + 14
    height: _label.implicitHeight + 6

    Text {
        id: _label
        anchors.centerIn: parent
        text: control.slice + " / " + control.total
        color: "#CBD5E1"
        font.family: Tokens.font.mono
        font.pixelSize: 10
        font.letterSpacing: 0.8
        renderType: Text.NativeRendering
        antialiasing: true
    }
}
