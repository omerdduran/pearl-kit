// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:154-166
// Multi-color gradient bar (red → yellow → green → blue) with a thin needle
// marker pointing at the current value within [from, to]. Labels above:
// from · value · to.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property real value: 820
    property real from: -200
    property real to: 1600
    property string unit: "HU"

    property string fontFamilyMono: Tokens.font.mono
    property color labelColor: "#6B7280"
    property color valueColor: "#1A202C"
    property color markerColor: "#1A202C"

    readonly property real _clampedRatio: {
        const span = control.to - control.from
        if (span <= 0) return 0
        return Math.max(0, Math.min(1, (control.value - control.from) / span))
    }

    implicitWidth: 200
    implicitHeight: 24

    Column {
        anchors.fill: parent
        spacing: 4

        Row {
            width: parent.width

            Text {
                text: String(control.from)
                color: control.labelColor
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                renderType: Text.NativeRendering
                antialiasing: true
                width: parent.width / 3
            }

            Text {
                text: control.value + " " + control.unit
                color: control.valueColor
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                renderType: Text.NativeRendering
                antialiasing: true
                width: parent.width / 3
            }

            Text {
                text: String(control.to)
                color: control.labelColor
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                horizontalAlignment: Text.AlignRight
                renderType: Text.NativeRendering
                antialiasing: true
                width: parent.width / 3
            }
        }

        // Gradient bar
        Rectangle {
            width: parent.width
            height: 4
            radius: 2
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0;  color: "#FEE2E2" }
                GradientStop { position: 0.35; color: "#FEF3C7" }
                GradientStop { position: 0.65; color: "#D1FAE5" }
                GradientStop { position: 1.0;  color: "#DBEAFE" }
            }

            Rectangle {
                x: Math.max(0, parent.width * control._clampedRatio - width / 2)
                y: -3
                width: 2
                height: 10
                color: control.markerColor
            }
        }
    }
}
