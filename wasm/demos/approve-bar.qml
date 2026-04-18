import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Not yet acknowledged (0/5)" }
        P.ApproveBar {
            Layout.fillWidth: true
            countLabel: "CHECKLIST"
            acknowledged: 0
            total: 5
            signed: false
        }

        P.PearlText { variant: "muted"; text: "Partially acknowledged (3/5)" }
        P.ApproveBar {
            Layout.fillWidth: true
            countLabel: "CHECKLIST"
            acknowledged: 3
            total: 5
            signed: false
        }

        P.PearlText { variant: "muted"; text: "All acknowledged — ready to sign" }
        P.ApproveBar {
            Layout.fillWidth: true
            countLabel: "CHECKLIST"
            acknowledged: 5
            total: 5
            signed: false
        }

        P.PearlText { variant: "muted"; text: "Signed (green)" }
        P.ApproveBar {
            Layout.fillWidth: true
            countLabel: "CHECKLIST"
            acknowledged: 5
            total: 5
            signed: true
        }
    }
}
