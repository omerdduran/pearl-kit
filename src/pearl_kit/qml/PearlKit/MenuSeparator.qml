import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

T.MenuSeparator {
    id: control

    padding: 0
    topPadding: Tokens.space.x1
    bottomPadding: Tokens.space.x1
    leftPadding: 0
    rightPadding: 0

    contentItem: Item {
        implicitWidth: 192
        implicitHeight: 1

        Rectangle {
            height: 1
            color: Tokens.border
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin:  -Tokens.space.x1
            anchors.rightMargin: -Tokens.space.x1
        }
    }
}
