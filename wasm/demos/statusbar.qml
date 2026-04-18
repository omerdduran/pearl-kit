import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.StatusBar {
            id: defaultBar
            Layout.fillWidth: true
            leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "12 implants placed" }
            centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "14.2 x 8.3 mm @ 200%" }
            rightContent: P.PearlText {
                font.family: P.Tokens.font.ui
                font.pixelSize: P.Tokens.font.size.xs
                text: "Idle"
                color: defaultBar.statusColor
            }
        }

        P.StatusBar {
            id: successBar
            Layout.fillWidth: true
            statusKind: "success"
            leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Press S to save" }
            centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Auto-aligned 4 / 4" }
            rightContent: P.PearlText {
                font.family: P.Tokens.font.ui
                font.pixelSize: P.Tokens.font.size.xs
                text: "Saved"
                color: successBar.statusColor
            }
        }

        P.StatusBar {
            id: warningBar
            Layout.fillWidth: true
            statusKind: "warning"
            leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Low bone density" }
            centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "HU 248" }
            rightContent: P.PearlText {
                font.family: P.Tokens.font.ui
                font.pixelSize: P.Tokens.font.size.xs
                text: "Review"
                color: warningBar.statusColor
            }
        }

        P.StatusBar {
            id: errorBar
            Layout.fillWidth: true
            statusKind: "error"
            leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Nerve canal collision" }
            centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Implant #3 overlap 1.2 mm" }
            rightContent: P.PearlText {
                font.family: P.Tokens.font.ui
                font.pixelSize: P.Tokens.font.size.xs
                text: "Blocked"
                color: errorBar.statusColor
            }
        }
    }
}
