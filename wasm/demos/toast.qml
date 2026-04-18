import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText { variant: "muted"; text: "Fire any toast — stack auto-dismisses" }
        Flow {
            Layout.fillWidth: true
            spacing: 8

            P.Button {
                text: "Default"
                size: "sm"
                onClicked: P.Toaster.show({title: "Heads up", description: "Something happened."})
            }
            P.Button {
                text: "Success"
                size: "sm"
                variant: "secondary"
                onClicked: P.Toaster.show({type: "success", title: "Saved", description: "Your changes are live."})
            }
            P.Button {
                text: "Info"
                size: "sm"
                variant: "secondary"
                onClicked: P.Toaster.show({type: "info", title: "Tip", description: "Press Cmd+K to search."})
            }
            P.Button {
                text: "Warning"
                size: "sm"
                variant: "outline"
                onClicked: P.Toaster.show({type: "warning", title: "Low disk space", description: "Under 10% remaining."})
            }
            P.Button {
                text: "Error"
                size: "sm"
                variant: "destructive"
                onClicked: P.Toaster.show({type: "error", title: "Upload failed", description: "Check your connection."})
            }
            P.Button {
                text: "Loading"
                size: "sm"
                variant: "ghost"
                onClicked: {
                    var id = P.Toaster.show({type: "loading", title: "Processing", description: "This may take a moment."})
                    loadingDismissTimer.pendingId = id
                    loadingDismissTimer.restart()
                }
            }
            P.Button {
                text: "Dismiss all"
                size: "sm"
                variant: "ghost"
                onClicked: P.Toaster.dismissAll()
            }
        }

        Timer {
            id: loadingDismissTimer
            interval: 1800
            property int pendingId: -1
            onTriggered: if (pendingId !== -1) P.Toaster.dismiss(pendingId)
        }
    }
}
