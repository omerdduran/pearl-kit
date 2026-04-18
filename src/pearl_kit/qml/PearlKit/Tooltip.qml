import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.ToolTip {
    id: control

    // ---- public API
    property string placement: "top"   // "top" | "bottom" | "left" | "right"
    property int maxWidth: 320

    // ---- Qt template internals
    delay: 0
    timeout: -1
    focus: false
    padding: 0
    leftPadding: 12
    rightPadding: 12
    topPadding: 6
    bottomPadding: 6
    margins: 0
    closePolicy: T.Popup.NoAutoClose

    // clamp total popup width so long text wraps at maxWidth
    implicitWidth: Math.min(
        implicitContentWidth + leftPadding + rightPadding,
        maxWidth
    )

    // ---- positioning — flush against trigger edge (shadcn sideOffset: 0), no auto-flip
    x: {
        const pw = parent ? parent.width : 0
        switch (placement) {
            case "left":   return -width
            case "right":  return pw
            default:       return Math.round((pw - width) / 2)   // top, bottom
        }
    }
    y: {
        const ph = parent ? parent.height : 0
        switch (placement) {
            case "top":    return -height
            case "bottom": return ph
            default:       return Math.round((ph - height) / 2)   // left, right
        }
    }

    // ---- accessibility
    Accessible.role: Accessible.ToolTip
    Accessible.name: text

    // ---- background (inverted surface — shadcn bg-foreground)
    background: Rectangle {
        color: Tokens.foreground
        radius: Tokens.radius.md
    }

    // ---- contentItem (inverted text — shadcn text-background, 12 px xs)
    contentItem: PearlBaseText {
        text: control.text
        font.family: Tokens.font.ui
        font.pixelSize: Tokens.font.size.xs
        font.weight: Tokens.font.weight.regular
        color: Tokens.background
        wrapMode: Text.WordWrap
        width: control.availableWidth
    }

    // ---- enter / exit — shadcn fade-in-0 zoom-in-95 / fade-out-0 zoom-out-95
    enter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale";   from: 0.95; to: 1.0; duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
    }
    exit: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale";   from: 1.0; to: 0.95; duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
    }
}
