// Source: design_handoff_settings/src/settings.jsx:963-987
// Sidebar nav row: 28 px mono index column + (title + subtitle) column.
// Active state tints the whole tile blue.
import QtQuick
import PearlKit 1.0

Rectangle {
    id: control

    property string index: ""
    property string label: ""
    property string subtitle: ""
    property bool checked: false

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    signal clicked()

    implicitWidth: 240
    implicitHeight: 48

    readonly property color _bg: control.checked
        ? "#EFF6FF"
        : (_area.containsMouse ? "#F7FAFE" : "transparent")
    readonly property color _border: control.checked ? "#BFDBFE" : "transparent"
    readonly property color _indexColor: control.checked ? "#2563EB" : "#9CA3AF"
    readonly property color _titleColor: control.checked ? "#1E3A8A" : "#1A202C"
    readonly property color _subtitleColor: control.checked ? "#3B82F6" : "#9CA3AF"

    radius: 5
    color: control._bg
    border.color: control._border
    border.width: 1
    Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }

    Text {
        id: _index
        text: control.index
        color: control._indexColor
        font.family: control.fontFamilyMono
        font.pixelSize: 10
        font.letterSpacing: 0.8
        font.weight: Font.Medium
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: _title
        text: control.label
        color: control._titleColor
        font.family: control.fontFamilyUI
        font.pixelSize: 13
        font.weight: control.checked ? Font.DemiBold : Font.Medium
        renderType: Text.NativeRendering
        antialiasing: true
        elide: Text.ElideRight
        anchors.left: _index.right
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 10
        y: control.subtitle !== "" ? 8 : (parent.height - implicitHeight) / 2
    }

    Text {
        text: control.subtitle
        color: control._subtitleColor
        font.family: control.fontFamilyUI
        font.pixelSize: 11
        renderType: Text.NativeRendering
        antialiasing: true
        elide: Text.ElideRight
        anchors.left: _index.right
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: _title.bottom
        anchors.topMargin: 2
        visible: control.subtitle !== ""
    }

    MouseArea {
        id: _area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: control.clicked()
    }
}
