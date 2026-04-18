import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 24

        P.EditorialHero {
            Layout.fillWidth: true
            eyebrow: "CLINICAL OVERVIEW"
            headline: "Planning & Execution"
            subLine: "Precision guidance from diagnosis to placement."
        }
    }
}
