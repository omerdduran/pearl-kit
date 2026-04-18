import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.MenuBar {
    id: control

    hoverEnabled: true
    padding: Tokens.space.x1
    spacing: Tokens.space.x1
    implicitHeight: 36

    background: Rectangle {
        color: Tokens.background
        radius: Tokens.radius.md
        border.color: Tokens.border
        border.width: 1
    }

    contentItem: Row {
        spacing: control.spacing
        Repeater { model: control.contentModel }
    }

    delegate: T.MenuBarItem {
        id: item

        hoverEnabled: true
        focusPolicy: Qt.StrongFocus
        padding: 0
        leftPadding: Tokens.space.x2
        rightPadding: Tokens.space.x2
        topPadding: Tokens.space.x1
        bottomPadding: Tokens.space.x1

        readonly property bool _active:
            item.highlighted || item.hovered || (item.menu && item.menu.opened)

        contentItem: PearlBaseText {
            text: item.text
            textFormat: Text.StyledText
            font.pixelSize: Tokens.font.size.sm
            font.weight: Tokens.font.weight.medium
            color: item._active ? Tokens.accentForeground : Tokens.foreground
            opacity: item.enabled ? 1.0 : 0.5
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        background: Rectangle {
            radius: Tokens.radius.sm
            color: item._active ? Tokens.accent : "transparent"
            opacity: item.enabled ? 1.0 : 0.5
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }
    }
}
