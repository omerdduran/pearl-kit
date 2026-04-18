import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 8
        Layout.maximumWidth: 520

        P.ChecklistItem {
            Layout.fillWidth: true
            severity: "warn"
            text: "Measure IAN clearance"
            body: "Distance from implant to inferior alveolar nerve must be ≥ 2.0 mm on all sections."
            checked: false
        }
        P.ChecklistItem {
            Layout.fillWidth: true
            severity: "info"
            text: "Confirm drill sequence"
            body: "Surgical drill protocol reviewed for D3 bone density."
            checked: true
        }
        P.ChecklistItem {
            Layout.fillWidth: true
            severity: "note"
            text: "Torque target documented"
            body: "Final insertion torque recorded in surgical notes."
            checked: false
        }
    }
}
