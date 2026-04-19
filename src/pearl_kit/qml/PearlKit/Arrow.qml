// Arrow — 2-point arrow annotation for ImageViewport overlays.
//
// Presentational only: Shape + PathLine shaft + triangular head. The
// consumer provides (x1, y1) tail and (x2, y2) head in image space.
// Preview mode renders a dashed rubber-band shaft without the head.

import QtQuick
import QtQuick.Shapes

Item {
    id: control

    property real x1: 0
    property real y1: 0
    property real x2: 0
    property real y2: 0
    property bool preview: false
    property bool selected: false
    property real headSize: 10
    property color strokeColor: "#FF8C00"
    property real  strokeWidth: 2

    signal removed()
    signal clicked()

    anchors.fill: parent

    readonly property real _dx: control.x2 - control.x1
    readonly property real _dy: control.y2 - control.y1
    readonly property real _len: Math.max(1e-6, Math.hypot(control._dx, control._dy))
    readonly property real _ux: control._dx / control._len
    readonly property real _uy: control._dy / control._len

    // Shaft
    Shape {
        anchors.fill: parent
        antialiasing: true
        ShapePath {
            strokeColor: control.strokeColor
            strokeWidth: control.selected ? control.strokeWidth + 0.8 : control.strokeWidth
            strokeStyle: control.preview ? ShapePath.DashLine : ShapePath.SolidLine
            dashPattern: [4, 3]
            fillColor: "transparent"
            startX: control.x1
            startY: control.y1
            PathLine { x: control.x2; y: control.y2 }
        }
    }

    // Triangular head — anchored at (x2, y2), oriented along direction.
    Shape {
        visible: !control.preview
        anchors.fill: parent
        antialiasing: true
        ShapePath {
            strokeColor: control.strokeColor
            strokeWidth: 1
            fillColor: control.strokeColor
            startX: control.x2
            startY: control.y2
            PathLine {
                x: control.x2 - control.headSize * (control._ux * Math.cos(0.436) - control._uy * Math.sin(0.436))
                y: control.y2 - control.headSize * (control._uy * Math.cos(0.436) + control._ux * Math.sin(0.436))
            }
            PathLine {
                x: control.x2 - control.headSize * (control._ux * Math.cos(0.436) + control._uy * Math.sin(0.436))
                y: control.y2 - control.headSize * (control._uy * Math.cos(0.436) - control._ux * Math.sin(0.436))
            }
            PathLine { x: control.x2; y: control.y2 }
        }
    }

    // "×" delete button near the head
    Rectangle {
        visible: !control.preview
        x: control.x2 + 6
        y: control.y2 - 7
        width: 14
        height: 14
        radius: 7
        color: "#0F172A"
        border.color: control.strokeColor
        border.width: 1
        opacity: _deleteArea.containsMouse ? 1.0 : 0.8
        Text {
            anchors.centerIn: parent
            text: "×"
            color: "#FDE68A"
            font.family: Tokens.font.ui
            font.pixelSize: 12
            font.weight: Font.Medium
        }
        MouseArea {
            id: _deleteArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: control.removed()
        }
    }
}
