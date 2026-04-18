// Source: design_handoff_planning_workspace/src/report-tab.jsx:139-155
// Input + send button. Enter in the input triggers submit. Button is mono
// uppercase dark (#1A202C). Emits submitted(text: string).
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property alias text: _input.text
    property string placeholder: "Ask about bone, safety, alternatives…"
    property string submitLabel: "ASK"

    property string fontFamilyMono: Tokens.font.mono

    signal submitted(string text)

    implicitWidth: 320
    implicitHeight: Math.max(32, _row.implicitHeight)

    RowLayout {
        id: _row
        anchors.fill: parent
        spacing: 6

        Input {
            id: _input
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            placeholderText: control.placeholder
            Keys.onReturnPressed: control._submit()
            Keys.onEnterPressed: control._submit()
        }

        Rectangle {
            Layout.preferredWidth: _btnText.implicitWidth + 24
            Layout.preferredHeight: 32
            radius: 4
            color: _sendArea.containsMouse ? "#0F172A" : "#1A202C"
            Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }

            Text {
                id: _btnText
                anchors.centerIn: parent
                text: control.submitLabel
                color: "#FFFFFF"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.letterSpacing: 0.66
                font.weight: Font.DemiBold
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _sendArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: control._submit()
            }
        }
    }

    function _submit() {
        const t = _input.text
        if (t.trim().length === 0) return
        control.submitted(t)
        _input.text = ""
    }
}
