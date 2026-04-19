// Source: design_handoff_onboarding/src/onboarding.jsx:380-404
// Ready-step sample case hero rectangle: 140px tall dark surface with a
// faux volumetric blob and N implant marker bars. Mono chips top-left and
// top-right. Default-property slot lets consumers replace the decoration
// with a real CBCT thumbnail.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string topLeftLabel: "SAMPLE \u00B7 3D VOLUMETRIC"
    property string topRightLabel: ""
    property int markerCount: 2
    property int previewHeight: 140
    property color background: "#0B1120"
    property color topLeftColor: "#93C5FD"
    property color topRightColor: "#6B7280"
    property color markerLow: "#60A5FA"
    property color markerHigh: "#2563EB"

    property string fontFamilyMono: Tokens.font.mono

    default property alias overlayContent: _overlay.data

    implicitWidth: 360
    implicitHeight: previewHeight

    Rectangle {
        anchors.fill: parent
        color: control.background
        clip: true

        // Subtle radial-ish ambient gradient (vertical fallback for QtQuick)
        Rectangle {
            anchors.fill: parent
            opacity: 0.6
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.rgba(59/255, 130/255, 246/255, 0.18) }
                GradientStop { position: 1.0; color: Qt.rgba(11/255, 17/255, 32/255, 0.0) }
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: parent.width * 0.7
            height: parent.height * 0.9
            opacity: 0.45
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.rgba(139/255, 92/255, 246/255, 0.0) }
                GradientStop { position: 1.0; color: Qt.rgba(139/255, 92/255, 246/255, 0.35) }
            }
        }

        // Centered volumetric blob
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.55
            height: parent.height * 0.6
            radius: height / 2
            opacity: 0.65
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.rgba(212/255, 184/255, 150/255, 0.65) }
                GradientStop { position: 0.55; color: Qt.rgba(139/255, 115/255, 89/255, 0.30) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0) }
            }
        }

        // Implant markers
        Repeater {
            model: control.markerCount

            delegate: Item {
                anchors.verticalCenter: parent.verticalCenter
                width: 4
                height: 36
                x: {
                    const n = control.markerCount
                    if (n <= 1) return parent.width * 0.5 - 2
                    const spacing = parent.width * 0.12
                    const start = parent.width * 0.5 - ((n - 1) * spacing) / 2 - 2
                    return start + index * spacing
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 2
                    gradient: Gradient {
                        orientation: Gradient.Vertical
                        GradientStop { position: 0.0; color: control.markerLow }
                        GradientStop { position: 1.0; color: control.markerHigh }
                    }
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: 8
                    height: parent.height + 6
                    radius: 4
                    color: Qt.rgba(control.markerHigh.r, control.markerHigh.g, control.markerHigh.b, 0.4)
                    z: -1
                }
            }
        }

        Text {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 12
            anchors.topMargin: 10
            visible: control.topLeftLabel !== ""
            text: control.topLeftLabel
            color: control.topLeftColor
            font.family: control.fontFamilyMono
            font.pixelSize: 10
            font.letterSpacing: 1.0
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Text {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 12
            anchors.topMargin: 10
            visible: control.topRightLabel !== ""
            text: control.topRightLabel
            color: control.topRightColor
            font.family: control.fontFamilyMono
            font.pixelSize: 10
            font.letterSpacing: 0.4
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Item {
            id: _overlay
            anchors.fill: parent
        }
    }
}
