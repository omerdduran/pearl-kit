import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "All overlays on (default)" }
        P.Render3D {
            Layout.preferredWidth: 360
            Layout.preferredHeight: 200
        }

        P.PearlText { variant: "muted"; text: "No implant marker, canal hint only" }
        P.Render3D {
            Layout.preferredWidth: 360
            Layout.preferredHeight: 200
            showImplantMarker: false
            topLabel: "3D · PREVIEW"
            bottomRightLabel: "scanning..."
        }
    }
}
