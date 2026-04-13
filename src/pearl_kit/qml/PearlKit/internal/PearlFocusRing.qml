import QtQuick
import PearlKit 1.0

Rectangle {
    id: ring
    property Item target: parent
    property int offset: 2
    property int ringWidth: 2
    property color ringColor: Tokens.ring
    z: 65535
    visible: target && target.activeFocus
    anchors.fill: target
    anchors.margins: -offset
    color: "transparent"
    radius: (target && target.radius !== undefined ? target.radius : Tokens.radius.md) + offset
    border.color: ringColor
    border.width: ringWidth
    clip: false
}
