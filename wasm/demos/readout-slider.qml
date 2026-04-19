import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 18

        P.PearlText { variant: "muted"; text: "Decimal mm clearance" }
        P.ReadoutSlider {
            Layout.fillWidth: true
            value: 2.5; from: 1.0; to: 4.0; stepSize: 0.1; unit: "mm"
        }

        P.PearlText { variant: "muted"; text: "Whole-number GB cache" }
        P.ReadoutSlider {
            Layout.fillWidth: true
            value: 64; from: 8; to: 128; stepSize: 8; unit: "GB"
        }

        P.PearlText { variant: "muted"; text: "Percent (no unit)" }
        P.ReadoutSlider {
            Layout.fillWidth: true
            value: 80; from: 0; to: 100; stepSize: 5; unit: "%"
        }
    }
}
