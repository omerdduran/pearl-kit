// ToolPalette — 220 px left column for the planning workspace.
//
// Composes the tool row (Navigate / Measure / Plan / additional custom
// tools) with the Window/Level preset picker beneath. Keeps the column
// layout, labels, and section dividers consistent across the planning
// workspace and any future viewers that share the same affordances.
//
// Tools are described as a model:
//     [{ key: "navigate", label: "Navigate", icon: "qrc:/.../pan.svg", hotkey: "V" },
//      { key: "measure",  label: "Measure",  icon: "qrc:/.../ruler.svg", hotkey: "M" },
//      { key: "plan",     label: "Plan",     icon: "qrc:/.../implant.svg", hotkey: "P" }]
// and the currently selected tool is tracked via `currentTool`. When the
// selection changes the control emits `toolSelected(key)`.

import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Rectangle {
    id: control

    // ---- Inputs ----
    property var tools: []                      // [{key, label, icon, hotkey}]
    property string currentTool: ""
    property string currentPreset: "bone"       // "bone" | "soft" | "implant"
    property string toolsHeader: "TOOLS"
    property string presetsHeader: "WINDOW / LEVEL"

    // ---- Signals ----
    signal toolSelected(string key)
    signal presetSelected(string key)

    implicitWidth: 220
    implicitHeight: 480

    color: "#FFFFFF"
    border.color: "#E2E8F0"
    border.width: 1
    radius: 6

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 16

        // ---- Tools section ----
        SectionLabel {
            Layout.fillWidth: true
            text: control.toolsHeader
        }

        Flow {
            Layout.fillWidth: true
            spacing: 8
            Repeater {
                model: control.tools
                delegate: ToolButton {
                    iconSource: modelData.icon || ""
                    iconKey: modelData.iconKey || modelData.key || ""
                    label: modelData.label || ""
                    hotkey: modelData.hotkey || ""
                    checked: control.currentTool === modelData.key
                    onClicked: {
                        control.currentTool = modelData.key
                        control.toolSelected(modelData.key)
                    }
                }
            }
        }

        // Labels under the tool row (mono caption)
        Flow {
            Layout.fillWidth: true
            spacing: 8
            visible: control.tools.length > 0
            Repeater {
                model: control.tools
                delegate: Text {
                    text: (modelData.label || "").toUpperCase()
                    color: control.currentTool === modelData.key ? "#2563EB" : "#64748B"
                    font.family: Tokens.font.mono
                    font.pixelSize: 9
                    font.letterSpacing: 1.0
                    width: 32
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Separator { Layout.fillWidth: true }

        // ---- Window / Level presets ----
        SectionLabel {
            Layout.fillWidth: true
            text: control.presetsHeader
        }

        WindowLevelPresets {
            Layout.fillWidth: true
            current: control.currentPreset
            onChanged: (key) => {
                control.currentPreset = key
                control.presetSelected(key)
            }
        }

        Item { Layout.fillHeight: true }  // push content to the top
    }
}
