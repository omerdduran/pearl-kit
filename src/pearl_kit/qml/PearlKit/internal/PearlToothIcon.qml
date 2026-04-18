import QtQuick
import QtQuick.Shapes

Item {
    id: control

    property color strokeColor: "#1A202C"
    property real strokeWidth: 1.3

    implicitWidth: 24
    implicitHeight: 24

    Shape {
        id: shape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        antialiasing: true

        transform: Scale {
            xScale: control.width / 24
            yScale: control.height / 24
        }

        ShapePath {
            strokeColor: control.strokeColor
            strokeWidth: control.strokeWidth / Math.max(control.width / 24, 0.001)
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            PathSvg {
                path: "M12 3c-3.5 0-6 2-6 5 0 2 .5 3 1 5 .5 1.5.5 4 1.5 6.5.6 1.5 2.1 1.5 2.5-.5.4-2 .5-4 1-4s.6 2 1 4c.4 2 1.9 2 2.5.5 1-2.5 1-5 1.5-6.5.5-2 1-3 1-5 0-3-2.5-5-6-5Z"
            }
        }
    }
}
