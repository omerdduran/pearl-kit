import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Variants" }
        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.Button { text: "Default";     variant: "default" }
            P.Button { text: "Destructive"; variant: "destructive" }
            P.Button { text: "Outline";     variant: "outline" }
            P.Button { text: "Secondary";   variant: "secondary" }
            P.Button { text: "Ghost";       variant: "ghost" }
            P.Button { text: "Link";        variant: "link" }
        }

        P.PearlText { variant: "muted"; text: "Sizes" }
        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.Button { text: "xs"; size: "xs" }
            P.Button { text: "sm"; size: "sm" }
            P.Button { text: "Default"; size: "default" }
            P.Button { text: "lg"; size: "lg" }
            P.Button { size: "icon" }
        }

        P.PearlText { variant: "muted"; text: "Disabled" }
        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.Button { text: "Disabled default"; variant: "default"; enabled: false }
            P.Button { text: "Disabled dest";    variant: "destructive"; enabled: false }
            P.Button { text: "Disabled outline"; variant: "outline"; enabled: false }
        }
    }
}
