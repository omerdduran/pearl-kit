import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 0

        P.SettingsRow {
            Layout.fillWidth: true
            label: "Full name"
            hint: "Shown on reports and the audit trail."
            P.Input { placeholderText: "Dr. Mehmet Kaya"; width: 320 }
        }
        P.SettingsRow {
            Layout.fillWidth: true
            label: "License number"
            P.SuffixInput { mono: true; text: "TR-DDS-21487"; width: 240 }
        }
        P.SettingsRow {
            Layout.fillWidth: true
            label: "Auto-segment on case open"
            P.StatusToggle { checked: true }
        }
        P.SettingsRow {
            Layout.fillWidth: true
            label: "Canal minimum clearance"
            P.ReadoutSlider { value: 2.5; from: 1.0; to: 4.0; stepSize: 0.1; unit: "mm" }
        }
    }
}
