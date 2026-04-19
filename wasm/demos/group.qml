import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        P.Group {
            Layout.fillWidth: true
            title: "IMPLANT BRANDS"

            ColumnLayout {
                anchors.top: parent.top
                anchors.topMargin: 36
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 0

                P.SettingsRow {
                    Layout.fillWidth: true
                    label: "Primary brand"
                    P.PearlText { variant: "muted"; text: "Straumann \u00B7 BLT" }
                }
                P.SettingsRow {
                    Layout.fillWidth: true
                    label: "Backup brand"
                    P.PearlText { variant: "muted"; text: "Nobel Biocare \u00B7 Active" }
                }
            }
        }
    }
}
