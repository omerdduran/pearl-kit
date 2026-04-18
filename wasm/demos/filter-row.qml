import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    RowLayout {
        anchors.fill: parent
        spacing: 24

        Rectangle {
            Layout.preferredWidth: 240
            Layout.preferredHeight: 260
            color: P.Tokens.muted
            radius: P.Tokens.radius.lg
            border.color: P.Tokens.border
            border.width: 1

            ColumnLayout {
                id: filterList
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                property var labels: ["All cases", "Flagged", "Awaiting review", "Archive"]
                property var counts: [42, 3, 12, 128]
                property int current: 0

                Repeater {
                    model: 4
                    delegate: P.FilterRow {
                        Layout.fillWidth: true
                        label: filterList.labels[index]
                        count: filterList.counts[index]
                        active: index === filterList.current
                        onClicked: filterList.current = index
                    }
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            spacing: 8
            P.PearlText { variant: "heading"; text: "Filter sidebar" }
            P.PearlText { variant: "muted"; text: "Active: " + filterList.labels[filterList.current] }
            P.PearlText {
                variant: "muted"
                wrapMode: Text.WordWrap
                Layout.preferredWidth: 320
                text: "Click a row to change selection. The 2 px left strip marks the active filter."
            }
        }
    }
}
