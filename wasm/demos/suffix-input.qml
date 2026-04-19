import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        P.PearlText { variant: "muted"; text: "Default — sans value, no suffix" }
        P.SuffixInput { width: 280; text: "Mehmet Kaya" }

        P.PearlText { variant: "muted"; text: "Mono ID with placeholder" }
        P.SuffixInput { width: 280; mono: true; text: "TR-DDS-21487" }

        P.PearlText { variant: "muted"; text: "Mono numeric with unit suffix" }
        Row {
            spacing: 14
            P.SuffixInput { mono: true; width: 130; suffix: "WL HU"; text: "400" }
            P.SuffixInput { mono: true; width: 130; suffix: "WW HU"; text: "2000" }
        }
    }
}
