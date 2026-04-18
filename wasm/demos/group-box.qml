import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.GroupBox {
            Layout.fillWidth: true
            title: "Notifications"
            description: "Choose how you'd like to be notified about plan progress."

            P.CheckBox { id: cbEmail; checked: true }
            Row {
                spacing: 8
                P.CheckBox { id: cbSms }
                P.PearlText {
                    text: "Text messages"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        P.GroupBox {
            Layout.fillWidth: true
            title: "Appearance"
            description: "Theme and density preferences."
            collapsible: true
            expanded: true

            Row {
                spacing: 12
                P.PearlText {
                    text: "Compact density"
                    anchors.verticalCenter: parent.verticalCenter
                }
                P.Toggle { }
            }
            P.Select {
                width: 220
                model: ["Light", "Dark", "DarkBlue"]
            }
        }
    }
}
