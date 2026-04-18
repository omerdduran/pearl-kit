import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "All four states" }
        Column {
            spacing: 8
            P.SaveIndicator { state: "saved";   text: "Saved 2 min ago" }
            P.SaveIndicator { state: "saving";  text: "Saving…" }
            P.SaveIndicator { state: "error";   text: "Save failed — retry" }
            P.SaveIndicator { state: "offline"; text: "Offline — will sync when online" }
        }
    }
}
