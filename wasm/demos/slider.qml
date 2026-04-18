import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        RowLayout {
            spacing: 16
            P.PearlText { variant: "muted"; text: "Horizontal"; Layout.preferredWidth: 110 }
            P.Slider { Layout.preferredWidth: 240; from: 0; to: 100; value: 50 }
        }

        RowLayout {
            spacing: 16
            P.PearlText { variant: "muted"; text: "Ticks"; Layout.preferredWidth: 110 }
            P.Slider {
                Layout.preferredWidth: 240
                from: 0; to: 100; value: 60
                stepSize: 10; showTicks: true
            }
        }

        RowLayout {
            spacing: 16
            P.PearlText { variant: "muted"; text: "Window/Level"; Layout.preferredWidth: 110 }
            P.Slider {
                Layout.preferredWidth: 240
                from: 0; to: 6000; value: 2048; stepSize: 50
            }
        }

        RowLayout {
            spacing: 16
            P.PearlText { variant: "muted"; text: "Disabled"; Layout.preferredWidth: 110 }
            P.Slider { Layout.preferredWidth: 240; from: 0; to: 100; value: 35; enabled: false }
        }

        RowLayout {
            spacing: 32
            P.PearlText { variant: "muted"; text: "Vertical"; Layout.preferredWidth: 110 }
            P.Slider {
                orientation: Qt.Vertical
                Layout.preferredHeight: 140
                from: 0; to: 100; value: 40
            }
            P.Slider {
                orientation: Qt.Vertical
                Layout.preferredHeight: 140
                from: 0; to: 100; value: 70
                stepSize: 10; showTicks: true
            }
        }
    }
}
