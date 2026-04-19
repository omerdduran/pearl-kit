// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:18-28
// 32×32 icon-only palette button. Active = blue-tinted background + blue
// border + blue icon.
//
// Icon sources (in priority order):
//   1. iconSource (url) — explicit raster/SVG from the consumer
//   2. iconKey (string) — resolves to a built-in Pearl*Icon glyph for
//      the known planning-tool keys: "pan" | "navigate", "distance" |
//      "measure", "place" | "plan". Unknown keys fall back to nothing.
import QtQuick
import PearlKit 1.0
import PearlKit.internal 1.0

Rectangle {
    id: control

    property url iconSource: ""
    property string iconKey: ""
    property string label: ""
    property string hotkey: ""
    property bool checked: false

    signal toggled()
    signal clicked()

    implicitWidth: 32
    implicitHeight: 32
    width: implicitWidth
    height: implicitHeight

    radius: 4
    color: control.checked
        ? "#EFF6FF"
        : (_area.containsMouse ? "#F1F5F9" : "transparent")
    border.color: control.checked ? "#BFDBFE" : "transparent"
    border.width: 1

    readonly property color _iconColor: control.checked ? "#2563EB" : "#334155"

    Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
    Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast } }

    Image {
        source: control.iconSource
        sourceSize: Qt.size(16, 16)
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        width: 16
        height: 16
        visible: control.iconSource != ""
    }

    // Built-in glyph fallback — only visible when no explicit iconSource
    // was passed in. The key strings are matched loosely so consumers
    // that use either the planning-domain key ("pan") or the palette
    // label key ("navigate") get the same icon.
    Loader {
        anchors.centerIn: parent
        width: 16
        height: 16
        active: control.iconSource == ""
        visible: active
        sourceComponent: {
            const k = (control.iconKey || "").toLowerCase()
            if (k === "pan" || k === "navigate" || k === "move") return _navigateGlyph
            if (k === "distance" || k === "measure" || k === "ruler") return _measureGlyph
            if (k === "place" || k === "plan" || k === "implant") return _planGlyph
            return null
        }
    }

    Component {
        id: _navigateGlyph
        PearlNavigateIcon { strokeColor: control._iconColor }
    }
    Component {
        id: _measureGlyph
        PearlMeasureIcon { strokeColor: control._iconColor }
    }
    Component {
        id: _planGlyph
        PearlPlanIcon { strokeColor: control._iconColor }
    }

    MouseArea {
        id: _area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            control.checked = !control.checked
            control.toggled()
            control.clicked()
        }
    }
}
