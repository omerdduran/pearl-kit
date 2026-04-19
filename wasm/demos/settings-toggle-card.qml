import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 14

        P.SettingsToggleCard {
            Layout.fillWidth: true
            title: "HIPAA / KVKK compliance mode"
            description: "All DICOM data remains on the workstation. Only anonymized summaries leave the device for AI reasoning."
            badgeText: "RECOMMENDED"
            checked: true
            highlighted: true
        }

        P.SettingsToggleCard {
            Layout.fillWidth: true
            title: "Send volumes to cloud for heavy inference"
            description: "Disabled while compliance mode is on. All inference runs locally on your GPU."
            checked: false
            locked: true
        }

        P.SettingsToggleCard {
            Layout.fillWidth: true
            title: "Allow anonymous telemetry"
            description: "Crash reports and feature usage. No patient data leaves the workstation."
            checked: true
        }
    }
}
