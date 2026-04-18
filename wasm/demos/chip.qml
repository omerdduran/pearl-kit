import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Soft (tinted fill)" }
        Flow {
            Layout.fillWidth: true
            spacing: 8
            P.Chip { text: "Apply filter"; variant: "soft" }
            P.Chip { text: "Export plan";  variant: "soft" }
            P.Chip { text: "Add implant";  variant: "soft" }
        }

        P.PearlText { variant: "muted"; text: "Outline (ink border)" }
        Flow {
            Layout.fillWidth: true
            spacing: 8
            P.Chip { text: "Review"; variant: "outline" }
            P.Chip { text: "Undo";   variant: "outline" }
            P.Chip { text: "Reset";  variant: "outline" }
        }
    }
}
