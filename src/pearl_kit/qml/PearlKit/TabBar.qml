import QtQuick
import QtQuick as QQ
import QtQuick.Templates as T
import PearlKit 1.0

T.TabBar {
    id: control

    // ---- public API
    property string variant: "default"   // "default" | "line"
    property bool expanding: true

    // ---- geometry (shadcn h-9 = 36 px)
    implicitHeight: 36

    spacing: variant === "line" ? 4 : 0      // shadcn gap-1 for line, 0 for default
    padding: variant === "line" ? 0 : 3      // shadcn p-[3px] for default

    readonly property bool _isDefault: variant === "default"

    // ---- background (variant-aware surface)
    background: Rectangle {
        color: control._isDefault ? Tokens.muted : "transparent"
        radius: control._isDefault ? Tokens.radius.lg : 0

        // Bottom hairline for line variant (document-mode frame cue)
        Rectangle {
            visible: !control._isDefault
            height: 1
            color: Tokens.border
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

        Behavior on color {
            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
    }

    // ---- contentItem: default ListView over contentModel handles flick + currentIndex tracking
    contentItem: QQ.ListView {
        model: control.contentModel
        currentIndex: control.currentIndex
        orientation: QQ.ListView.Horizontal
        flickableDirection: Flickable.AutoFlickIfNeeded
        snapMode: QQ.ListView.SnapToItem
        highlightMoveDuration: 0
        boundsBehavior: Flickable.StopAtBounds
        spacing: control.spacing
    }
}
