import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    RowLayout {
        anchors.fill: parent
        spacing: 8

        P.Viewport2D {
            Layout.fillWidth: true
            Layout.preferredHeight: 260
            kind: "axial"
            title: "AXIAL"
            slice: 45
            total: 128
            bottomInfo: "W/L 1500/300"
        }
        P.Viewport2D {
            Layout.fillWidth: true
            Layout.preferredHeight: 260
            kind: "coronal"
            title: "CORONAL"
            slice: 72
            total: 160
            bottomInfo: "W/L 1500/300"
        }
        P.Viewport2D {
            Layout.fillWidth: true
            Layout.preferredHeight: 260
            kind: "sagittal"
            title: "SAGITTAL"
            slice: 58
            total: 140
            bottomInfo: "W/L 1500/300"
        }
    }
}
