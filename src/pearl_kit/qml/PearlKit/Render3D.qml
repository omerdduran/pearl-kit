import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string topLabel: "3D \u00B7 VOLUMETRIC"
    property string bottomRightLabel: "0.3mm \u00B7 512\u00B3"
    property string bottomLeftLabel: "\u25C9 canal detected"
    property string monoFontFamily: Tokens.font.mono
    property bool showImplantMarker: true
    property bool showCanalHint: true
    property url imageSource: ""

    readonly property bool _hasImage: imageSource.toString() !== ""

    implicitWidth: 300
    implicitHeight: 200

    Rectangle {
        id: base
        anchors.fill: parent
        radius: 4
        color: "#050812"
        border.color: Qt.rgba(15/255, 23/255, 42/255, 0.2)
        border.width: 1
        clip: true

        Image {
            anchors.fill: parent
            source: control.imageSource
            visible: control._hasImage
            fillMode: Image.PreserveAspectCrop
            cache: false
            asynchronous: true
            smooth: true
        }

        Rectangle {
            visible: !control._hasImage
            anchors.centerIn: parent
            width: parent.width * 1.1
            height: parent.height * 1.1
            radius: width / 2
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#24334F" }
                GradientStop { position: 0.7; color: "#0E1526" }
                GradientStop { position: 1.0; color: "#050812" }
            }
        }

        Rectangle {
            visible: !control._hasImage
            x: parent.width * 0.15
            y: parent.height * 0.25
            width: parent.width * 0.7
            height: parent.height * 0.55
            radius: height / 2
            opacity: 0.6
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.rgba(220/255, 230/255, 245/255, 0.8) }
                GradientStop { position: 0.55; color: Qt.rgba(140/255, 160/255, 200/255, 0.2) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0) }
            }
        }

        Rectangle {
            visible: !control._hasImage
            x: parent.width * 0.28
            y: parent.height * 0.38
            width: parent.width * 0.44
            height: parent.height * 0.32
            radius: height / 2
            opacity: 0.55
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.5) }
                GradientStop { position: 0.65; color: Qt.rgba(0, 0, 0, 0) }
            }
        }

        Rectangle {
            visible: !control._hasImage && control.showImplantMarker
            width: 4; height: 46; radius: 2
            x: parent.width * 0.42
            y: parent.height * 0.48
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#DBEAFE" }
                GradientStop { position: 1.0; color: "#2563EB" }
            }
        }

        Rectangle {
            visible: !control._hasImage && control.showImplantMarker
            width: 8; height: 50; radius: 4
            x: parent.width * 0.42 - 2
            y: parent.height * 0.48 - 2
            color: Qt.rgba(37/255, 99/255, 235/255, 0.35)
            z: -1
        }

        Rectangle {
            visible: !control._hasImage && control.showCanalHint
            x: parent.width * 0.22
            y: parent.height * 0.62
            width: parent.width * 0.54
            height: 1
            color: "#FBBF24"
            opacity: 0.55
            transform: Rotation {
                origin.x: 0; origin.y: 0
                angle: -4
            }
        }

        Text {
            text: control.topLabel
            color: "#93C5FD"
            font.family: control.monoFontFamily
            font.pixelSize: 10
            font.weight: Font.Medium
            font.letterSpacing: 1.0
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.topMargin: 8
        }

        Text {
            text: control.bottomRightLabel
            color: "#64748B"
            font.family: control.monoFontFamily
            font.pixelSize: 9
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 10
            anchors.bottomMargin: 8
        }

        Text {
            text: control.bottomLeftLabel
            visible: control.bottomLeftLabel !== ""
            color: "#34D399"
            font.family: control.monoFontFamily
            font.pixelSize: 9
            renderType: Text.NativeRendering
            antialiasing: true
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.bottomMargin: 8
        }
    }
}
