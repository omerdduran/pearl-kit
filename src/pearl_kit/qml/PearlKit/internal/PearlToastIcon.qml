import QtQuick
import PearlKit 1.0

Item {
    id: root

    property string type: "default"
    property real strokeWidth: 1.8

    readonly property color accent: {
        switch (type) {
        case "success": return Tokens.success
        case "warning": return Tokens.warning
        case "error":   return Tokens.destructive
        case "info":    return Tokens.primary
        default:        return Tokens.foreground
        }
    }

    implicitWidth: 20
    implicitHeight: 20
    visible: type === "success" || type === "info" || type === "warning" || type === "error"

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        smooth: true

        property color strokeColor: root.accent

        onStrokeColorChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        Connections {
            target: root
            function onTypeChanged() { canvas.requestPaint() }
            function onStrokeWidthChanged() { canvas.requestPaint() }
        }

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            ctx.strokeStyle = canvas.strokeColor
            ctx.fillStyle = canvas.strokeColor
            ctx.lineWidth = root.strokeWidth
            ctx.lineCap = "round"
            ctx.lineJoin = "round"

            const w = width
            const h = height
            const cx = w / 2
            const cy = h / 2
            const r = Math.min(w, h) / 2 - 1.5

            if (root.type === "success") {
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, Math.PI * 2)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(cx - r * 0.45, cy + r * 0.02)
                ctx.lineTo(cx - r * 0.08, cy + r * 0.38)
                ctx.lineTo(cx + r * 0.55, cy - r * 0.32)
                ctx.stroke()
            } else if (root.type === "info") {
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, Math.PI * 2)
                ctx.stroke()
                ctx.beginPath()
                ctx.arc(cx, cy - r * 0.45, root.strokeWidth * 0.55, 0, Math.PI * 2)
                ctx.fill()
                ctx.beginPath()
                ctx.moveTo(cx, cy - r * 0.15)
                ctx.lineTo(cx, cy + r * 0.55)
                ctx.stroke()
            } else if (root.type === "warning") {
                const padX = 1.5
                const apexY = 2.0
                const baseY = h - 2.0
                ctx.beginPath()
                ctx.moveTo(cx, apexY)
                ctx.lineTo(w - padX, baseY)
                ctx.lineTo(padX, baseY)
                ctx.closePath()
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(cx, cy - h * 0.04)
                ctx.lineTo(cx, cy + h * 0.18)
                ctx.stroke()
                ctx.beginPath()
                ctx.arc(cx, cy + h * 0.32, root.strokeWidth * 0.55, 0, Math.PI * 2)
                ctx.fill()
            } else if (root.type === "error") {
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, Math.PI * 2)
                ctx.stroke()
                const inset = r * 0.42
                ctx.beginPath()
                ctx.moveTo(cx - inset, cy - inset)
                ctx.lineTo(cx + inset, cy + inset)
                ctx.moveTo(cx + inset, cy - inset)
                ctx.lineTo(cx - inset, cy + inset)
                ctx.stroke()
            }
        }
    }
}
