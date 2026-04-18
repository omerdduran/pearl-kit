import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "With back affordance" }
        P.PatientStrip {
            Layout.fillWidth: true
            segments: [{ label: "Cases" }, { label: "#2847", current: true }]
            name: "Case #2847"
            meta: "MIS-D6 · Bone-level · 4 implants"
        }

        P.PearlText { variant: "muted"; text: "No back button" }
        P.PatientStrip {
            Layout.fillWidth: true
            showBackButton: false
            segments: [{ label: "Patients" }, { label: "A-0042", current: true }]
            name: "Jane Foster"
            meta: "40 F · 2026-04-18"
        }
    }
}
