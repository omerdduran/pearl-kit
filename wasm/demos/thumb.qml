import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "All five kinds — axial active" }
        Row {
            spacing: 8
            P.Thumb { kind: "axial";    accent: true  }
            P.Thumb { kind: "coronal" }
            P.Thumb { kind: "sagittal" }
            P.Thumb { kind: "pano" }
            P.Thumb { kind: "3d" }
        }

        P.PearlText { variant: "muted"; text: "Plane-picker row — 3d active" }
        Row {
            spacing: 8
            P.Thumb { kind: "axial" }
            P.Thumb { kind: "coronal" }
            P.Thumb { kind: "sagittal" }
            P.Thumb { kind: "pano" }
            P.Thumb { kind: "3d"; accent: true }
        }
    }
}
