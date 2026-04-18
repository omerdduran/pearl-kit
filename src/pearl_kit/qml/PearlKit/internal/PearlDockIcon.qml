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

        const w = width
        const h = height
        const pad = 3
        const boxTop = h * 0.6
        const arrowTip = h * 0.55

        // Downward arrow stem + head (into the tray)
        ctx.beginPath()
        ctx.moveTo(w / 2, pad)
        ctx.lineTo(w / 2, arrowTip)
        ctx.stroke()

        ctx.beginPath()
        ctx.moveTo(w / 2 - 3, arrowTip - 3)
        ctx.lineTo(w / 2, arrowTip)
        ctx.lineTo(w / 2 + 3, arrowTip - 3)
        ctx.stroke()

        // Tray (three-sided open box at the bottom)
        ctx.beginPath()
        ctx.moveTo(pad, boxTop)
        ctx.lineTo(pad, h - pad)
        ctx.lineTo(w - pad, h - pad)
        ctx.lineTo(w - pad, boxTop)
        ctx.stroke()
    }
}
