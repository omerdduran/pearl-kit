// Source: design_handoff_planning_workspace/src/report-tab.jsx:419-459
// Balanced-variant implant card: header row + 4-column parameter grid +
// safety strip. Generic compound — consumer provides `parameters` and
// `metrics` arrays.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string identifier: ""
    property string tooth: ""
    property string brand: ""
    property string status: "ok"         // "ok" | "warn"

    // [{ key: "Diameter", value: "4.1" }]
    property var parameters: []

    // [{ key: "IAN", value: "3.2 mm", tone: "ok"|"warn"|"neutral" }]
    property var metrics: []

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui
    property string fontFamilySerif: "Times New Roman"

    readonly property color _statusColor: status === "warn" ? "#B45309" : "#047857"
    readonly property string _statusLabel: status === "warn" ? "\u26A0 REVIEW" : "\u2713 OK"

    implicitWidth: 280
    implicitHeight: _col.implicitHeight + 32

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: "#FFFFFF"
        border.color: "#E2E8F0"
        border.width: 1
    }

    ColumnLayout {
        id: _col
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: (control.identifier !== "" ? control.identifier : "") +
                          (control.tooth !== "" ? ((control.identifier !== "" ? " \u00B7 " : "") + control.tooth) : "")
                    color: "#6B7280"
                    font.family: control.fontFamilyMono
                    font.pixelSize: 10
                    font.letterSpacing: 0.8
                    renderType: Text.NativeRendering
                    antialiasing: true
                }

                Text {
                    text: control.brand
                    color: "#1A202C"
                    font.family: control.fontFamilySerif
                    font.pixelSize: 18
                    renderType: Text.NativeRendering
                    antialiasing: true
                }
            }

            Text {
                text: control._statusLabel
                color: control._statusColor
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                font.letterSpacing: 1.0
                font.weight: Font.DemiBold
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }

        // 4-column parameter grid
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            columnSpacing: 10
            rowSpacing: 0

            Repeater {
                model: control.parameters

                delegate: ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: modelData && modelData.key ? String(modelData.key) : ""
                        color: "#9CA3AF"
                        font.family: control.fontFamilyMono
                        font.pixelSize: 9
                        font.letterSpacing: 1.0
                        font.capitalization: Font.AllUppercase
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }

                    Text {
                        text: modelData && modelData.value !== undefined ? String(modelData.value) : ""
                        color: "#1A202C"
                        font.family: control.fontFamilyMono
                        font.pixelSize: 14
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                }
            }
        }

        // Safety strip
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#F1F5F9"
            visible: control.metrics && control.metrics.length > 0
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 14
            visible: control.metrics && control.metrics.length > 0

            Repeater {
                model: control.metrics

                delegate: RowLayout {
                    spacing: 6

                    Text {
                        text: (modelData && modelData.key ? String(modelData.key) : "") + ":"
                        color: "#6B7280"
                        font.family: control.fontFamilyUI
                        font.pixelSize: 11
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }

                    Text {
                        text: modelData && modelData.value !== undefined ? String(modelData.value) : ""
                        color: {
                            const t = modelData && modelData.tone ? modelData.tone : "neutral"
                            if (t === "warn")    return "#B45309"
                            if (t === "ok")      return "#047857"
                            if (t === "success") return "#047857"
                            return "#1A202C"
                        }
                        font.family: control.fontFamilyMono
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                }
            }
        }
    }
}
