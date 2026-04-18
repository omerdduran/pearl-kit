// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:32-151
// CBCT 2D slice surface. Black ground, radial atmospheric gradient, blurred
// anatomy blob, axis-colored crosshairs, header chip, slice counter, voxel
// info caption, and right-edge slice scroll track. No real DICOM render —
// chrome only. Consumer absolute-positions implant overlays via the default
// slot.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string kind: "axial"           // "axial" | "coronal" | "sagittal"
    property string title: ""
    property int slice: 0
    property int total: 0
    property string bottomInfo: "WL 400 · WW 2000"
    property bool showCrosshairs: true
    property bool showScrollTrack: true

    property string fontFamilyMono: Tokens.font.mono

    default property alias overlays: _overlaySlot.data

    readonly property color _crossColor: {
        switch (control.kind) {
            case "coronal":  return "#F87171"
            case "sagittal": return "#34D399"
            default:         return "#3B82F6"
        }
    }

    implicitWidth: 240
    implicitHeight: 240

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        border.color: "#0F172A"
        border.width: 1
        clip: true

        // Volumetric atmosphere — radial gradient simulated with stacked circles
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2A3650" }
                GradientStop { position: 0.7; color: "#121A2B" }
                GradientStop { position: 1.0; color: "#0B111E" }
            }
        }

        // Blurred anatomy blob — approximated as a soft-edged ellipse
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.55
            radius: Math.min(width, height) / 2
            color: Qt.rgba(210 / 255, 225 / 255, 245 / 255, 0.35)
            opacity: 0.85
        }

        // Implant silhouette (centered indicator) — the 2D cross-section cue
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -2
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -6
            width: 7
            height: parent.height * 0.25
            radius: 3
            border.color: Qt.rgba(147 / 255, 197 / 255, 253 / 255, 0.6)
            border.width: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(219 / 255, 234 / 255, 254 / 255, 0.7) }
                GradientStop { position: 1.0; color: Qt.rgba(37 / 255, 99 / 255, 235 / 255, 0.9) }
            }
        }

        // Axis crosshairs
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
                font.family: control.fontFamilyMono
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
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                font.letterSpacing: 0.8
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }

        // Bottom-left voxel / WL/WW caption
        Text {
            text: control.bottomInfo
            color: "#64748B"
            font.family: control.fontFamilyMono
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

        // Consumer-supplied absolute-positioned overlays (implant markers, labels)
        Item {
            id: _overlaySlot
            anchors.fill: parent
        }
    }
}
