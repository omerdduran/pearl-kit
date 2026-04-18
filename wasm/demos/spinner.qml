import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Default 16 px, alongside a label" }
        Row {
            spacing: 8
            P.Spinner { anchors.verticalCenter: parent.verticalCenter }
            P.PearlText {
                text: "Loading..."
                variant: "muted"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        P.PearlText { variant: "muted"; text: "Size overrides" }
        Row {
            spacing: 16
            P.Spinner { width: 12; height: 12; anchors.verticalCenter: parent.verticalCenter }
            P.Spinner { anchors.verticalCenter: parent.verticalCenter }
            P.Spinner { width: 20; height: 20; anchors.verticalCenter: parent.verticalCenter }
            P.Spinner { width: 24; height: 24; anchors.verticalCenter: parent.verticalCenter }
            P.Spinner { width: 32; height: 32; strokeWidth: 3; anchors.verticalCenter: parent.verticalCenter }
        }

        P.PearlText { variant: "muted"; text: "Color overrides" }
        Row {
            spacing: 16
            P.Spinner { width: 24; height: 24; color: P.Tokens.primary }
            P.Spinner { width: 24; height: 24; color: P.Tokens.destructive }
            P.Spinner { width: 24; height: 24; color: P.Tokens.success }
            P.Spinner { width: 24; height: 24; color: P.Tokens.foreground }
        }

        P.PearlText { variant: "muted"; text: "Paused (running: false)" }
        P.Spinner { running: false; width: 24; height: 24 }
    }
}
