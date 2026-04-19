// RectSelect — drag-to-select rectangle overlay for ImageViewport.
//
// When `active: true` a MouseArea over the whole surface tracks a
// press-drag-release cycle and draws a live rectangle. On release
// the component emits `selected(x1, y1, x2, y2)` in image-space
// (the consumer-supplied coords from the press + release positions).
//
// Presentational only — no state persists after release; the
// consumer reads the final rect from the signal and drives follow-up
// behaviour (e.g. mark missing teeth).

import QtQuick

Item {
    id: control

    property bool active: false
    property color strokeColor: "#F97316"  // orange-500
    property color fillColor: Qt.rgba(0.97, 0.45, 0.09, 0.15)

    signal selected(real x1, real y1, real x2, real y2)
    signal cancelled()

    anchors.fill: parent

    property real _x1: 0
    property real _y1: 0
    property real _x2: 0
    property real _y2: 0
    property bool _dragging: false

    Rectangle {
        visible: control._dragging
        x: Math.min(control._x1, control._x2)
        y: Math.min(control._y1, control._y2)
        width: Math.abs(control._x2 - control._x1)
        height: Math.abs(control._y2 - control._y1)
        color: control.fillColor
        border.color: control.strokeColor
        border.width: 1
    }

    MouseArea {
        anchors.fill: parent
        enabled: control.active
        cursorShape: Qt.CrossCursor
        acceptedButtons: Qt.LeftButton

        onPressed: (ev) => {
            control._x1 = ev.x
            control._y1 = ev.y
            control._x2 = ev.x
            control._y2 = ev.y
            control._dragging = true
        }
        onPositionChanged: (ev) => {
            if (control._dragging) {
                control._x2 = ev.x
                control._y2 = ev.y
            }
        }
        onReleased: (ev) => {
            if (!control._dragging) return
            control._dragging = false
            const x1 = Math.min(control._x1, ev.x)
            const y1 = Math.min(control._y1, ev.y)
            const x2 = Math.max(control._x1, ev.x)
            const y2 = Math.max(control._y1, ev.y)
            if (x2 - x1 < 2 || y2 - y1 < 2) {
                control.cancelled()
                return
            }
            control.selected(x1, y1, x2, y2)
        }
    }
}
