import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 6
        Layout.maximumWidth: 420

        P.SubjectRow { Layout.fillWidth: true; identifier: "I1"; title: "Implant #14"; caption: "D4.1 × 12.0";  status: "ok";   selected: false }
        P.SubjectRow { Layout.fillWidth: true; identifier: "I2"; title: "Implant #15"; caption: "D3.8 × 10.0";  status: "warn"; selected: true }
        P.SubjectRow { Layout.fillWidth: true; identifier: "I3"; title: "Implant #17"; caption: "D4.1 × 12.0";  status: "warn"; selected: false }
        P.SubjectRow { Layout.fillWidth: true; identifier: "I4"; title: "Implant #18"; caption: "D5.0 × 10.0";  status: "ok";   selected: false }
    }
}
