import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        P.SampleCaseCard {
            Layout.fillWidth: true
            title: "Demo \u00B7 Y\u0131lmaz, Ay\u015fe"
            caseId: "#0000-00"
            metaText: "MANDIBLE \u00B7 TOOTH 36/37 \u00B7 2 IMPLANTS \u00B7 STRAUMANN BLT"
            previewTopRightLabel: "142 / 512"
            metrics: [
                { key: "SAFETY",  value: "5 / 5 OK", valueColor: "#047857" },
                { key: "CANAL",   value: "3.2 mm" },
                { key: "AI TOUR", value: "Enabled",  valueColor: "#2563EB" }
            ]
        }
    }
}
