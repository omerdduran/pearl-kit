// AngleArc — 3-point angle measurement overlay.
//
// Draws two line segments from a vertex to two endpoints (p1, p2), a
// small arc between the two rays, and a degree label near the vertex.
// Mirrors DistanceLine's API — coordinates are image-space, delete
// button sits next to the label.
//
// Preview mode: set `preview: true`. When only `p1` is known (no
// vertex yet), give x1==xv / y1==yv; the line collapses. When vertex
// is known and p2 is the live-cursor, pass the cursor into (x2, y2)
// and leave `angle` as-is — the component recalculates.

import QtQuick
import QtQuick.Shapes

Item {
    id: control

    // ---- Inputs ----
    property real x1: 0
    property real y1: 0
    property real xv: 0
    property real yv: 0
    property real x2: 0
    property real y2: 0
    property real angle: 0          // degrees — precomputed by the bridge
    property string label: ""       // e.g. "47.5°"
    property bool preview: false
    property bool selected: false
    property color strokeColor: "#A855F7"   // purple-500
    property color labelColor: "#0F172A"
    property color labelBg: "#EDE9FE"       // purple-100

    // ---- Signals ----
    signal removed()
    signal clicked()

    anchors.fill: parent

    // Arms
    Shape {
        anchors.fill: parent
        antialiasing: true
        ShapePath {
            strokeColor: control.strokeColor
            strokeWidth: control.selected ? 2.2 : 1.5
            strokeStyle: control.preview ? ShapePath.DashLine : ShapePath.SolidLine
            dashPattern: [4, 3]
            fillColor: "transparent"
            startX: control.x1
            startY: control.y1
            PathLine { x: control.xv; y: control.yv }
            PathLine { x: control.x2; y: control.y2 }
        }
    }

    // Endpoint + vertex dots
    Repeater {
        model: control.preview ? [] : [
            Qt.point(control.x1, control.y1),
            Qt.point(control.xv, control.yv),
            Qt.point(control.x2, control.y2)
        ]
        delegate: Rectangle {
            x: modelData.x - 3
            y: modelData.y - 3
            width: 6
            height: 6
            radius: 3
            color: control.strokeColor
            border.color: "#0F172A"
            border.width: 1
        }
    }

    // Label chip — anchored near the vertex, offset along the bisector.
    Rectangle {
        id: _labelChip
        visible: control.label !== ""
        x: control.xv + 14
        y: control.yv - height - 6
        width: _labelText.implicitWidth + 14
        height: _labelText.implicitHeight + 6
        radius: 3
        color: control.labelBg
        border.color: control.strokeColor
        border.width: 1

        Text {
            id: _labelText
            anchors.centerIn: parent
            text: control.label
            color: control.labelColor
            font.family: Tokens.font.mono
            font.pixelSize: 10
            font.letterSpacing: 0.6
            font.weight: Font.Medium
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: control.clicked()
        }
    }

    // "×" delete button
    Rectangle {
        visible: !control.preview
        x: _labelChip.x + _labelChip.width + 4
        y: _labelChip.y + (_labelChip.height - 14) / 2
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
            color: "#EDE9FE"
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
