import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 0

        P.AuditLogRow {
            Layout.fillWidth: true
            time: "14:32"; date: "Today"
            event: "Signed plan #2041-04 \u00B7 5/5 risks acknowledged"
            severity: "ok"
        }
        P.AuditLogRow {
            Layout.fillWidth: true
            time: "14:18"; date: "Today"
            event: "Applied AI suggestion \u00B7 implant I2 rotated \u22122\u00B0"
            severity: "info"
        }
        P.AuditLogRow {
            Layout.fillWidth: true
            time: "13:02"; date: "Today"
            event: "Plan rejected \u00B7 canal clearance below 2.0 mm"
            severity: "warn"
        }
        P.AuditLogRow {
            Layout.fillWidth: true
            time: "11:04"; date: "Today"
            event: "Logged in \u00B7 biometric \u00B7 macOS"
            severity: "info"
            showBottomHairline: false
        }
    }
}
