import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Splash-screen mark (150 px default)" }
        Row {
            spacing: 24
            P.ScannerMark { diameter: 96 }
            P.ScannerMark { }
            P.ScannerMark { diameter: 200 }
        }

        P.PearlText { variant: "muted"; text: "Custom sweep color" }
        Row {
            spacing: 24
            P.ScannerMark { diameter: 120; sweepColor: "#F59E0B" }
            P.ScannerMark { diameter: 120; sweepColor: "#10B981" }
            P.ScannerMark { diameter: 120; sweepColor: "#EF4444" }
        }
    }
}
