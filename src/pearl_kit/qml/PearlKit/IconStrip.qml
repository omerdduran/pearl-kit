import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

Rectangle {
    id: control

    // ---- public API
    property int stripWidth: 48
    property int tileHeight: 52
    property int iconSize: 20
    property bool showLabels: true
    property var items: []
    property var footerItems: []
    property string activeKey: ""

    signal itemClicked(string key)

    // ---- geometry
    implicitWidth: stripWidth
    implicitHeight: _topColumn.implicitHeight + _footerColumn.implicitHeight + 32
    width: stripWidth
    color: Tokens.muted
    opacity: enabled ? 1.0 : 0.5

    Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }

    Column {
        id: _topColumn
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        Repeater {
            model: control.items
            delegate: _tileDelegate
        }
    }

    Column {
        id: _footerColumn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        Repeater {
            model: control.footerItems
            delegate: _tileDelegate
        }
    }

    Component {
        id: _tileDelegate

        T.AbstractButton {
            id: tile

            required property var modelData

            readonly property string _key: (modelData && modelData.key !== undefined) ? modelData.key : ""
            readonly property url _iconSource: (modelData && modelData.iconSource !== undefined) ? modelData.iconSource : ""
            readonly property string _label: (modelData && modelData.label !== undefined) ? modelData.label : ""
            readonly property bool _active: control.activeKey !== "" && control.activeKey === _key

            width: control.stripWidth
            height: control.tileHeight
            checkable: false
            checked: _active
            hoverEnabled: true
            focusPolicy: Qt.StrongFocus

            onClicked: control.itemClicked(_key)

            background: Item {
                anchors.fill: parent
                opacity: tile.enabled ? 1.0 : 0.5

                Rectangle {
                    id: tileFill
                    anchors.fill: parent
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    anchors.topMargin: 2
                    anchors.bottomMargin: 2
                    radius: Tokens.radius.md
                    color: tile._active
                        ? Tokens.accent
                        : (tile.hovered ? Qt.rgba(Tokens.accent.r, Tokens.accent.g, Tokens.accent.b, 0.6) : "transparent")

                    Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
                }

                Rectangle {
                    id: indicator
                    visible: tile._active
                    width: 3
                    height: 16
                    radius: 1
                    color: Tokens.primary
                    x: 0
                    y: (parent.height - height) / 2
                }
            }

            contentItem: Item {
                anchors.fill: parent
                opacity: tile.enabled ? 1.0 : 0.5

                Column {
                    anchors.centerIn: parent
                    spacing: 2

                    Image {
                        source: tile._iconSource
                        visible: tile._iconSource != ""
                        width: control.iconSize
                        height: control.iconSize
                        sourceSize: Qt.size(control.iconSize, control.iconSize)
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        opacity: (tile._active || tile.hovered) ? 1.0 : 0.6
                        Behavior on opacity { NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
                    }

                    PearlBaseText {
                        text: tile._label
                        visible: control.showLabels && tile._label !== ""
                        font.pixelSize: 11
                        font.weight: Tokens.font.weight.regular
                        color: tile._active ? Tokens.foreground : Tokens.mutedForeground
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        opacity: (tile._active || tile.hovered) ? 1.0 : 0.8
                        Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
                    }
                }
            }

            PearlFocusRing {
                target: tile
                offset: 0
                ringWidth: 3
                ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
                visible: tile.visualFocus
            }
        }
    }
}
