// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:419-433
// Symmetric ±range slider with a 0-tick at the track center. Thin 2px track
// with a small 12×12 thumb. Labels row below: -max°, 0°, +max°.
import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

Item {
    id: control

    property real value: 0
    property real range: 15       // symmetric ±range
    property string unit: "\u00B0" // °

    property string fontFamilyMono: Tokens.font.mono
    property color thumbColor: "#2563EB"
    property color trackColor: "#F1F5F9"
    property color tickColor: "#D1D5DB"
    property color labelColor: "#9CA3AF"

    signal moved(real value)

    implicitWidth: 220
    implicitHeight: 44

    Column {
        anchors.fill: parent
        spacing: 4

        T.Slider {
            id: _slider
            width: parent.width
            height: 20
            from: -control.range
            to: control.range
            value: control.value
            stepSize: 0.5
            padding: 0

            onMoved: {
                control.value = _slider.value
                control.moved(control.value)
            }

            background: Item {
                x: _slider.leftPadding
                y: _slider.topPadding + _slider.availableHeight / 2 - 1
                width: _slider.availableWidth
                height: 2

                Rectangle {
                    anchors.fill: parent
                    color: control.trackColor
                    radius: 1
                }

                // Center tick
                Rectangle {
                    x: parent.width * 0.5 - width / 2
                    y: -3
                    width: 1
                    height: 8
                    color: control.tickColor
                }
            }

            handle: Rectangle {
                x: _slider.leftPadding + _slider.visualPosition * (_slider.availableWidth - width)
                y: _slider.topPadding + (_slider.availableHeight - height) / 2
                width: 12
                height: 12
                radius: 6
                color: control.thumbColor
            }
        }

        Item {
            width: parent.width
            height: 12

            Text {
                text: "\u2212" + control.range + control.unit
                color: control.labelColor
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                renderType: Text.NativeRendering
                antialiasing: true
                anchors.left: parent.left
            }
            Text {
                text: "0" + control.unit
                color: control.labelColor
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                renderType: Text.NativeRendering
                antialiasing: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "+" + control.range + control.unit
                color: control.labelColor
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                renderType: Text.NativeRendering
                antialiasing: true
                anchors.right: parent.right
            }
        }
    }
}
