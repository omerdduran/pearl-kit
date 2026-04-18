import QtQuick
import QtQuick.Shapes
import QtQuick.Templates as T
import PearlKit 1.0

T.TextField {
    id: control

    property string shortcutHint: "\u2318K"
    property color borderColor: "#DDE2EA"
    property string fontFamily: Tokens.font.ui
    property string monoFontFamily: Tokens.font.mono

    implicitHeight: 32
    implicitWidth: 280
    topPadding: 4
    bottomPadding: 4
    leftPadding: 34
    rightPadding: 48

    font.family: control.fontFamily
    font.pixelSize: 13

    color: "#1A202C"
    placeholderTextColor: "#8A93A0"
    selectionColor: Qt.rgba(37 / 255, 99 / 255, 235 / 255, 0.25)
    selectedTextColor: "#1A202C"
    selectByMouse: true
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    verticalAlignment: TextInput.AlignVCenter

    background: Rectangle {
        radius: 4
        color: "#FFFFFF"
        border.color: control.activeFocus ? "#2563EB" : control.borderColor
        border.width: 1

        Behavior on border.color {
            ColorAnimation { duration: Tokens.motion.fast }
        }

        Shape {
            id: glass
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            width: 14; height: 14
            antialiasing: true

            ShapePath {
                strokeColor: "#8A93A0"
                strokeWidth: 1.5
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: 6; centerY: 6
                    radiusX: 5; radiusY: 5
                    startAngle: 0
                    sweepAngle: 360
                }
            }
            ShapePath {
                strokeColor: "#8A93A0"
                strokeWidth: 1.5
                capStyle: ShapePath.RoundCap
                startX: 9.5; startY: 9.5
                PathLine { x: 13; y: 13 }
            }
        }

        Rectangle {
            id: hint
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            width: _hintText.implicitWidth + 12
            height: 18
            radius: 3
            color: "#F4F5F8"
            visible: control.shortcutHint !== ""

            Text {
                id: _hintText
                text: control.shortcutHint
                anchors.centerIn: parent
                color: "#8A93A0"
                font.family: control.monoFontFamily
                font.pixelSize: 10
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }
    }
}
