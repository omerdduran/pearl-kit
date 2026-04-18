import QtQuick
import PearlKit 1.0
import PearlKit.internal 1.0

Item {
    id: control

    // ---- public API
    property string title: ""
    property string description: ""
    property bool collapsible: false
    property bool expanded: true
    property bool advanced: false
    property bool advancedVisible: true

    default property alias content: _innerColumn.data

    // ---- advanced gate: hide entirely when marked advanced + globally hidden
    visible: !control.advanced || control.advancedVisible

    // ---- focus only when collapsible (header is the activation surface)
    activeFocusOnTab: control.collapsible

    Keys.onSpacePressed: if (control.collapsible) control.expanded = !control.expanded
    Keys.onReturnPressed: if (control.collapsible) control.expanded = !control.expanded

    // ---- geometry
    implicitWidth: Math.max(_outerColumn.implicitWidth + 2 * Tokens.space.x6, 240)
    implicitHeight: _outerColumn.implicitHeight + 2 * Tokens.space.x6

    // ---- background card
    Rectangle {
        anchors.fill: parent
        radius: Tokens.radius.lg
        color: Tokens.card
        border.color: Tokens.border
        border.width: 1
    }

    // ---- outer layout: header + content wrapper, animated spacing
    Column {
        id: _outerColumn
        x: Tokens.space.x6
        y: Tokens.space.x6
        width: parent.width - 2 * Tokens.space.x6
        spacing: control.expanded ? Tokens.space.x6 : 0

        // ---- header (title + optional description + optional chevron)
        Item {
            id: _header
            width: parent.width
            height: _headerRow.implicitHeight
            opacity: control.enabled ? 1.0 : 0.5

            Row {
                id: _headerRow
                width: parent.width
                spacing: Tokens.space.x4

                Column {
                    id: _titleColumn
                    width: parent.width - (_chevron.visible ? _chevron.width + parent.spacing : 0)
                    spacing: Tokens.space.x2

                    PearlText {
                        width: parent.width
                        text: control.title
                        variant: "body"
                        font.pixelSize: Tokens.font.size.md
                        font.weight: Tokens.font.weight.semibold
                        color: Tokens.foreground
                        elide: Text.ElideRight
                        visible: control.title !== ""
                    }

                    PearlText {
                        width: parent.width
                        text: control.description
                        variant: "muted"
                        wrapMode: Text.WordWrap
                        visible: control.description !== ""
                    }
                }

                PearlChevron {
                    id: _chevron
                    width: 16
                    height: 16
                    anchors.verticalCenter: _titleColumn.verticalCenter
                    visible: control.collapsible
                    direction: "down"
                    strokeColor: Tokens.mutedForeground
                    rotation: control.expanded ? 180 : 0

                    Behavior on rotation {
                        NumberAnimation {
                            duration: Tokens.motion.base
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: control.collapsible && control.enabled
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    control.expanded = !control.expanded
                    if (control.collapsible)
                        control.forceActiveFocus()
                }
            }
        }

        // ---- collapsible content wrapper
        Item {
            id: _contentWrapper
            width: parent.width
            clip: true
            height: control.expanded ? _innerColumn.implicitHeight : 0
            opacity: control.expanded ? 1.0 : 0.0

            Behavior on height {
                NumberAnimation {
                    duration: Tokens.motion.base
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: Tokens.motion.base
                    easing.type: Easing.OutCubic
                }
            }

            Column {
                id: _innerColumn
                width: parent.width
                spacing: Tokens.space.x3
                opacity: control.enabled ? 1.0 : 0.5
            }
        }
    }

    // ---- focus ring (collapsible header only, keyboard-only)
    PearlFocusRing {
        target: control
        offset: 2
        ringWidth: 3
        ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.collapsible && control.activeFocus
    }
}
