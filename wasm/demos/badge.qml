import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText { variant: "muted"; text: "Variants" }
        Flow {
            Layout.fillWidth: true
            spacing: 8
            P.Badge { text: "Default";     variant: "default" }
            P.Badge { text: "Secondary";   variant: "secondary" }
            P.Badge { text: "Destructive"; variant: "destructive" }
            P.Badge { text: "Outline";     variant: "outline" }
            P.Badge { text: "Ghost";       variant: "ghost" }
            P.Badge { text: "Link";        variant: "link" }
        }

        P.PearlText { variant: "muted"; text: "Real-world uses" }
        Flow {
            Layout.fillWidth: true
            spacing: 8
            P.Badge { text: "3 new" }
            P.Badge { text: "beta";      variant: "outline" }
            P.Badge { text: "v2.4.0";    variant: "secondary" }
            P.Badge { text: "failed";    variant: "destructive" }
            P.Badge { text: "streaming"; variant: "ghost" }
        }

        P.PearlText { variant: "muted"; text: "Disabled" }
        Flow {
            Layout.fillWidth: true
            spacing: 8
            P.Badge { text: "Disabled";         enabled: false }
            P.Badge { text: "Disabled outline"; variant: "outline"; enabled: false }
        }
    }
}
