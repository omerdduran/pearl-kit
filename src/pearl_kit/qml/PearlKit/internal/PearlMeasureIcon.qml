import QtQuick
import PearlKit 1.0

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
        ctx.lineWidth = root.strokeWidth
        ctx.lineCap = "round"
        ctx.lineJoin = "round"

        // Diagonal ruler body — rounded rectangle rotated 45 deg, centred.
        const w = width
        const h = height
        const pad = 2
        const rulerW = (w - pad * 2) * Math.SQRT2 / 2 * 1.3
        const rulerH = rulerW * 0.32
        const cx = w / 2
        const cy = h / 2

        ctx.save()
        ctx.translate(cx, cy)
        ctx.rotate(-Math.PI / 4)
        // body
        const x = -rulerW / 2
        const y = -rulerH / 2
        const r = 1.5
        ctx.beginPath()
        ctx.moveTo(x + r, y)
        ctx.lineTo(x + rulerW - r, y)
        ctx.quadraticCurveTo(x + rulerW, y, x + rulerW, y + r)
        ctx.lineTo(x + rulerW, y + rulerH - r)
        ctx.quadraticCurveTo(x + rulerW, y + rulerH, x + rulerW - r, y + rulerH)
        ctx.lineTo(x + r, y + rulerH)
        ctx.quadraticCurveTo(x, y + rulerH, x, y + rulerH - r)
        ctx.lineTo(x, y + r)
        ctx.quadraticCurveTo(x, y, x + r, y)
        ctx.closePath()
        ctx.stroke()

        // tick marks along the top edge
        const ticks = 5
        for (let i = 1; i < ticks; i++) {
            const tx = x + (rulerW * i) / ticks
            const tickLen = (i % 2 === 0) ? rulerH * 0.55 : rulerH * 0.35
            ctx.beginPath()
            ctx.moveTo(tx, y)
            ctx.lineTo(tx, y + tickLen)
            ctx.stroke()
        }
        ctx.restore()
    }
}
