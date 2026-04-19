import QtQuick
import PearlKit 1.0

// Dental implant glyph: stylised threaded post with a small crown dot
// on top. Used by the Plan tool in ToolPalette.
Canvas {
    id: root
    property color strokeColor: Tokens.foreground
    property real strokeWidth: 1.5
    implicitWidth: 16
    implicitHeight: 16
    onStrokeColorChanged: requestPaint()
    onStrokeWidthChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d")
        ctx.reset()
        ctx.strokeStyle = root.strokeColor
        ctx.fillStyle = root.strokeColor
        ctx.lineWidth = root.strokeWidth
        ctx.lineCap = "round"
        ctx.lineJoin = "round"

        const w = width
        const h = height
        const cx = w / 2

        // overall implant body extents
        const topY = h * 0.18
        const shoulderY = h * 0.34
        const apexY = h * 0.90
        const halfW = w * 0.22

        // abutment/crown indicator — small filled circle above the post
        ctx.beginPath()
        ctx.arc(cx, topY - 1, root.strokeWidth * 0.9, 0, Math.PI * 2)
        ctx.fill()

        // post outline — trapezoid that tapers to a point at the apex
        ctx.beginPath()
        ctx.moveTo(cx - halfW, shoulderY)
        ctx.lineTo(cx + halfW, shoulderY)
        ctx.lineTo(cx + halfW * 0.85, apexY - halfW * 0.6)
        ctx.lineTo(cx, apexY)
        ctx.lineTo(cx - halfW * 0.85, apexY - halfW * 0.6)
        ctx.closePath()
        ctx.stroke()

        // horizontal thread lines inside the post
        const threads = 4
        const threadTop = shoulderY + (apexY - shoulderY) * 0.12
        const threadBottom = apexY - halfW * 0.9
        for (let i = 0; i < threads; i++) {
            const t = i / (threads - 1)
            const ty = threadTop + (threadBottom - threadTop) * t
            const tHalf = halfW * (1 - t * 0.18)
            ctx.beginPath()
            ctx.moveTo(cx - tHalf, ty)
            ctx.lineTo(cx + tHalf, ty)
            ctx.stroke()
        }
    }
}
