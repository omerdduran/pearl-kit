import QtQuick
import PearlKit 1.0

Canvas {
    id: root

    property color strokeColor: Tokens.mutedForeground
    property real strokeWidth: 1.5
    property string direction: "down"   // down | up | right | left

    implicitWidth: 16
    implicitHeight: 16

    onStrokeColorChanged: requestPaint()
    onStrokeWidthChanged: requestPaint()
    onDirectionChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d")
        ctx.reset()
        ctx.strokeStyle = root.strokeColor
        ctx.lineWidth = root.strokeWidth
        ctx.lineCap = "round"
        ctx.lineJoin = "round"

        const w = width
        const h = height
        const pad = 3
        ctx.beginPath()
        if (root.direction === "up") {
            ctx.moveTo(pad,     h - pad)
            ctx.lineTo(w / 2,   pad + 1)
            ctx.lineTo(w - pad, h - pad)
        } else if (root.direction === "right") {
            ctx.moveTo(pad + 1,     pad)
            ctx.lineTo(w - pad,     h / 2)
            ctx.lineTo(pad + 1,     h - pad)
        } else if (root.direction === "left") {
            ctx.moveTo(w - pad - 1, pad)
            ctx.lineTo(pad,         h / 2)
            ctx.lineTo(w - pad - 1, h - pad)
        } else {
            ctx.moveTo(pad,     pad + 1)
            ctx.lineTo(w / 2,   h - pad)
            ctx.lineTo(w - pad, pad + 1)
        }
        ctx.stroke()
    }
}
