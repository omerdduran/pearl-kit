import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 24
        Layout.maximumWidth: 480

        P.PearlText { variant: "muted"; text: "Angulation ±15°" }
        P.BipolarSlider { Layout.fillWidth: true; value: -8.5; range: 15; unit: "°" }

        P.PearlText { variant: "muted"; text: "Centered (0)" }
        P.BipolarSlider { Layout.fillWidth: true; value: 0;    range: 30; unit: "°" }

        P.PearlText { variant: "muted"; text: "At positive limit" }
        P.BipolarSlider { Layout.fillWidth: true; value: 30;   range: 30; unit: "°" }
    }
}
