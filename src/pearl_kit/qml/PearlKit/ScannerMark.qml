import QtQuick
import QtQuick.Shapes
import PearlKit 1.0
import PearlKit.internal 1.0

Item {
    id: control

    property int diameter: 150
    property int centerSize: 68
    property int iconSize: 36
    property color dashedRingColor: "#D8E4F5"
    property color solidRingColor: "#B9CCE7"
    property color sweepColor: "#2563EB"
    property color centerBg: "#FFFFFF"
    property color centerBorder: "#DDE2EA"
    property color toothStroke: "#1A202C"

    implicitWidth: diameter
    implicitHeight: diameter

    Shape {
        id: dashedRing
        anchors.fill: parent
        antialiasing: true

        transform: Rotation {
            origin.x: control.width / 2
            origin.y: control.height / 2
            angle: 0
            RotationAnimation on angle {
                from: 0; to: 360
                duration: 14000
                loops: Animation.Infinite
                running: control.visible
            }
        }

        ShapePath {
            strokeColor: control.dashedRingColor
            strokeWidth: 1
            fillColor: "transparent"
            strokeStyle: ShapePath.DashLine
            dashPattern: [2, 6]

            PathAngleArc {
                centerX: control.width / 2
                centerY: control.height / 2
                radiusX: 70; radiusY: 70
                startAngle: 0
                sweepAngle: 360
            }
        }
    }

    Shape {
        id: solidRing
        anchors.fill: parent
        antialiasing: true

        transform: Rotation {
            origin.x: control.width / 2
            origin.y: control.height / 2
            angle: 0
            RotationAnimation on angle {
                from: 360; to: 0
                duration: 22000
                loops: Animation.Infinite
                running: control.visible
            }
        }

        ShapePath {
            strokeColor: control.solidRingColor
            strokeWidth: 0.75
            fillColor: "transparent"

            PathAngleArc {
                centerX: control.width / 2
                centerY: control.height / 2
                radiusX: 58; radiusY: 58
                startAngle: 0
                sweepAngle: 360
            }
        }
    }

    Shape {
        id: sweepArc
        anchors.fill: parent
        antialiasing: true

        transform: Rotation {
            origin.x: control.width / 2
            origin.y: control.height / 2
            angle: 0
            RotationAnimation on angle {
                from: 0; to: 360
                duration: 2400
                loops: Animation.Infinite
                running: control.visible
                easing.type: Easing.InOutCubic
            }
        }

        ShapePath {
            strokeColor: control.sweepColor
            strokeWidth: 1.5
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: control.width / 2
                centerY: control.height / 2
                radiusX: 64; radiusY: 64
                startAngle: -90
                sweepAngle: 90
            }
        }
    }

    Rectangle {
        id: centerShadow
        anchors.centerIn: parent
        width: control.centerSize + 8
        height: control.centerSize + 8
        radius: 18
        color: Qt.rgba(37 / 255, 99 / 255, 235 / 255, 0.08)
        z: 1
    }

    Rectangle {
        id: centerTile
        anchors.centerIn: parent
        width: control.centerSize
        height: control.centerSize
        radius: 14
        color: control.centerBg
        border.color: control.centerBorder
        border.width: 1
        z: 2
    }

    PearlToothIcon {
        anchors.centerIn: parent
        width: control.iconSize
        height: control.iconSize
        strokeColor: control.toothStroke
        strokeWidth: 1.3
        z: 3
    }
}
