// Source: design_handoff_onboarding/src/onboarding.jsx:219-239
// Profile-step "Tap to sign" affordance: 64px tall dashed rectangle that
// renders mono placeholder when unsigned and cursive ink when signed, with
// a side outline button (OPEN CANVAS / REDRAW). Visual-only — actual
// signature capture is the consumer's responsibility.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property bool signed: false
    property string signatureText: ""
    property string placeholder: "DRAW SIGNATURE"
    property string drawLabel: "OPEN CANVAS"
    property string redrawLabel: "REDRAW"
    property color accentColor: "#2563EB"
    property color signedTextColor: "#1E3A8A"
    property color signedBackground: "#EFF6FF"
    property color unsignedBackground: "#FAFBFC"
    property color unsignedBorder: "#CBD5E1"
    property color placeholderColor: "#9CA3AF"
    property int padHeight: 64

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyCursive: "Dancing Script"

    signal requestRedraw()

    implicitWidth: 360
    implicitHeight: padHeight

    RowLayout {
        anchors.fill: parent
        spacing: 10

        Item {
            id: _frame
            Layout.fillWidth: true
            Layout.preferredHeight: control.padHeight

            Canvas {
                anchors.fill: parent
                onPaint: {
                    const ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.fillStyle = control.signed ? control.signedBackground : control.unsignedBackground
                    const r = 5
                    ctx.beginPath()
                    ctx.moveTo(r, 0)
                    ctx.lineTo(width - r, 0)
                    ctx.quadraticCurveTo(width, 0, width, r)
                    ctx.lineTo(width, height - r)
                    ctx.quadraticCurveTo(width, height, width - r, height)
                    ctx.lineTo(r, height)
                    ctx.quadraticCurveTo(0, height, 0, height - r)
                    ctx.lineTo(0, r)
                    ctx.quadraticCurveTo(0, 0, r, 0)
                    ctx.closePath()
                    ctx.fill()
                    ctx.lineWidth = 1
                    ctx.strokeStyle = control.signed ? control.accentColor : control.unsignedBorder
                    ctx.setLineDash([4, 4])
                    ctx.stroke()
                }

                Connections {
                    target: control
                    function onSignedChanged() { parent.requestPaint() }
                }
            }

            Text {
                anchors.centerIn: parent
                visible: control.signed && control.signatureText !== ""
                text: control.signatureText
                color: control.signedTextColor
                font.family: control.fontFamilyCursive
                font.pixelSize: 28
                renderType: Text.NativeRendering
                antialiasing: true
            }

            Text {
                anchors.centerIn: parent
                visible: !control.signed
                text: control.placeholder
                color: control.placeholderColor
                font.family: control.fontFamilyMono
                font.pixelSize: 12
                font.letterSpacing: 0.7
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }

        Rectangle {
            id: _btn
            Layout.preferredWidth: _btnText.implicitWidth + 26
            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: _btnArea.containsMouse ? "#F7F8FA" : "#FFFFFF"
            border.color: "#E2E8F0"
            border.width: 1

            Text {
                id: _btnText
                anchors.centerIn: parent
                text: control.signed ? control.redrawLabel : control.drawLabel
                color: "#4A5568"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.letterSpacing: 0.66
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _btnArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: control.requestRedraw()
            }
        }
    }
}
