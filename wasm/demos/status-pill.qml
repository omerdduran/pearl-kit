import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "All four states" }
        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.StatusPill { text: "Ready";      state: "ready" }
            P.StatusPill { text: "Processing"; state: "processing" }
            P.StatusPill { text: "Reviewed";   state: "reviewed" }
            P.StatusPill { text: "Neutral";    state: "neutral" }
        }

        P.PearlText { variant: "muted"; text: "Real-world labels" }
        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.StatusPill { text: "Case 042 · scan ingested";   state: "ready" }
            P.StatusPill { text: "AI analysis queued";         state: "processing" }
            P.StatusPill { text: "Approved by Dr. Foster";     state: "reviewed" }
            P.StatusPill { text: "Archived";                   state: "neutral" }
        }
    }
}
