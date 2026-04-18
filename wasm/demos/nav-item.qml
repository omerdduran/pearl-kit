import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    RowLayout {
        anchors.fill: parent
        spacing: 24

        Rectangle {
            Layout.preferredWidth: 220
            Layout.preferredHeight: 13 * 32 + 12 * 4 + 24
            color: P.Tokens.muted
            radius: P.Tokens.radius.lg
            border.color: P.Tokens.border
            border.width: 1

            ColumnLayout {
                id: settingsNav
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                property int currentTab: 0
                property var labels: [
                    "General", "Appearance", "Editor", "Files",
                    "Network", "Privacy", "Updates", "Accounts",
                    "Shortcuts", "Extensions", "Integrations", "Telemetry",
                    "About"
                ]

                Repeater {
                    model: settingsNav.labels
                    delegate: P.NavItem {
                        Layout.fillWidth: true
                        text: modelData
                        active: index === settingsNav.currentTab
                        onClicked: settingsNav.currentTab = index
                    }
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            spacing: 8
            P.PearlText { variant: "heading"; text: "Selected" }
            P.PearlText { variant: "muted"; text: settingsNav.labels[settingsNav.currentTab] }

            P.PearlText { variant: "muted"; text: "Sizes: sm / default / lg" }
            P.NavItem { Layout.preferredWidth: 200; size: "sm"; text: "Compact row" }
            P.NavItem { Layout.preferredWidth: 200; text: "Standard row" }
            P.NavItem { Layout.preferredWidth: 200; size: "lg"; text: "Roomy row" }
        }
    }
}
