import QtQuick
import PearlKit 1.0

Item {
    id: root

    property string variant: "info"

    readonly property color badgeColor: {
        switch (variant) {
        case "info":    return Qt.rgba(Tokens.primary.r,     Tokens.primary.g,     Tokens.primary.b,     0.15)
        case "warning": return Qt.rgba(Tokens.warning.r,     Tokens.warning.g,     Tokens.warning.b,     0.15)
        case "error":   return Qt.rgba(Tokens.destructive.r, Tokens.destructive.g, Tokens.destructive.b, 0.15)
        case "confirm": return Tokens.muted
        default:        return Tokens.muted
        }
    }
    readonly property color glyphColor: {
        switch (variant) {
        case "info":    return Tokens.primary
        case "warning": return Tokens.warning
        case "error":   return Tokens.destructive
        case "confirm": return Tokens.foreground
        default:        return Tokens.foreground
        }
    }

    implicitWidth: 48
    implicitHeight: 48

    Rectangle {
        anchors.fill: parent
        radius: Tokens.radius.md
        color: root.badgeColor
        Behavior on color {
            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
    }

    Canvas {
        id: glyph
        anchors.centerIn: parent
        width: 24
        height: 24

        property color strokeColor: root.glyphColor
        property real strokeWidth: 2.0

        onStrokeColorChanged: requestPaint()
        onStrokeWidthChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        Connections {
            target: root
            function onVariantChanged() { glyph.requestPaint() }
        }

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            ctx.strokeStyle = glyph.strokeColor
            ctx.fillStyle = glyph.strokeColor
            ctx.lineWidth = glyph.strokeWidth
            ctx.lineCap = "round"
            ctx.lineJoin = "round"

            const w = glyph.width
            const h = glyph.height
            const cx = w / 2

            if (root.variant === "error") {
                const pad = 5
                ctx.beginPath()
                ctx.moveTo(pad, pad); ctx.lineTo(w - pad, h - pad)
                ctx.moveTo(w - pad, pad); ctx.lineTo(pad, h - pad)
                ctx.stroke()
            } else if (root.variant === "info") {
                ctx.beginPath(); ctx.arc(cx, 5, 1.25, 0, Math.PI * 2); ctx.fill()
                ctx.beginPath(); ctx.moveTo(cx, 10); ctx.lineTo(cx, h - 4); ctx.stroke()
            } else if (root.variant === "warning") {
                ctx.beginPath(); ctx.moveTo(cx, 4); ctx.lineTo(cx, h - 10); ctx.stroke()
                ctx.beginPath(); ctx.arc(cx, h - 5, 1.35, 0, Math.PI * 2); ctx.fill()
            } else if (root.variant === "confirm") {
                ctx.beginPath(); ctx.arc(cx, 8, 4.5, Math.PI, Math.PI * 2); ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(cx + 4.5, 8)
                ctx.quadraticCurveTo(cx + 4.5, 13, cx, 15)
                ctx.lineTo(cx, h - 7)
                ctx.stroke()
                ctx.beginPath(); ctx.arc(cx, h - 4, 1.35, 0, Math.PI * 2); ctx.fill()
            }
        }
    }
}
