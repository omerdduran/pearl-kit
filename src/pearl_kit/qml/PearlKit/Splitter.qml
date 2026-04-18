import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.SplitView {
    id: control

    // ---- public API
    property bool withHandle: false

    // ---- persistence passthrough
    function saveLayout() { return control.saveState() }
    function restoreLayout(state) { return control.restoreState(state) }

    // ---- handle delegate
    handle: Item {
        id: handleRoot

        readonly property bool horizontal: control.orientation === Qt.Horizontal

        implicitWidth:  horizontal ? 6 : control.width
        implicitHeight: horizontal ? control.height : 6

        Rectangle {
            id: hairline
            anchors.centerIn: parent
            width:  handleRoot.horizontal ? 1 : handleRoot.width
            height: handleRoot.horizontal ? handleRoot.height : 1
            color: (T.SplitHandle.pressed || T.SplitHandle.hovered)
                 ? Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.6)
                 : Tokens.border
            opacity: control.enabled ? 1.0 : 0.5
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        Rectangle {
            id: grip
            visible: control.withHandle
            anchors.centerIn: parent
            width:  handleRoot.horizontal ? 12 : 16
            height: handleRoot.horizontal ? 16 : 12
            radius: Tokens.radius.sm
            color: Tokens.border
            border.color: Tokens.border
            border.width: 1
            opacity: control.enabled ? 1.0 : 0.5

            Column {
                visible: handleRoot.horizontal
                anchors.centerIn: parent
                spacing: 2
                Repeater {
                    model: 3
                    Rectangle { width: 2; height: 2; radius: 1; color: Tokens.mutedForeground }
                }
            }

            Row {
                visible: !handleRoot.horizontal
                anchors.centerIn: parent
                spacing: 2
                Repeater {
                    model: 3
                    Rectangle { width: 2; height: 2; radius: 1; color: Tokens.mutedForeground }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: handleRoot.horizontal ? Qt.SplitHCursor : Qt.SplitVCursor
            acceptedButtons: Qt.NoButton
        }

        PearlFocusRing {
            target: handleRoot
            offset: 0
            ringWidth: 3
            ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
            visible: handleRoot.activeFocus
        }
    }
}
