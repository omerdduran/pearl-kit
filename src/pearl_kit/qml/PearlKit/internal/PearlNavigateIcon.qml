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
        ctx.fillStyle = root.strokeColor
        ctx.lineWidth = root.strokeWidth
        ctx.lineCap = "round"
        ctx.lineJoin = "round"

        const cx = width / 2
        const cy = height / 2
        const arm = Math.min(width, height) / 2 - 1.5
        const head = arm * 0.35

        // vertical + horizontal cross axes
        ctx.beginPath()
        ctx.moveTo(cx, cy - arm)
        ctx.lineTo(cx, cy + arm)
        ctx.moveTo(cx - arm, cy)
        ctx.lineTo(cx + arm, cy)
        ctx.stroke()

        // four arrowheads (up, down, left, right)
        const tips = [
            [cx, cy - arm, 0],
            [cx, cy + arm, Math.PI],
            [cx - arm, cy, -Math.PI / 2],
            [cx + arm, cy, Math.PI / 2],
        ]
        for (const [tx, ty, rot] of tips) {
            ctx.save()
            ctx.translate(tx, ty)
            ctx.rotate(rot)
            ctx.beginPath()
            ctx.moveTo(0, 0)
            ctx.lineTo(-head * 0.7, head)
            ctx.lineTo(head * 0.7, head)
            ctx.closePath()
            ctx.fill()
            ctx.restore()
        }
    }
}
