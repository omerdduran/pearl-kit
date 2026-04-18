import QtQuick
import QtQuick as QQ
import QtQuick.Controls.Basic as QC
import QtQuick.Layouts
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.Control {
    id: control

    // ---- public API
    property string variant: "card"          // "card" | "flush"
    property bool showSeparators: false
    property string emptyText: ""
    property int rowHeight: 36

    property alias model:         _lv.model
    property alias delegate:      _lv.delegate
    property alias currentIndex:  _lv.currentIndex
    property alias count:         _lv.count
    property alias orientation:   _lv.orientation
    property alias header:        _lv.header
    property alias footer:        _lv.footer

    signal itemClicked(int index)
    signal itemActivated(int index)

    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    padding: 0

    implicitWidth:  240
    implicitHeight: 240

    // ---- background (card chrome)
    background: Rectangle {
        visible: control.variant === "card"
        color: Tokens.card
        radius: Tokens.radius.md
        border.color: Tokens.border
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5
    }

    // ---- contentItem is the native ListView
    contentItem: QQ.ListView {
        id: _lv
        clip: true
        focus: true
        keyNavigationEnabled: true
        keyNavigationWraps: false
        boundsBehavior: Flickable.StopAtBounds
        opacity: control.enabled ? 1.0 : 0.5
        currentIndex: -1
        spacing: control.spacing

        delegate: control._defaultDelegate

        Keys.onReturnPressed: if (currentIndex >= 0) control.itemActivated(currentIndex)
        Keys.onEnterPressed:  if (currentIndex >= 0) control.itemActivated(currentIndex)

        HoverHandler {
            id: _hover
        }

        QC.ScrollBar.vertical: T.ScrollBar {
            id: _vbar
            implicitWidth: 10
            padding: 1
            minimumSize: 0.1
            policy: T.ScrollBar.AsNeeded
            opacity: (_hover.hovered || _vbar.active || _vbar.hovered) ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation { duration: Tokens.motion.base; easing.type: Easing.OutCubic }
            }
            contentItem: Rectangle {
                implicitWidth: 8
                radius: width / 2
                color: _vbar.pressed
                       ? Tokens.mutedForeground
                       : (_vbar.hovered
                          ? Qt.rgba(Tokens.mutedForeground.r, Tokens.mutedForeground.g, Tokens.mutedForeground.b, 0.8)
                          : Tokens.border)
                Behavior on color {
                    ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
                }
            }
            background: Item { }
        }

        PearlBaseText {
            anchors.centerIn: parent
            visible: _lv.count === 0 && control.emptyText !== ""
            text: control.emptyText
            color: Tokens.mutedForeground
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // ---- default delegate (shadcn Command-style row)
    property Component _defaultDelegate: Component {
        T.ItemDelegate {
            id: item
            width: QQ.ListView.view ? QQ.ListView.view.width : implicitWidth
            height: control.rowHeight
            hoverEnabled: true
            focusPolicy: Qt.NoFocus
            padding: 0
            leftPadding: Tokens.space.x2
            rightPadding: Tokens.space.x2

            readonly property bool _rowEnabled: {
                if (model && model.enabled !== undefined) return model.enabled
                if (modelData && typeof modelData === "object" && modelData.enabled !== undefined) return modelData.enabled
                return true
            }
            readonly property string _label: {
                if (modelData !== undefined && typeof modelData !== "object") return String(modelData)
                if (model && model.label !== undefined) return model.label
                if (modelData && typeof modelData === "object" && modelData.label !== undefined) return modelData.label
                return ""
            }
            readonly property url _iconSource: {
                if (model && model.iconSource !== undefined) return model.iconSource
                if (modelData && typeof modelData === "object" && modelData.iconSource !== undefined) return modelData.iconSource
                return ""
            }
            readonly property string _trailing: {
                if (model && model.trailing !== undefined) return model.trailing
                if (modelData && typeof modelData === "object" && modelData.trailing !== undefined) return modelData.trailing
                return ""
            }
            readonly property bool _active: (QQ.ListView.isCurrentItem || hovered) && _rowEnabled

            enabled: _rowEnabled

            onClicked: {
                QQ.ListView.view.currentIndex = index
                control.itemClicked(index)
            }
            onDoubleClicked: control.itemActivated(index)

            background: Rectangle {
                color: item._active ? Tokens.accent : "transparent"
                radius: Tokens.radius.sm
                opacity: item.enabled ? 1.0 : 0.5
                Behavior on color {
                    ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
                }
                Rectangle {
                    visible: control.showSeparators && index < (QQ.ListView.view ? QQ.ListView.view.count - 1 : 0)
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: Tokens.border
                }
            }

            contentItem: RowLayout {
                spacing: Tokens.space.x2

                Image {
                    visible: item._iconSource != ""
                    source: item._iconSource
                    sourceSize: Qt.size(16, 16)
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    fillMode: Image.PreserveAspectFit
                }

                PearlBaseText {
                    Layout.fillWidth: true
                    text: item._label
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    color: item._active ? Tokens.accentForeground : Tokens.foreground
                    Behavior on color {
                        ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
                    }
                }

                PearlBaseText {
                    visible: item._trailing !== ""
                    text: item._trailing
                    font.pixelSize: Tokens.font.size.xs
                    color: Tokens.mutedForeground
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // ---- focus ring (keyboard-only, wraps outer container)
    PearlFocusRing {
        target: control
        offset: 0
        ringWidth: 3
        ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
