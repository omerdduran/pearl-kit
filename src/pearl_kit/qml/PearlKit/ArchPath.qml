// ArchPath — dental arch spline overlay with draggable control points.
//
// Renders an open polyline through a list of image-space control
// points plus circle-handles at each. In `editing: true` mode the
// handles are draggable and emit `pointMoved(index, x, y)` during
// the drag. Non-editing mode draws the path without handles.
//
// The consumer owns the model (`points: [{x, y}, ...]`) and applies
// the drag event back to the model. The component does not mutate
// state internally.

import QtQuick
import QtQuick.Shapes

Item {
    id: control

    property var points: []          // [{x, y}, ...] in image coords
    property bool editing: false
    property bool preview: false     // draws dashed stroke (during draw)
    property color strokeColor: "#3B82F6"
    property real  strokeWidth: 2

    signal pointMoved(int index, real x, real y)
    signal pointClicked(int index)
    signal removed()

    anchors.fill: parent

    // Polyline through control points
    Shape {
        anchors.fill: parent
        antialiasing: true
        ShapePath {
            id: _path
            strokeColor: control.strokeColor
            strokeWidth: control.strokeWidth
            strokeStyle: control.preview ? ShapePath.DashLine : ShapePath.SolidLine
            dashPattern: [5, 3]
            fillColor: "transparent"
            startX: control.points.length > 0 ? control.points[0].x : 0
            startY: control.points.length > 0 ? control.points[0].y : 0
            PathMultiline {
                paths: control.points.length > 1
                    ? [ control.points.map(p => Qt.point(p.x, p.y)) ]
                    : []
            }
        }
    }

    // Control-point handles (editing mode only)
    Repeater {
        model: control.editing ? control.points.length : 0
        delegate: Item {
            x: control.points[index].x - 7
            y: control.points[index].y - 7
            width: 14
            height: 14
            Rectangle {
                anchors.fill: parent
                radius: 7
                color: "#FFFFFF"
                border.color: control.strokeColor
                border.width: 2
                opacity: _ma.drag.active ? 0.85 : 0.95
            }
            MouseArea {
                id: _ma
                anchors.fill: parent
                cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                drag.target: parent
                drag.axis: Drag.XAndYAxis
                onPositionChanged: if (drag.active) {
                    control.pointMoved(index, parent.x + 7, parent.y + 7)
                }
                onClicked: control.pointClicked(index)
            }
        }
    }

    // Non-editing read-only dot markers
    Repeater {
        model: control.editing ? 0 : control.points.length
        delegate: Rectangle {
            x: control.points[index].x - 3
            y: control.points[index].y - 3
            width: 6
            height: 6
            radius: 3
            color: control.strokeColor
            border.color: "#FFFFFF"
            border.width: 1
        }
    }
}
