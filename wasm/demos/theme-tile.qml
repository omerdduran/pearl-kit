import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    Row {
        anchors.centerIn: parent
        spacing: 12

        P.ThemeTile {
            label: "Light"
            previewBackground: "#FFFFFF"
            inkColor: "#1A202C"
            checked: true
        }
        P.ThemeTile {
            label: "Dark"
            previewBackground: "#0B1120"
            inkColor: "#F1F5F9"
        }
        P.ThemeTile {
            label: "Match system"
            previewBackground: "#EEF2F6"
            inkColor: "#2563EB"
        }
    }
}
