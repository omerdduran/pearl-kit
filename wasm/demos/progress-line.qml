import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText { variant: "muted"; text: "Quarter steps" }
        P.ProgressLine { Layout.preferredWidth: 360; value: 0 }
        P.ProgressLine { Layout.preferredWidth: 360; value: 25 }
        P.ProgressLine { Layout.preferredWidth: 360; value: 50 }
        P.ProgressLine { Layout.preferredWidth: 360; value: 75 }
        P.ProgressLine { Layout.preferredWidth: 360; value: 100 }

        P.PearlText { variant: "muted"; text: "Tinted variants" }
        P.ProgressLine {
            Layout.preferredWidth: 360; value: 62
            fillStart: "#16A34A"; fillEnd: "#22C55E"
        }
        P.ProgressLine {
            Layout.preferredWidth: 360; value: 42
            fillStart: "#F59E0B"; fillEnd: "#FCD34D"
        }
        P.ProgressLine {
            Layout.preferredWidth: 360; value: 88
            fillStart: "#DC2626"; fillEnd: "#EF4444"
        }
    }
}
