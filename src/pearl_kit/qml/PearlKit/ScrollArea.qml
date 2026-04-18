import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import PearlKit 1.0

T.ScrollView {
    id: control

    // ---- public API
    property bool autoHide: true

    clip: true
    focusPolicy: Qt.StrongFocus
    hoverEnabled: true

    // ---- vertical scrollbar (shadcn: w-2.5, p-px, rounded-full bg-border)
    ScrollBar.vertical: T.ScrollBar {
        id: vbar
        implicitWidth: 10
        padding: 1
        minimumSize: 0.1
        policy: T.ScrollBar.AsNeeded

        opacity: control.autoHide
                 ? ((control.hovered || vbar.active || vbar.hovered) ? 1.0 : 0.0)
                 : 1.0
        Behavior on opacity {
            NumberAnimation { duration: Tokens.motion.base; easing.type: Easing.OutCubic }
        }

        contentItem: Rectangle {
            implicitWidth: 8
            radius: width / 2
            color: vbar.pressed
                   ? Tokens.mutedForeground
                   : (vbar.hovered
                      ? Qt.rgba(Tokens.mutedForeground.r,
                                Tokens.mutedForeground.g,
                                Tokens.mutedForeground.b, 0.8)
                      : Tokens.border)
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        background: Item { }
    }

    // ---- horizontal scrollbar
    ScrollBar.horizontal: T.ScrollBar {
        id: hbar
        implicitHeight: 10
        padding: 1
        minimumSize: 0.1
        policy: T.ScrollBar.AsNeeded

        opacity: control.autoHide
                 ? ((control.hovered || hbar.active || hbar.hovered) ? 1.0 : 0.0)
                 : 1.0
        Behavior on opacity {
            NumberAnimation { duration: Tokens.motion.base; easing.type: Easing.OutCubic }
        }

        contentItem: Rectangle {
            implicitHeight: 8
            radius: height / 2
            color: hbar.pressed
                   ? Tokens.mutedForeground
                   : (hbar.hovered
                      ? Qt.rgba(Tokens.mutedForeground.r,
                                Tokens.mutedForeground.g,
                                Tokens.mutedForeground.b, 0.8)
                      : Tokens.border)
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        background: Item { }
    }
}
