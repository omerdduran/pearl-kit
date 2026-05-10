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

    // Theme-driven palette: derives from pearl-kit Tokens so the surface
    // adapts to Dark / Light without per-consumer overrides. Active-state
    // backgrounds use a semi-transparent ``primary`` tint that reads on
    // any base; text falls back to ``foreground`` / ``mutedForeground``
    // for the resting / dimmed channels.
    readonly property color _bg: control.checked
        ? Qt.rgba(Tokens.primary.r, Tokens.primary.g, Tokens.primary.b, 0.12)
        : (_area.containsMouse
            ? Qt.rgba(Tokens.foreground.r, Tokens.foreground.g, Tokens.foreground.b, 0.04)
            : "transparent")
    readonly property color _border: control.checked
        ? Qt.rgba(Tokens.primary.r, Tokens.primary.g, Tokens.primary.b, 0.32)
        : "transparent"
    readonly property color _indexColor: control.checked ? Tokens.primary : Tokens.mutedForeground
    readonly property color _titleColor: control.checked ? Tokens.primary : Tokens.foreground
    readonly property color _subtitleColor: control.checked ? Tokens.primary : Tokens.mutedForeground

    radius: 5
    color: control._bg
    border.color: control._border
    border.width: 1

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
