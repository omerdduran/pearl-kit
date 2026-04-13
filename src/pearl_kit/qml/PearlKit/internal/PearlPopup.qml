import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

T.Popup {
    id: pop
    parent: T.Overlay.overlay
    modal: false
    padding: Tokens.space.x3

    background: Rectangle {
        color: Tokens.popover
        radius: Tokens.radius.lg
        border.color: Tokens.border
        border.width: 1
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Tokens.motion.fast }
        NumberAnimation { property: "scale"; from: 0.96; to: 1; duration: Tokens.motion.fast }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Tokens.motion.fast }
    }
}
