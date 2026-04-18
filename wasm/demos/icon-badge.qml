import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Gradient · four tones" }
        Row {
            spacing: 12
            P.IconBadge { tone: "info";    gradient: true; size: 24 }
            P.IconBadge { tone: "warn";    gradient: true; size: 24 }
            P.IconBadge { tone: "success"; gradient: true; size: 24 }
            P.IconBadge { tone: "primary"; gradient: true; size: 24 }
        }

        P.PearlText { variant: "muted"; text: "Solid · four tones" }
        Row {
            spacing: 12
            P.IconBadge { tone: "info";    gradient: false; size: 24 }
            P.IconBadge { tone: "warn";    gradient: false; size: 24 }
            P.IconBadge { tone: "success"; gradient: false; size: 24 }
            P.IconBadge { tone: "primary"; gradient: false; size: 24 }
        }

        P.PearlText { variant: "muted"; text: "Size scale (primary)" }
        Row {
            spacing: 12
            P.IconBadge { tone: "primary"; size: 16; iconSize: 10 }
            P.IconBadge { tone: "primary"; size: 20 }
            P.IconBadge { tone: "primary"; size: 28; iconSize: 16 }
            P.IconBadge { tone: "primary"; size: 40; iconSize: 24 }
        }
    }
}
