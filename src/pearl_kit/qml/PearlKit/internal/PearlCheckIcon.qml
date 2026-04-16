import QtQuick
import PearlKit 1.0

Canvas {
    id: root
    property color strokeColor: Tokens.primaryForeground
    property real strokeWidth: 2.0
    property string mode: "check"   // "check" | "dash"

    implicitWidth: 16
    implicitHeight: 16

    onStrokeColorChanged: requestPaint()
    onStrokeWidthChanged: requestPaint()
    onModeChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d")
        ctx.reset()
        ctx.strokeStyle = root.strokeColor
        ctx.lineWidth = root.strokeWidth
        ctx.lineCap = "round"
        ctx.lineJoin = "round"

        const w = width, h = height
        ctx.beginPath()
        if (root.mode === "dash") {
            const pad = w * 0.25
            ctx.moveTo(pad, h / 2)
            ctx.lineTo(w - pad, h / 2)
        } else {
            // lucide CheckIcon M4 12 L9 17 L20 7 normalized to [0,1]
            ctx.moveTo(w * 0.20, h * 0.52)
            ctx.lineTo(w * 0.42, h * 0.72)
            ctx.lineTo(w * 0.82, h * 0.28)
        }
        ctx.stroke()
    }
}
