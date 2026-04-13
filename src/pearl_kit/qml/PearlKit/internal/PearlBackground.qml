import QtQuick
import PearlKit 1.0

Rectangle {
    id: bg
    property bool hovered: false
    property bool pressed: false
    property bool active: false
    color: pressed ? Tokens.accent
          : hovered ? Tokens.muted
          : active ? Tokens.accent
          : Tokens.card
    radius: Tokens.radius.md
    border.color: Tokens.border
    border.width: 1
    Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
}
