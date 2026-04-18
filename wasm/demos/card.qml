import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.Card {
            Layout.preferredWidth: 420
            P.PearlText { variant: "heading"; text: "Plan summary" }
            P.PearlText { variant: "muted"; text: "Default card — border + card background, no accent." }
        }
        P.Card {
            Layout.preferredWidth: 420
            variant: "destructive"
            P.PearlText { variant: "heading"; text: "Collision detected" }
            P.PearlText {
                variant: "muted"
                width: 372
                wrapMode: Text.WordWrap
                text: "Implant #3 overlaps the mandibular nerve canal. Reposition before export."
            }
        }
        P.Card {
            Layout.preferredWidth: 420
            variant: "warning"
            P.PearlText { variant: "heading"; text: "Low bone density" }
            P.PearlText { variant: "muted"; text: "Region shows HU < 300. Consider alternate drilling protocol." }
        }
        P.Card {
            Layout.preferredWidth: 420
            variant: "success"
            P.PearlText { variant: "heading"; text: "Export complete" }
            P.PearlText { variant: "muted"; text: "All 4 implants saved to plan.json." }
        }
        P.Card {
            Layout.preferredWidth: 420
            variant: "info"
            P.PearlText { variant: "heading"; text: "Beta feature" }
            P.PearlText { variant: "muted"; text: "Auto-alignment is experimental. Review before approving." }
        }
    }
}
