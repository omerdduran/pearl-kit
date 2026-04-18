import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.TopMetaStrip {
            Layout.fillWidth: true
            leftText: "SCAN · A-0042"
            rightText: "2026-04-18 · 14:32"
        }

        P.TopMetaStrip {
            Layout.fillWidth: true
            leftText: "ENV · STAGING"
            rightText: "BUILD 8f3c"
        }

        P.TopMetaStrip {
            Layout.fillWidth: true
            leftText: "NO ACTIVE SESSION"
            rightText: ""
        }
    }
}
