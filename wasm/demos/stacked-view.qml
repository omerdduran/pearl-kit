import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                spacing: 4
                Repeater {
                    model: ["Home", "Settings", "About"]
                    delegate: P.Button {
                        Layout.preferredWidth: 120
                        text: modelData
                        variant: stackIndex.currentIndex === index ? "secondary" : "ghost"
                        onClicked: stackIndex.currentIndex = index
                    }
                }
            }

            P.StackedView {
                id: stackIndex
                animated: true
                Layout.fillWidth: true
                Layout.preferredHeight: 140

                Rectangle {
                    radius: P.Tokens.radius.lg
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    P.PearlText { anchors.centerIn: parent; variant: "heading"; text: "Home pane" }
                }
                Rectangle {
                    radius: P.Tokens.radius.lg
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    P.PearlText { anchors.centerIn: parent; variant: "heading"; text: "Settings pane" }
                }
                Rectangle {
                    radius: P.Tokens.radius.lg
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    P.PearlText { anchors.centerIn: parent; variant: "heading"; text: "About pane" }
                }
            }
        }
    }
}
