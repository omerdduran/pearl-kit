import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        RowLayout {
            spacing: 12
            P.PearlText { variant: "muted"; text: "Default"; Layout.preferredWidth: 110 }
            P.TabBar {
                Layout.preferredWidth: 360
                P.TabButton { text: "Overview" }
                P.TabButton { text: "Analytics" }
                P.TabButton { text: "Reports" }
                P.TabButton { text: "Notifications" }
            }
        }

        RowLayout {
            spacing: 12
            P.PearlText { variant: "muted"; text: "Line"; Layout.preferredWidth: 110 }
            P.TabBar {
                variant: "line"
                Layout.preferredWidth: 360
                P.TabButton { text: "Code" }
                P.TabButton { text: "Issues" }
                P.TabButton { text: "Pull requests" }
                P.TabButton { text: "Wiki" }
            }
        }

        RowLayout {
            spacing: 12
            P.PearlText { variant: "muted"; text: "Closable"; Layout.preferredWidth: 110 }
            P.TabBar {
                variant: "line"
                expanding: false
                Layout.preferredWidth: 500
                P.TabButton { text: "report.pdf"; closable: true }
                P.TabButton { text: "untitled-1.txt"; closable: true }
                P.TabButton { text: "implant-plan.dali"; closable: true }
            }
        }

        RowLayout {
            spacing: 12
            P.PearlText { variant: "muted"; text: "Disabled"; Layout.preferredWidth: 110 }
            P.TabBar {
                enabled: false
                Layout.preferredWidth: 360
                P.TabButton { text: "One" }
                P.TabButton { text: "Two" }
                P.TabButton { text: "Three" }
            }
        }
    }
}
