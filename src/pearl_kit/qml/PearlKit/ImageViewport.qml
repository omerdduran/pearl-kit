// ImageViewport — QML wrapper around the native ImageViewportItem.
//
// Composes the 2D slice surface with the pearl-kit viewport chrome
// (axis-colored title chip, slice counter, bottom info, scroll track,
// crosshair). Consumer pushes frames via `frame` / `setFrame()`,
// wires pointer signals for crosshair / measurement / implant placement,
// and absolute-positions any additional overlays (implant markers,
// annotations) via the default slot.
//
// The native item emits pointer positions in **image coordinates** so
// existing overlay math in the consumer app keeps working unchanged.

import QtQuick
import PearlKit 1.0
import PearlKit.Viewports 1.0

Item {
    id: control

    // ---- Chrome ----
    property string plane: "axial"          // "axial" | "coronal" | "sagittal"
    property string title: plane.toUpperCase()
    property int slice: 0
    property int total: 0
    property string bottomInfo: "WL 400 · WW 2000"
    property bool showCrosshairs: true
    property bool showScrollTrack: true

    // ---- Frame (passed through to native item) ----
    property var frame: null                // QImage

    // ---- Overlays ----
    default property alias overlays: _overlaySlot.data

    // ---- Signals (forwarded from native item, image-space) ----
    signal pointerPressed(real x, real y, int buttons)
    signal pointerMoved(real x, real y, int buttons)
    signal pointerReleased(real x, real y, int buttons)
    signal wheelScrolled(int delta, int modifiers)
    signal zoomChanged(real percent)

    readonly property color _crossColor: {
        switch (control.plane) {
            case "coronal":  return "#F87171"
            case "sagittal": return "#34D399"
            default:         return "#3B82F6"
        }
    }

    implicitWidth: 240
    implicitHeight: 240

    onFrameChanged: if (_img && control.frame) _img.set_frame(control.frame)

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        border.color: "#0F172A"
        border.width: 1
        clip: true

        ImageViewportItem {
            id: _img
            anchors.fill: parent
            plane: control.plane

            onPointerPressed: (x, y, b) => control.pointerPressed(x, y, b)
            onPointerMoved:   (x, y, b) => control.pointerMoved(x, y, b)
            onPointerReleased:(x, y, b) => control.pointerReleased(x, y, b)
            onWheelScrolled:  (d, m)    => control.wheelScrolled(d, m)
            onZoomChanged:    (p)       => control.zoomChanged(p)
        }

        // Axis crosshairs (overlay on top of the native item)
        Rectangle {
            visible: control.showCrosshairs
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            color: control._crossColor
            opacity: 0.4
        }
        Rectangle {
            visible: control.showCrosshairs
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: control._crossColor
            opacity: 0.4
        }

        // Header chip (top-left, axis-colored)
        Rectangle {
            visible: control.title !== ""
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            color: Qt.rgba(3 / 255, 8 / 255, 22 / 255, 0.55)
            border.color: Qt.rgba(148 / 255, 163 / 255, 184 / 255, 0.2)
            border.width: 1
            radius: 2
            width: _title.implicitWidth + 14
            height: _title.implicitHeight + 6

            Text {
                id: _title
                text: control.title
                anchors.centerIn: parent
                color: control._crossColor
                font.family: Tokens.font.mono
                font.pixelSize: 10
                font.letterSpacing: 1.2
                font.weight: Font.Medium
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }

        // Slice counter (top-right)
        Rectangle {
            visible: control.total > 0
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            color: Qt.rgba(3 / 255, 8 / 255, 22 / 255, 0.55)
            radius: 2
            width: _counter.implicitWidth + 14
            height: _counter.implicitHeight + 6

            Text {
                id: _counter
                text: control.slice + " / " + control.total
                anchors.centerIn: parent
                color: "#CBD5E1"
                font.family: Tokens.font.mono
                font.pixelSize: 10
                font.letterSpacing: 0.8
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }

        // Bottom-left caption
        Text {
            text: control.bottomInfo
            color: "#64748B"
            font.family: Tokens.font.mono
            font.pixelSize: 10
            font.letterSpacing: 0.4
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            visible: control.bottomInfo !== ""
        }

        // Right-edge slice scroll track
        Rectangle {
            visible: control.showScrollTrack && control.total > 0
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 3
            color: Qt.rgba(148 / 255, 163 / 255, 184 / 255, 0.1)

            Rectangle {
                visible: parent.visible
                anchors.right: parent.right
                width: 3
                height: 24
                y: {
                    const ratio = control.total > 0 ? (control.slice / control.total) : 0
                    return Math.max(0, parent.height * ratio - height / 2)
                }
                color: control._crossColor
            }
        }

        // Consumer-supplied overlays (implant markers, measurements, etc.)
        Item {
            id: _overlaySlot
            anchors.fill: parent
        }
    }
}
