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
        const pad = 3
        ctx.beginPath()
        ctx.moveTo(pad, pad)
        ctx.lineTo(width - pad, height - pad)
        ctx.moveTo(width - pad, pad)
        ctx.lineTo(pad, height - pad)
        ctx.stroke()
    }
}
