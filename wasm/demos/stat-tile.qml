import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Three sizes · success tone" }
        Row {
            spacing: 16
            P.StatTile { eyebrow: "BONE HEIGHT"; value: "14.2"; subtitle: "mm"; tone: "success"; size: "sm" }
            P.StatTile { eyebrow: "BONE HEIGHT"; value: "14.2"; subtitle: "mm"; tone: "success"; size: "md" }
            P.StatTile { eyebrow: "BONE HEIGHT"; value: "14.2"; subtitle: "mm"; tone: "success"; size: "lg" }
        }

        P.PearlText { variant: "muted"; text: "Three tones · md" }
        Row {
            spacing: 16
            P.StatTile { eyebrow: "HU AVG";    value: "248";  subtitle: "density"; tone: "warn";    size: "md" }
            P.StatTile { eyebrow: "CLEARANCE"; value: "3.2";  subtitle: "mm";      tone: "success"; size: "md" }
            P.StatTile { eyebrow: "PLACED";    value: "3 / 4"; subtitle: "implants"; tone: "neutral"; size: "md" }
        }
    }
}
