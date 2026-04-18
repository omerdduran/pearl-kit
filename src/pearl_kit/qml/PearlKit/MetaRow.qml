import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string label: ""
    property string value: ""
    property bool valueMono: true
    property string monoFontFamily: Tokens.font.mono
    property string sansFontFamily: Tokens.font.ui
    property color labelColor: "#8A93A0"
    property color valueColor: "#1A202C"
    property int elideMode: Text.ElideNone
    property int valueGap: 12

    implicitWidth: _label.implicitWidth + _value.implicitWidth + 24
    implicitHeight: Math.max(_label.implicitHeight, _value.implicitHeight) + 12

    Text {
        id: _label
        text: control.label
        color: control.labelColor
        font.family: control.monoFontFamily
        font.pixelSize: 10
        font.weight: Font.Medium
        font.letterSpacing: 0.6
        font.capitalization: Font.AllUppercase
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: _value
        text: control.value
        color: control.valueColor
        font.family: control.valueMono ? control.monoFontFamily : control.sansFontFamily
        font.pixelSize: 12
        elide: control.elideMode
        horizontalAlignment: Text.AlignRight
        renderType: Text.NativeRendering
        antialiasing: true
        anchors.left: _label.right
        anchors.leftMargin: control.valueGap
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}
