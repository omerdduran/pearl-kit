import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        Layout.maximumWidth: 560

        P.AISuggestionCard {
            Layout.fillWidth: true
            title: "AI suggests"
            modelTag: "DALI-v2"
            body: "Consider increasing the depth of implant #15 by 2.0 mm to improve primary stability in D3 bone."
            actionLabel: "Apply"
        }

        P.AISuggestionCard {
            Layout.fillWidth: true
            title: "Pattern detected"
            modelTag: "DALI-v2"
            body: "Angulation on #14 and #15 diverges by 12°. Parallelism would simplify prosthetic workflow."
            actionLabel: "Align both"
        }
    }
}
