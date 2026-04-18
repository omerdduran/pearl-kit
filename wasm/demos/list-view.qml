import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Card variant — bordered container" }
        P.ListView {
            Layout.preferredWidth: 320
            Layout.preferredHeight: 180
            model: [
                "Implant #1 — mandibular left",
                "Implant #2 — mandibular right",
                "Implant #3 — maxillary left",
                "Implant #4 — maxillary right",
                "Planned anchor — canine"
            ]
        }

        P.PearlText { variant: "muted"; text: "Flush variant with separators" }
        Rectangle {
            Layout.preferredWidth: 320
            Layout.preferredHeight: 160
            radius: P.Tokens.radius.md
            color: P.Tokens.card
            border.color: P.Tokens.border
            border.width: 1

            P.ListView {
                anchors.fill: parent
                anchors.margins: 1
                variant: "flush"
                showSeparators: true
                model: [
                    "report.pdf",
                    "scan-2026-04-18.dcm",
                    "plan.json",
                    "notes.md",
                    "backup.zip"
                ]
            }
        }
    }
}
