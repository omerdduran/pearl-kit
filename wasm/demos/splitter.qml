import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.Splitter {
            Layout.fillWidth: true
            Layout.preferredHeight: 160

            Rectangle {
                SplitView.preferredWidth: 180
                SplitView.minimumWidth: 80
                color: P.Tokens.muted
                P.PearlText { anchors.centerIn: parent; text: "Sidebar"; variant: "muted" }
            }
            Rectangle {
                SplitView.fillWidth: true
                color: P.Tokens.card
                P.PearlText { anchors.centerIn: parent; text: "Editor (fill)"; variant: "body" }
            }
            Rectangle {
                SplitView.preferredWidth: 140
                color: P.Tokens.muted
                P.PearlText { anchors.centerIn: parent; text: "Outline"; variant: "muted" }
            }
        }

        P.Splitter {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            orientation: Qt.Vertical
            withHandle: true

            Rectangle {
                SplitView.preferredHeight: 100
                color: P.Tokens.card
                P.PearlText { anchors.centerIn: parent; text: "Top pane"; variant: "body" }
            }
            Rectangle {
                SplitView.fillHeight: true
                color: P.Tokens.muted
                P.PearlText { anchors.centerIn: parent; text: "Bottom (fill)"; variant: "muted" }
            }
        }
    }
}
