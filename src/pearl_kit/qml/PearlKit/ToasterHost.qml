import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

Item {
    id: host

    parent: T.Overlay.overlay
    anchors.fill: parent ? parent : undefined
    z: 9999

    Component.onCompleted: {
        if (typeof NotificationCenter !== "undefined" && NotificationCenter !== null) {
            Toaster._bindBridge(NotificationCenter)
        } else {
            Toaster._bindBridge(null)
        }
    }

    Column {
        id: stack
        spacing: 8

        anchors.margins: 16

        anchors.top: Toaster.position.indexOf("top") === 0 ? parent.top : undefined
        anchors.bottom: Toaster.position.indexOf("bottom") === 0 ? parent.bottom : undefined
        anchors.right: Toaster.position.indexOf("right") !== -1 ? parent.right : undefined
        anchors.left: Toaster.position.indexOf("left") !== -1 ? parent.left : undefined
        anchors.horizontalCenter: Toaster.position.indexOf("center") !== -1 ? parent.horizontalCenter : undefined

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Tokens.motion.base; easing.type: Easing.OutCubic }
        }
        move: Transition {
            NumberAnimation { properties: "x,y"; duration: Tokens.motion.base; easing.type: Easing.OutCubic }
        }

        Repeater {
            model: Toaster._stack

            delegate: Toast {
                required property int index
                required property var model

                toastId: model.id
                type: model.type
                title: model.title
                description: model.description
                duration: model.duration
            }
        }
    }
}
