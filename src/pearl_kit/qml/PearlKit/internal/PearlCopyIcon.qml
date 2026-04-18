import QtQuick
import PearlKit 1.0

Canvas {
    id: root
    property color strokeColor: Tokens.mutedForeground
    property real strokeWidth: 1.4

    implicitWidth: 14
    implicitHeight: 14

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

        // lucide CopyIcon normalized from 24x24 viewBox onto this canvas
        const w = width, h = height
        const u = w / 24.0, v = h / 24.0
        const r = 2 * u

        // Front rounded rect at (8,8) → (22,22)
        const fx = 8 * u,  fy = 8 * v
        const fw = 14 * u, fh = 14 * v
        ctx.beginPath()
        ctx.moveTo(fx + r, fy)
        ctx.lineTo(fx + fw - r, fy)
        ctx.quadraticCurveTo(fx + fw, fy, fx + fw, fy + r)
        ctx.lineTo(fx + fw, fy + fh - r)
        ctx.quadraticCurveTo(fx + fw, fy + fh, fx + fw - r, fy + fh)
        ctx.lineTo(fx + r, fy + fh)
        ctx.quadraticCurveTo(fx, fy + fh, fx, fy + fh - r)
        ctx.lineTo(fx, fy + r)
        ctx.quadraticCurveTo(fx, fy, fx + r, fy)
        ctx.stroke()

        // Back L-shape: from (16,4) left to (4,4), down to (4,16)
        ctx.beginPath()
        ctx.moveTo(16 * u, 4 * v)
        ctx.lineTo(4 * u + r, 4 * v)
        ctx.quadraticCurveTo(4 * u, 4 * v, 4 * u, 4 * v + r)
        ctx.lineTo(4 * u, 16 * v)
        ctx.stroke()
    }
}
