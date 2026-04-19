import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 32

        P.SettingsHeader {
            Layout.fillWidth: true
            eyebrow: "02 \u00B7 CLINICAL"
            title: "Clinical preferences"
            description: "Defaults applied to every new case. Individual plans can override any value."
        }

        P.SettingsHeader {
            Layout.fillWidth: true
            eyebrow: "04 \u00B7 PRIVACY"
            title: "Data \u0026 compliance"
            description: "How DALI handles patient data. Defaults keep everything on-device."
        }
    }
}
