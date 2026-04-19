import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 18

        P.PearlText { variant: "muted"; text: "Default size (22)" }
        Row {
            spacing: 12
            P.ColorDot { color: "#3B82F6" }
            P.ColorDot { color: "#F87171" }
            P.ColorDot { color: "#34D399" }
            P.ColorDot { color: "#F59E0B" }
            P.ColorDot { color: "#A855F7" }
            P.ColorDot { color: "#1A202C" }
        }

        P.PearlText { variant: "muted"; text: "Larger (size: 28)" }
        Row {
            spacing: 14
            P.ColorDot { color: "#3B82F6"; size: 28 }
            P.ColorDot { color: "#F87171"; size: 28 }
            P.ColorDot { color: "#34D399"; size: 28 }
        }
    }
}
