import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText {
            variant: "muted"
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: "Detach is a desktop-only affordance — secondary windows don't behave correctly inside an iframe, so the button below is disabled here. Install with `pip install pearl-kit` and run the gallery locally to try the pop-out."
        }

        P.DetachableTabView {
            id: dtv
            Layout.fillWidth: true
            Layout.preferredHeight: 220
            variant: "line"

            P.DetachableTab {
                title: "Home"
                stackKey: "home"
                permanent: true

                Rectangle {
                    anchors.fill: parent
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    radius: P.Tokens.radius.md
                    P.PearlText { anchors.centerIn: parent; text: "Home — permanent tab"; variant: "label" }
                }
            }

            P.DetachableTab {
                title: "Viewer"
                stackKey: "viewer"

                Rectangle {
                    anchors.fill: parent
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    radius: P.Tokens.radius.md
                    P.PearlText { anchors.centerIn: parent; text: "Viewer pane"; variant: "label" }
                }
            }

            P.DetachableTab {
                title: "Editor"
                stackKey: "editor"

                Rectangle {
                    anchors.fill: parent
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    radius: P.Tokens.radius.md
                    P.PearlText { anchors.centerIn: parent; text: "Editor pane"; variant: "label" }
                }
            }
        }

        Row {
            spacing: 8
            P.Button {
                text: "Detach Viewer (desktop-only)"
                variant: "outline"
                enabled: false
                P.Tooltip {
                    parent: parent
                    text: "Detaching a tab spawns a secondary OS window, which is blocked inside the docs iframe."
                    visible: parent.hovered
                }
            }
        }
    }
}
