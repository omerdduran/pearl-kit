// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:461-464
// 20×20 radius-4 gradient / solid square holding a small icon.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property url iconSource: ""
    property string tone: "info"         // "info" | "warn" | "success" | "primary"
    property bool gradient: true
    property int size: 20
    property int iconSize: 11

    readonly property color _bgTop: {
        switch (control.tone) {
            case "warn":    return "#FEF3C7"
            case "success": return "#D1FAE5"
            case "primary": return "#BFDBFE"
            default:        return "#DBEAFE"
        }
    }
    readonly property color _bgBottom: {
        switch (control.tone) {
            case "warn":    return "#FDE68A"
            case "success": return "#A7F3D0"
            case "primary": return "#93C5FD"
            default:        return "#93C5FD"
        }
    }
    readonly property color _solidBg: {
        switch (control.tone) {
            case "warn":    return "#FFFBEB"
            case "success": return "#ECFDF5"
            case "primary": return "#EFF6FF"
            default:        return "#EFF6FF"
        }
    }

    implicitWidth: size
    implicitHeight: size
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: control.gradient ? "transparent" : control._solidBg
        gradient: control.gradient ? _diag : null

        Gradient {
            id: _diag
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: control._bgTop }
            GradientStop { position: 1.0; color: control._bgBottom }
        }
    }

    Image {
        source: control.iconSource
        sourceSize: Qt.size(control.iconSize, control.iconSize)
        width: control.iconSize
        height: control.iconSize
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        visible: control.iconSource != ""
    }
}
