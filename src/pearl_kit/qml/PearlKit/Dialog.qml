import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.Popup {
    id: control

    // ---- public API
    property string title: ""
    property string description: ""
    property bool showCloseButton: true
    property int maxWidth: 512
    property Component footer: null
    property Item initialFocusItem: null

    // default slot: children land in bodyColumn.data
    default property alias _bodyContent: bodyColumn.data

    // ---- Qt template internals
    modal: true
    focus: true
    parent: T.Overlay.overlay
    padding: 24
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside

    x: Math.round(((parent ? parent.width  : 0) - width)  / 2)
    y: Math.round(((parent ? parent.height : 0) - height) / 2)
    width: Math.min((parent ? parent.width : 512) - 32, maxWidth)

    onOpened: {
        if (initialFocusItem)
            initialFocusItem.forceActiveFocus()
        else
            forceActiveFocus()
    }

    // ---- overlay (dim backdrop with fade)
    T.Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.5)
        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }

    // ---- background (rounded card with shadow)
    background: Rectangle {
        id: dialogBg
        color: Tokens.background
        radius: Tokens.radius.lg
        border.color: Tokens.border
        border.width: 1
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 1.0
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 8
            shadowColor: Qt.rgba(0, 0, 0, 0.18)
            shadowScale: 1.0
            paddingRect: Qt.rect(-24, -24, dialogBg.width + 48, dialogBg.height + 48)
        }
    }

    // ---- contentItem (header + body + footer column with close button sibling)
    contentItem: Item {
        implicitWidth: mainColumn.implicitWidth
        implicitHeight: mainColumn.implicitHeight

        ColumnLayout {
            id: mainColumn
            anchors.fill: parent
            spacing: 16

            // header — title + description
            Column {
                id: headerColumn
                Layout.fillWidth: true
                spacing: 8
                visible: control.title !== "" || control.description !== ""

                PearlBaseText {
                    visible: control.title !== ""
                    text: control.title
                    width: parent.width - (control.showCloseButton ? 24 : 0)
                    font.pixelSize: Tokens.font.size.lg
                    font.weight: Tokens.font.weight.semibold
                    color: Tokens.foreground
                    lineHeight: 1.0
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.WordWrap
                }

                PearlBaseText {
                    visible: control.description !== ""
                    text: control.description
                    width: parent.width
                    font.pixelSize: Tokens.font.size.sm
                    font.weight: Tokens.font.weight.regular
                    color: Tokens.mutedForeground
                    wrapMode: Text.WordWrap
                }
            }

            // body — consumer's children via default alias
            Column {
                id: bodyColumn
                Layout.fillWidth: true
                spacing: 16
            }

            // footer — optional, rendered via Loader from Component
            Loader {
                id: footerSlot
                Layout.fillWidth: true
                active: control.footer !== null
                visible: active
                sourceComponent: control.footer
            }
        }

        // close button — sibling of mainColumn, absolute top-right
        Rectangle {
            id: closeBtn
            visible: control.showCloseButton
            width: 16
            height: 16
            radius: 2
            color: "transparent"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: -8
            anchors.rightMargin: -8
            opacity: closeArea.containsMouse ? 1.0 : 0.7
            activeFocusOnTab: true

            Behavior on opacity {
                NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }

            PearlXIcon {
                anchors.centerIn: parent
                width: 14
                height: 14
                strokeColor: Tokens.foreground
                strokeWidth: 1.5
            }

            MouseArea {
                id: closeArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: control.close()
            }

            Keys.onReturnPressed: control.close()
            Keys.onSpacePressed:  control.close()

            PearlFocusRing {
                target: closeBtn
                offset: 2
                ringWidth: 2
                ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
                visible: closeBtn.activeFocus
            }
        }
    }

    // ---- enter/exit transitions (shadcn zoom-in-95 + fade-in-0 / zoom-out-95 + fade-out-0)
    enter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale";   from: 0.95; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
        }
    }
    exit: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale";   from: 1.0; to: 0.95; duration: 200; easing.type: Easing.OutCubic }
        }
    }
}
