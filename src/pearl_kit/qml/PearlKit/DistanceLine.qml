// DistanceLine — 2D distance measurement overlay for ImageViewport.
//
// Renders a line between two image-space points plus an axis-aligned
// length label. Coordinates are **image-space** (same convention as
// Crosshair / ImplantMarker) — consumers supply pixel-scaled positions
// and the component anchors itself to them via absolute positioning
// inside the parent (typically the ImageViewport overlay slot).
//
// The component is purely presentational: no hit-testing on the line
// itself, no drag handles. A 14 px "×" delete button sits at the
// midpoint; clicking it emits `removed()`.
//
// Preview mode (`preview: true`) renders a dashed, semi-transparent
// stroke without the delete button — the consumer uses this for the
// interim rubber-band line shown between the first click and the
// second click.

import QtQuick
import QtQuick.Shapes

Item {
    id: control

    // ---- Inputs ----
    property real x1: 0
    property real y1: 0
    property real x2: 0
    property real y2: 0
    property string label: ""     // e.g. "12.3 mm" — empty hides the chip
    property bool preview: false  // dashed rubber-band style
    property bool selected: false
    property color strokeColor: "#FACC15"  // amber-400
    property color labelColor: "#0F172A"
    property color labelBg: "#FEF3C7"      // amber-100

    // ---- Signals ----
    signal removed()
    signal clicked()

    anchors.fill: parent

    readonly property real _midX: (control.x1 + control.x2) / 2
    readonly property real _midY: (control.y1 + control.y2) / 2
    readonly property real _length: Math.hypot(control.x2 - control.x1, control.y2 - control.y1)

    // Line stroke
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
            PathLine { x: control.x2; y: control.y2 }
        }
    }

    // Endpoint dots
    Repeater {
        model: control.preview ? [] : [Qt.point(control.x1, control.y1), Qt.point(control.x2, control.y2)]
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

    // Midpoint label chip
    Rectangle {
        id: _labelChip
        visible: control.label !== ""
        x: control._midX - width / 2
        y: control._midY - height - 10
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

    // Delete "×" button — 14 px circle next to the label
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
            color: "#FEF3C7"
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
