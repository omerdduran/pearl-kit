// VTKViewport — QML wrapper around the native VTKViewportItem.
//
// Composes the VTK render surface with the standard pearl-kit viewport
// chrome (dark background, optional title chip, orientation cube, slice
// counter, bottom info caption) so consumers don't have to re-assemble
// those elements for every 3D viewport.
//
// Callers get the native item via the `nativeItem` property to wire up
// their VTK pipeline (renderer, camera, actors, presets).

import QtQuick
import PearlKit 1.0
import PearlKit.Viewports 1.0

Item {
    id: control

    // ---- Chrome ----
    property string title: "3D"
    property string bottomInfo: ""
    property bool showOrientationCube: true
    property bool showTitleChip: true

    // ---- Slot for consumer overlays (absolute-positioned) ----
    default property alias overlays: _overlaySlot.data

    // ---- Expose native item so callers can build the pipeline ----
    property alias nativeItem: _vtk
    readonly property bool vtkReady: _vtk && _vtk.renderWindow !== null

    // ---- Forwarded signals (emitted by the native item) ----
    signal firstRenderCompleted()
    signal renderFinished(real ms)

    implicitWidth: 320
    implicitHeight: 320

    Rectangle {
        anchors.fill: parent
        color: "#0B1120"
        border.color: "#0F172A"
        border.width: 1
        clip: true

        VTKViewportItem {
            id: _vtk
            objectName: "_vtkNativeItem"
            anchors.fill: parent
            onFirstRenderCompleted: control.firstRenderCompleted()
            onRenderFinished: (ms) => control.renderFinished(ms)
        }

        // Title chip (top-left)
        Rectangle {
            visible: control.showTitleChip && control.title !== ""
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            color: Qt.rgba(3 / 255, 8 / 255, 22 / 255, 0.55)
            border.color: Qt.rgba(148 / 255, 163 / 255, 184 / 255, 0.2)
            border.width: 1
            radius: 2
            width: _titleLabel.implicitWidth + 14
            height: _titleLabel.implicitHeight + 6

            Text {
                id: _titleLabel
                text: control.title
                anchors.centerIn: parent
                color: "#BFDBFE"
                font.family: Tokens.font.mono
                font.pixelSize: 10
                font.letterSpacing: 1.2
                font.weight: Font.Medium
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }

        // Orientation cube (bottom-right)
        OrientationCube {
            visible: control.showOrientationCube
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
        }

        // Bottom-left caption
        Text {
            visible: control.bottomInfo !== ""
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
        }

        // Consumer overlay slot
        Item {
            id: _overlaySlot
            anchors.fill: parent
        }
    }
}
