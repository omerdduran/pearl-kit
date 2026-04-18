import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Tool palette — one active" }
        Row {
            spacing: 4
            P.ToolButton { label: "Pan";     hotkey: "V" }
            P.ToolButton { label: "Zoom";    hotkey: "Z"; checked: true }
            P.ToolButton { label: "Measure"; hotkey: "M" }
            P.ToolButton { label: "Notes";   hotkey: "N" }
        }

        P.PearlText { variant: "muted"; text: "Disabled tool" }
        Row {
            spacing: 4
            P.ToolButton { label: "Rotate";    hotkey: "R" }
            P.ToolButton { label: "Clip";      hotkey: "C"; checked: true }
            P.ToolButton { label: "Export";    hotkey: "E"; enabled: false }
        }
    }
}
