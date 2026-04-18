import QtQuick
import PearlKit 1.0

Item {
    id: control

    property color color: Tokens.mutedForeground
    property real strokeWidth: 2
    property bool running: true
    property int duration: 1000

    implicitWidth: 16
    implicitHeight: 16

    Accessible.role: Accessible.Indicator
    Accessible.name: "Loading"

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        smooth: true

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            ctx.strokeStyle = control.color
            ctx.lineWidth = control.strokeWidth
            ctx.lineCap = "round"

            const cx = width / 2
            const cy = height / 2
            const r = Math.max(0, Math.min(width, height) / 2 - control.strokeWidth / 2 - 1)
            const start = -Math.PI / 2
            const end = start + (3 * Math.PI / 2)
            ctx.beginPath()
            ctx.arc(cx, cy, r, start, end)
            ctx.stroke()
        }

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        Connections {
            target: control
            function onColorChanged() { canvas.requestPaint() }
            function onStrokeWidthChanged() { canvas.requestPaint() }
        }

        RotationAnimator on rotation {
            from: 0
            to: 360
            duration: control.duration
            loops: Animation.Infinite
            running: control.running && control.visible
        }
    }
}
