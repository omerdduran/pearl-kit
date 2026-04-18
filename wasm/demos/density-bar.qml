import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        P.PearlText { variant: "muted"; text: "Low density (red zone)" }
        P.DensityBar { Layout.fillWidth: true; value: -40;  from: -200; to: 1600; unit: "HU" }

        P.PearlText { variant: "muted"; text: "Typical bone (green zone)" }
        P.DensityBar { Layout.fillWidth: true; value: 820;  from: -200; to: 1600; unit: "HU" }

        P.PearlText { variant: "muted"; text: "Dense cortex (blue zone)" }
        P.DensityBar { Layout.fillWidth: true; value: 1400; from: -200; to: 1600; unit: "HU" }
    }
}
