// ImplantParameterPanel — the right-rail parameter block for the Plan tab.
//
// Standardised composition of the primitives that make up per-implant
// editing: diameter slider, length 6-button grid, angulation bipolar
// slider, bone density read-out, and a list of safety-distance rows
// (inferior alveolar nerve, maxillary sinus, adjacent roots, buccal
// cortex — the consumer supplies the list).
//
// All values flow in via properties; edits emit signals. The consumer
// (DALI's `PlanningBridge`) maps these to `ImplantController` calls and
// pushes updated values back via bindings. No local state here.

import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Rectangle {
    id: control

    // ---- Parameters ----
    property real diameter: 4.1
    property real diameterMin: 3.0
    property real diameterMax: 6.0
    property real diameterStep: 0.1

    property real length: 10.0
    //: Discrete length options (mm). Consumer supplies the catalog-matching set.
    property var lengthOptions: [6.0, 8.0, 10.0, 11.5, 13.0, 14.0]

    property real angulation: 0.0
    property real angulationRange: 15.0

    property real boneDensityHU: 800
    property real boneDensityFrom: -500
    property real boneDensityTo: 2000

    //: Per-structure safety rows. Each: { label, value, min, unit }.
    property var safetyRows: []

    // ---- Section headers (i18n'd by consumer) ----
    property string headerDiameter: "Diameter"
    property string headerLength: "Length"
    property string headerAngulation: "Angulation"
    property string headerBoneDensity: "Bone density"
    property string headerSafety: "Safety distances"

    // ---- Signals ----
    signal diameterMoved(real value)
    signal lengthSelected(real value)
    signal angulationMoved(real value)

    implicitWidth: 320
    implicitHeight: _col.implicitHeight + 32

    color: "#FFFFFF"
    border.color: "#E2E8F0"
    border.width: 1
    radius: 6

    ColumnLayout {
        id: _col
        anchors.fill: parent
        anchors.margins: 16
        spacing: 14

        // ---- Diameter ----
        SectionLabel { Layout.fillWidth: true; text: control.headerDiameter.toUpperCase() }
        ReadoutSlider {
            Layout.fillWidth: true
            value: control.diameter
            from: control.diameterMin
            to: control.diameterMax
            stepSize: control.diameterStep
            unit: "mm"
            onMoved: (v) => control.diameterMoved(v)
        }

        // ---- Length (6-button grid) ----
        SectionLabel { Layout.fillWidth: true; text: control.headerLength.toUpperCase() }
        Flow {
            Layout.fillWidth: true
            spacing: 6
            Repeater {
                model: control.lengthOptions
                delegate: Rectangle {
                    readonly property bool _active: Math.abs(modelData - control.length) < 1e-3
                    width: 44
                    height: 28
                    radius: 4
                    color: _active ? "#2563EB" : "#F8FAFC"
                    border.color: _active ? "#2563EB" : "#E2E8F0"
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
                    Text {
                        anchors.centerIn: parent
                        text: modelData.toFixed(modelData % 1 === 0 ? 0 : 1)
                        color: parent._active ? "#FFFFFF" : "#1A202C"
                        font.family: Tokens.font.mono
                        font.pixelSize: 11
                        font.letterSpacing: 0.4
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            control.length = modelData
                            control.lengthSelected(modelData)
                        }
                    }
                }
            }
        }

        // ---- Angulation ----
        SectionLabel { Layout.fillWidth: true; text: control.headerAngulation.toUpperCase() }
        BipolarSlider {
            Layout.fillWidth: true
            value: control.angulation
            range: control.angulationRange
            onMoved: (v) => control.angulationMoved(v)
        }

        // ---- Bone density ----
        SectionLabel { Layout.fillWidth: true; text: control.headerBoneDensity.toUpperCase() }
        DensityBar {
            Layout.fillWidth: true
            value: control.boneDensityHU
            from: control.boneDensityFrom
            to: control.boneDensityTo
            unit: "HU"
        }

        // ---- Safety distances ----
        SectionLabel {
            Layout.fillWidth: true
            text: control.headerSafety.toUpperCase()
            visible: control.safetyRows.length > 0
        }
        Repeater {
            model: control.safetyRows
            delegate: SafetyRow {
                Layout.fillWidth: true
                label: modelData.label || ""
                value: modelData.value || 0
                min:   modelData.min   || 1.0
                unit:  modelData.unit  || "mm"
            }
        }
    }
}
