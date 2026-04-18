import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import PearlKit 1.0
import PearlKit.internal 1.0

Item {
    id: control

    property int toastId: -1
    property string type: "default"
    property string title: ""
    property string description: ""
    property int duration: 4000

    property bool _dismissing: false

    readonly property int _slideOffset: 40
    readonly property color _accent: {
        switch (type) {
        case "success": return Tokens.success
        case "warning": return Tokens.warning
        case "error":   return Tokens.destructive
        case "info":    return Tokens.primary
        case "loading": return Tokens.mutedForeground
        default:        return Tokens.foreground
        }
    }

    implicitWidth: 356
    implicitHeight: card.implicitHeight
    width: implicitWidth

    opacity: 0
    x: _slideOffset

    Component.onCompleted: {
        opacity = 1
        x = 0
    }

    Behavior on opacity {
        NumberAnimation { duration: Tokens.motion.base; easing.type: Easing.OutCubic }
    }
    Behavior on x {
        NumberAnimation { duration: Tokens.motion.base; easing.type: Easing.OutCubic }
    }

    Rectangle {
        id: card
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: row.implicitHeight + 24
        color: Tokens.popover
        radius: Tokens.radius.md
        border.color: Tokens.border
        border.width: 1

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 1.0
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 6
            shadowColor: Qt.rgba(0, 0, 0, 0.14)
            shadowScale: 1.0
        }

        MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
        }

        RowLayout {
            id: row
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 14
            anchors.rightMargin: 12
            anchors.topMargin: 12
            spacing: 12

            Item {
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 1
                implicitWidth: 20
                implicitHeight: 20
                visible: control.type !== "default"

                PearlToastIcon {
                    anchors.fill: parent
                    type: control.type
                    visible: control.type !== "loading"
                }

                Spinner {
                    anchors.fill: parent
                    visible: control.type === "loading"
                    color: Tokens.mutedForeground
                    strokeWidth: 2
                    running: control.type === "loading" && control.visible
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: 12
                spacing: 4

                PearlBaseText {
                    visible: control.title !== ""
                    text: control.title
                    Layout.fillWidth: true
                    font.pixelSize: Tokens.font.size.sm
                    font.weight: Tokens.font.weight.semibold
                    color: Tokens.popoverForeground
                    wrapMode: Text.WordWrap
                }

                PearlBaseText {
                    visible: control.description !== ""
                    text: control.description
                    Layout.fillWidth: true
                    font.pixelSize: Tokens.font.size.sm
                    font.weight: Tokens.font.weight.regular
                    color: Tokens.mutedForeground
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle {
                id: closeBtn
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 1
                width: 18
                height: 18
                radius: 3
                color: closeArea.containsMouse
                    ? Qt.rgba(Tokens.foreground.r, Tokens.foreground.g, Tokens.foreground.b, 0.08)
                    : "transparent"
                activeFocusOnTab: true

                Behavior on color {
                    ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
                }

                PearlXIcon {
                    anchors.centerIn: parent
                    width: 12
                    height: 12
                    strokeColor: Tokens.mutedForeground
                    strokeWidth: 1.5
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Toaster.dismiss(control.toastId)
                }

                Keys.onReturnPressed: Toaster.dismiss(control.toastId)
                Keys.onSpacePressed: Toaster.dismiss(control.toastId)

                PearlFocusRing {
                    target: closeBtn
                    offset: 2
                    ringWidth: 2
                    ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
                    visible: closeBtn.activeFocus
                }
            }
        }
    }

    Timer {
        id: dismissTimer
        interval: control.duration
        running: control.duration > 0
            && control.type !== "loading"
            && !hoverArea.containsMouse
            && !control._dismissing
            && control.visible
        repeat: false
        onTriggered: Toaster.dismiss(control.toastId)
    }

    Timer {
        id: exitTimer
        interval: Tokens.motion.base + 20
        repeat: false
        onTriggered: Toaster._removeById(control.toastId)
    }

    Connections {
        target: Toaster
        function onDismissRequested(id) {
            if (id !== control.toastId || control._dismissing)
                return
            control._dismissing = true
            control.opacity = 0
            control.x = control._slideOffset
            exitTimer.start()
        }
    }
}
