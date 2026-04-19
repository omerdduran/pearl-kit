import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        P.PearlText { variant: "muted"; text: "Default — 2 implant markers + sample chip" }
        P.SampleCasePreview {
            Layout.fillWidth: true
            topRightLabel: "142 / 512"
        }

        P.PearlText { variant: "muted"; text: "Three markers, taller hero" }
        P.SampleCasePreview {
            Layout.fillWidth: true
            topLeftLabel: "DEMO \u00B7 MAXILLA"
            topRightLabel: "248 / 512"
            markerCount: 3
            previewHeight: 180
        }
    }
}
