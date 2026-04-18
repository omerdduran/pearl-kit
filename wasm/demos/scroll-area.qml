import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Auto-hide vertical scroll (hover to reveal thumb)" }
        P.ScrollArea {
            Layout.fillWidth: true
            Layout.preferredHeight: 160
            Rectangle {
                width: 380
                height: 520
                color: P.Tokens.card
                border.color: P.Tokens.border
                border.width: 1
                radius: P.Tokens.radius.md
                Column {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    Repeater {
                        model: 16
                        P.PearlText { text: "Scrollable row #" + (index + 1) }
                    }
                }
            }
        }

        P.PearlText { variant: "muted"; text: "Always-visible scrollbars (autoHide: false)" }
        P.ScrollArea {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            autoHide: false
            Rectangle {
                width: 900
                height: 220
                color: P.Tokens.muted
                Column {
                    anchors.centerIn: parent
                    spacing: 4
                    P.PearlText { variant: "heading"; text: "Wide + tall content" }
                    P.PearlText { variant: "muted"; text: "Both scrollbars are persistent." }
                }
            }
        }
    }
}
