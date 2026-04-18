import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.SectionLabel { text: "ANALYSIS RESULTS" }
        P.PearlText { variant: "body"; text: "Three implants placed. Canal collision cleared." }

        P.SectionLabel { text: "RECENT CASES" }
        Column {
            spacing: 4
            P.PearlText { text: "A-0042 — Foster" }
            P.PearlText { text: "A-0041 — Nakamura" }
            P.PearlText { text: "A-0040 — Demir" }
        }

        P.SectionLabel { text: "SYSTEM STATUS" }
        P.PearlText { variant: "muted"; text: "All services nominal." }
    }
}
