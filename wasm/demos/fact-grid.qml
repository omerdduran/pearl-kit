import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 18

        P.PearlText { variant: "muted"; text: "2-column (default)" }
        P.FactGrid {
            Layout.fillWidth: true
            model: [
                { key: "5 MIN",  value: "Typical setup",        sub: "Skip anything optional" },
                { key: "LOCAL",  value: "Data stays local",     sub: "HIPAA / KVKK default" },
                { key: "1,247",  value: "Clinicians onboarded", sub: "23 countries" },
                { key: "3.2.1",  value: "Clinical build",       sub: "License valid to 2027-04" }
            ]
        }

        P.PearlText { variant: "muted"; text: "3-column" }
        P.FactGrid {
            Layout.fillWidth: true
            columns: 3
            model: [
                { key: "ACCURACY", value: "0.3 mm",  sub: "Voxel resolution" },
                { key: "LATENCY",  value: "180 ms",  sub: "AI suggestion" },
                { key: "UPTIME",   value: "99.97%",  sub: "Last 90 days" }
            ]
        }
    }
}
