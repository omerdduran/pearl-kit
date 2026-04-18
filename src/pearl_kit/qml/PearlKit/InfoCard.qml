import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string tone: "info"
    // tone: "info" | "warning" | "success" | "neutral"
    property int padding: 12
    property int radius: 6

    default property alias contentData: _col.data

    readonly property QtObject _tone: QtObject {
        readonly property color bg: {
            switch (control.tone) {
                case "warning": return "#FFFBEB"
                case "success": return "#ECFDF5"
                case "neutral": return "#F7F8FA"
                default:        return "#EFF6FF"
            }
        }
        readonly property color border: {
            switch (control.tone) {
                case "warning": return "#FDE68A"
                case "success": return "#A7F3D0"
                case "neutral": return "#ECEEF2"
                default:        return "#DBEAFE"
            }
        }
    }

    implicitWidth:  Math.max(_col.implicitWidth + 2 * padding, 160)
    implicitHeight: _col.implicitHeight + 2 * padding

    Rectangle {
        anchors.fill: parent
        radius: control.radius
        color: control._tone.bg
        border.color: control._tone.border
        border.width: 1
    }

    Column {
        id: _col
        x: control.padding
        y: control.padding
        width: parent.width - 2 * control.padding
        spacing: 4
    }
}
