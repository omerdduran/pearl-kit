// ImplantMarker — 5x52 px vertical implant indicator for 2D viewports.
//
// Absolute-positioned inside an `ImageViewport` / `Viewport2D` overlay slot.
// Colour gradient encodes state (blue for OK, amber for warn); a soft glow
// shadow reinforces saliency on the dark viewport bg. Selection ring fades
// in when `selected === true`. Click + drag emit signals so the consumer
// can implement select / move behaviour without owning the hit-test.

import QtQuick

Item {
    id: control

    // ---- Inputs ----
    property string identifier: "I1"
    property string state: "ok"          // "ok" | "warn" | "selected"
    property bool selected: false
    property real angle: 0               // degrees, rotates the marker
    property bool interactive: true

    // ---- Signals ----
    signal clicked()
    signal dragged(real dx, real dy)     // view-space delta since last event
    signal dragReleased()

    implicitWidth: 5
    implicitHeight: 52

    readonly property color _top: {
        switch (control.state) {
            case "warn":     return "#FEF3C7"
            case "selected": return "#DBEAFE"
            default:         return "#DBEAFE"
        }
    }
    readonly property color _bottom: {
        switch (control.state) {
            case "warn":     return "#F59E0B"
            case "selected": return "#2563EB"
            default:         return "#2563EB"
        }
    }
    readonly property color _border: {
        switch (control.state) {
            case "warn":     return Qt.rgba(252 / 255, 211 / 255, 77 / 255, 0.6)
            default:         return Qt.rgba(147 / 255, 197 / 255, 253 / 255, 0.6)
        }
    }

    transform: Rotation {
        origin.x: control.width / 2
        origin.y: control.height / 2
        angle: control.angle
    }

    // Soft glow
    Rectangle {
        anchors.centerIn: parent
        width: parent.width + 8
        height: parent.height + 8
        radius: (parent.width + 8) / 2
        color: Qt.rgba(_bottom.r, _bottom.g, _bottom.b, 0.35)
        opacity: control.selected ? 0.9 : 0.5
    }

    // Main body
    Rectangle {
        anchors.fill: parent
        radius: Math.min(width, height) / 3
        border.color: control._border
        border.width: 1
        gradient: Gradient {
            GradientStop { position: 0.0; color: control._top }
            GradientStop { position: 1.0; color: control._bottom }
        }
    }

    // Selection ring
    Rectangle {
        visible: control.selected
        anchors.centerIn: parent
        width: parent.width + 4
        height: parent.height + 4
        radius: (parent.width + 4) / 2
        color: "transparent"
        border.color: "#F59E0B"
        border.width: 1.5
        opacity: 0.95
    }

    // ID label pill above the marker
    Rectangle {
        visible: control.identifier !== ""
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 4
        width: _id.implicitWidth + 8
        height: _id.implicitHeight + 3
        radius: 2
        color: Qt.rgba(3 / 255, 8 / 255, 22 / 255, 0.7)
        border.color: control._border
        border.width: 1
        Text {
            id: _id
            anchors.centerIn: parent
            text: control.identifier
            color: "#DBEAFE"
            font.family: Tokens.font.mono
            font.pixelSize: 9
            font.letterSpacing: 0.8
            font.weight: Font.Medium
        }
    }

    MouseArea {
        id: _ma
        anchors.fill: parent
        enabled: control.interactive
        hoverEnabled: true
        cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.PointingHandCursor

        property point _last: Qt.point(0, 0)

        onPressed: (ev) => {
            _last = Qt.point(ev.x, ev.y)
        }
        onPositionChanged: (ev) => {
            if (!pressed) return
            const dx = ev.x - _last.x
            const dy = ev.y - _last.y
            control.dragged(dx, dy)
        }
        onReleased: control.dragReleased()
        onClicked: control.clicked()
    }
}
