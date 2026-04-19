import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 18

        P.SummaryGrid {
            Layout.fillWidth: true
            eyebrow: "YOUR SETUP"
            model: [
                { key: "NAME",       value: "Dr. Mehmet Kaya" },
                { key: "LICENSE",    value: "TR-DDS-21487" },
                { key: "BRAND",      value: "STRAUMANN BLT" },
                { key: "CANAL MIN",  value: "2.5 mm" },
                { key: "COMPLIANCE", value: "HIPAA/KVKK ON", valueColor: "#047857" },
                { key: "REGION",     value: "EU-CENTRAL" }
            ]
        }

        P.SummaryGrid {
            Layout.fillWidth: true
            eyebrow: "REVIEW \u00B7 WARN"
            model: [
                { key: "CANAL", value: "1.8 mm",      valueColor: "#B45309" },
                { key: "SINUS", value: "0.6 mm",      valueColor: "#B45309" },
                { key: "BRAND", value: "MIS V3" },
                { key: "BONE",  value: "D3" }
            ]
        }
    }
}
