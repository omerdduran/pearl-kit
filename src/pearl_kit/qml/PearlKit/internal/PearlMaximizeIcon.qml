import QtQuick
import PearlKit 1.0

Canvas {
    id: root
    property color strokeColor: Tokens.foreground
    property real strokeWidth: 1.5
    property bool restored: false   // false = outline square (maximize); true = overlapping squares (restore)
    implicitWidth: 16
    implicitHeight: 16
    onStrokeColorChanged: requestPaint()
    onStrokeWidthChanged: requestPaint()
    onRestoredChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

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
        const r = 1

        if (!root.restored) {
            // Single rounded square (maximize)
            ctx.beginPath()
            ctx.moveTo(pad + r, pad)
            ctx.lineTo(w - pad - r, pad)
            ctx.quadraticCurveTo(w - pad, pad, w - pad, pad + r)
            ctx.lineTo(w - pad, h - pad - r)
            ctx.quadraticCurveTo(w - pad, h - pad, w - pad - r, h - pad)
            ctx.lineTo(pad + r, h - pad)
            ctx.quadraticCurveTo(pad, h - pad, pad, h - pad - r)
            ctx.lineTo(pad, pad + r)
            ctx.quadraticCurveTo(pad, pad, pad + r, pad)
            ctx.stroke()
        } else {
            // Two overlapping squares (restore)
            const off = 2
            // Back square
            ctx.beginPath()
            ctx.rect(pad + off, pad, w - 2 * pad - off, h - 2 * pad - off)
            ctx.stroke()
            // Front square (fill bg-ish to simulate stack)
            ctx.beginPath()
            ctx.rect(pad, pad + off, w - 2 * pad - off, h - 2 * pad - off)
            ctx.stroke()
        }
    }
}
