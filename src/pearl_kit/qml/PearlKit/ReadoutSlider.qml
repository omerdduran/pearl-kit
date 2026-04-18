// Source: design_handoff_settings/src/settings.jsx:192-211
// 340px total: track + thumb on the left, mono right-aligned readout
// column (72px) showing "value unit". Precision auto: one decimal when
// stepSize < 1, integer otherwise.
import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

Item {
    id: control

    property real value: 0
    property real from: 0
    property real to: 1
    property real stepSize: 0.1
    property string unit: ""

    property string fontFamilyMono: Tokens.font.mono
    property color trackColor: "#F1F5F9"
    property color fillColor: "#2563EB"
    property color thumbColor: "#FFFFFF"
    property color thumbBorderColor: "#2563EB"
    property color readoutColor: "#1A202C"

    signal moved(real value)

    implicitWidth: 340
    implicitHeight: 20

    readonly property string _readoutText: {
        const precision = control.stepSize < 1 ? 1 : 0
        const formatted = typeof control.value === "number"
            ? control.value.toFixed(precision)
            : String(control.value)
        return control.unit !== ""
            ? (formatted + " " + control.unit)
            : formatted
    }

    T.Slider {
        id: _slider
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - 72 - 14
        height: 20
        from: control.from
        to: control.to
        value: control.value
        stepSize: control.stepSize
        padding: 0

        onMoved: {
            control.value = _slider.value
            control.moved(control.value)
        }

        background: Item {
            x: 0
            y: _slider.height / 2 - 1
            width: _slider.width
            height: 2

            Rectangle {
                anchors.fill: parent
                color: control.trackColor
                radius: 1
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * _slider.visualPosition
                color: control.fillColor
                radius: 1
            }
        }

        handle: Rectangle {
            x: _slider.visualPosition * (_slider.width - width)
            y: _slider.height / 2 - height / 2
            width: 14
            height: 14
            radius: 7
            color: control.thumbColor
            border.color: control.thumbBorderColor
            border.width: 2
        }
    }

    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 72
        horizontalAlignment: Text.AlignRight
        text: control._readoutText
        color: control.readoutColor
        font.family: control.fontFamilyMono
        font.pixelSize: 12
        font.weight: Font.Medium
        renderType: Text.NativeRendering
        antialiasing: true
    }
}
