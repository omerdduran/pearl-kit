// Source: design_handoff_settings/src/settings.jsx:113-131
// Text input with the settings form visual weight (radius 4, 7x10
// padding, border #E2E8F0) plus an optional mono right-edge suffix
// label. Switches input font to JetBrains Mono when `mono` is true
// (used for emails, license numbers, WL/WW values, DICOM nodes).
import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

T.TextField {
    id: control

    property string suffix: ""
    property bool mono: false
    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    selectByMouse: true
    selectionColor: Qt.rgba(37 / 255, 99 / 255, 235 / 255, 0.3)
    selectedTextColor: "#1A202C"

    implicitWidth: 200
    implicitHeight: 32
    padding: 0
    leftPadding: 10
    rightPadding: control.suffix !== "" ? 40 : 10
    topPadding: 7
    bottomPadding: 7

    color: "#1A202C"
    placeholderTextColor: "#9CA3AF"
    font.family: control.mono ? control.fontFamilyMono : control.fontFamilyUI
    font.pixelSize: 12

    background: Rectangle {
        radius: 4
        color: "#FFFFFF"
        border.color: control.activeFocus ? "#2563EB" : "#E2E8F0"
        border.width: 1
        Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast } }
    }

    Text {
        visible: control.suffix !== ""
        text: control.suffix
        color: "#9CA3AF"
        font.family: control.fontFamilyMono
        font.pixelSize: 11
        font.letterSpacing: 0.66
        font.capitalization: Font.AllUppercase
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }
}
