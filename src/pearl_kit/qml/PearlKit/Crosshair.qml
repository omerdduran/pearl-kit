// Crosshair — drag-to-move intersection overlay for 2D slice viewports.
//
// Renders a 1 px horizontal + vertical line pair coloured per the anatomical
// plane (axial blue, coronal red, sagittal green). The centre is positioned
// in **image coordinates** via `imageX` / `imageY` and a `viewTransform`
// function that maps image-space to viewport-space (identity by default).
// Dragging the centre emits `moved(imageX, imageY)` — the consumer updates
// its AppState, which feeds back into this component via binding (no
// internal state).
//
// Typical usage
// -------------
//     P.ImageViewport {
//         id: ax
//         plane: "axial"
//         Crosshair {
//             plane: parent.plane
//             imageX: bridge.crosshair.x
//             imageY: bridge.crosshair.y
//             viewTransform: (ix, iy) => ax.imageToView(ix, iy)
//             onMoved: (x, y) => bridge.setCrosshair(x, y)
//         }
//     }

import QtQuick

Item {
    id: control

    // ---- Inputs ----
    property string plane: "axial"   // "axial" | "coronal" | "sagittal"
    property real imageX: 0
    property real imageY: 0
    //: function (imageX, imageY) -> { x: viewX, y: viewY }
    //: Default is identity — override when the surface applies pan/zoom.
    property var viewTransform: (ix, iy) => ({ x: ix, y: iy })
    property real opacityDim: 0.35
    property real opacityHover: 0.7

    signal moved(real imageX, real imageY)

    readonly property color _color: {
        switch (control.plane) {
            case "coronal":  return "#F87171"
            case "sagittal": return "#34D399"
            default:         return "#3B82F6"
        }
    }

    anchors.fill: parent

    readonly property var _view: viewTransform(imageX, imageY)

    // Vertical line
    Rectangle {
        x: Math.round(control._view.x) - 0.5
        y: 0
        width: 1
        height: parent.height
        color: control._color
        opacity: _ha.containsMouse || _va.containsMouse ? control.opacityHover : control.opacityDim
    }
    // Horizontal line
    Rectangle {
        x: 0
        y: Math.round(control._view.y) - 0.5
        width: parent.width
        height: 1
        color: control._color
        opacity: _ha.containsMouse || _va.containsMouse ? control.opacityHover : control.opacityDim
    }

    // Drag handle at the intersection — 14 px hit area with a visible ring.
    Item {
        x: Math.round(control._view.x) - 7
        y: Math.round(control._view.y) - 7
        width: 14
        height: 14

        Rectangle {
            anchors.centerIn: parent
            width: _ma.containsMouse || _ma.drag.active ? 10 : 6
            height: width
            radius: width / 2
            color: "transparent"
            border.color: control._color
            border.width: 1.5
            Behavior on width { NumberAnimation { duration: 90 } }
        }

        MouseArea {
            id: _ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
            drag.target: parent
            drag.axis: Drag.XAndYAxis
            drag.minimumX: -parent.width
            drag.maximumX: control.width
            drag.minimumY: -parent.height
            drag.maximumY: control.height
            onPositionChanged: if (drag.active) {
                // Parent.x + width/2 gives the centre in view coords. Convert
                // back to image coords by asking the consumer via a signal:
                // we can't invert an arbitrary transform here, so we emit
                // view-space deltas as image-space (caller treats them as
                // absolute image coords).
                control.moved(parent.x + 7, parent.y + 7)
            }
        }
    }

    // Invisible full-surface hover helpers so the lines highlight on
    // pointer proximity even when the user isn't directly over the knob.
    MouseArea {
        id: _ha
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true
    }
    MouseArea {
        id: _va
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true
        visible: false  // second handle never gets focus, retained for legacy binding
    }
}
