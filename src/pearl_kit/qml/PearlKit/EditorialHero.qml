// Source: design_handoff_planning_workspace/src/report-tab.jsx:480-492
// Full-bleed section with mono eyebrow + 56px serif headline + sub-line +
// optional right-slot for action (e.g. VariantSwitch / SegmentedControl).
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string eyebrow: ""
    property string headline: ""
    property string subLine: ""

    property int padTop: 40
    property int padRight: 60
    property int padBottom: 32
    property int padLeft: 60

    property int maxHeadlineWidth: 720
    property int maxSubLineWidth: 680

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui
    property string fontFamilySerif: "Times New Roman"

    property color background: "#FFFFFF"
    property color borderColor: "#E2E8F0"
    property color eyebrowColor: "#9CA3AF"
    property color headlineColor: "#1A202C"
    property color subLineColor: "#4A5568"

    default property alias rightSlot: _rightSlot.data

    implicitWidth: 960
    implicitHeight: _col.implicitHeight + padTop + padBottom

    Rectangle {
        anchors.fill: parent
        color: control.background

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: control.borderColor
        }
    }

    Item {
        id: _rightSlot
        anchors.top: parent.top
        anchors.topMargin: control.padTop - 16
        anchors.right: parent.right
        anchors.rightMargin: control.padRight
        width: childrenRect.width
        height: childrenRect.height
    }

    Column {
        id: _col
        anchors.top: parent.top
        anchors.topMargin: control.padTop
        anchors.left: parent.left
        anchors.leftMargin: control.padLeft
        spacing: 10
        width: Math.min(parent.width - control.padLeft - control.padRight, control.maxHeadlineWidth)

        Text {
            text: control.eyebrow
            color: control.eyebrowColor
            font.family: control.fontFamilyMono
            font.pixelSize: 10
            font.letterSpacing: 2.0
            font.capitalization: Font.AllUppercase
            renderType: Text.NativeRendering
            antialiasing: true
            visible: control.eyebrow !== ""
        }

        Text {
            text: control.headline
            color: control.headlineColor
            font.family: control.fontFamilySerif
            font.pixelSize: 56
            font.letterSpacing: -0.02 * 56
            lineHeight: 1.0
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.WordWrap
            width: parent.width
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Text {
            text: control.subLine
            color: control.subLineColor
            font.family: control.fontFamilyUI
            font.pixelSize: 15
            lineHeight: 1.6
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.WordWrap
            width: Math.min(parent.width, control.maxSubLineWidth)
            renderType: Text.NativeRendering
            antialiasing: true
            visible: control.subLine !== ""
        }
    }
}
