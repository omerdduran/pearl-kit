import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.InfoCard {
            Layout.fillWidth: true
            tone: "info"
            Text {
                text: "Auto-alignment is experimental. Review results before approving the plan."
                color: P.Tokens.foreground
                font.family: P.Tokens.font.ui
                font.pixelSize: P.Tokens.font.size.sm
                wrapMode: Text.WordWrap
                width: parent.width - 24
            }
        }

        P.InfoCard {
            Layout.fillWidth: true
            tone: "warning"
            Text {
                text: "Low bone density detected in the mandibular left region (HU < 300)."
                color: P.Tokens.foreground
                font.family: P.Tokens.font.ui
                font.pixelSize: P.Tokens.font.size.sm
                wrapMode: Text.WordWrap
                width: parent.width - 24
            }
        }

        P.InfoCard {
            Layout.fillWidth: true
            tone: "success"
            Text {
                text: "Plan saved. 4 implants exported to plan.json."
                color: P.Tokens.foreground
                font.family: P.Tokens.font.ui
                font.pixelSize: P.Tokens.font.size.sm
                wrapMode: Text.WordWrap
                width: parent.width - 24
            }
        }

        P.InfoCard {
            Layout.fillWidth: true
            tone: "neutral"
            Text {
                text: "Tip: hold ⌥ while dragging to nudge an implant without rotation."
                color: P.Tokens.foreground
                font.family: P.Tokens.font.ui
                font.pixelSize: P.Tokens.font.size.sm
                wrapMode: Text.WordWrap
                width: parent.width - 24
            }
        }
    }
}
