import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        P.PearlText { variant: "title";   text: "Settings" }
        P.PearlText { variant: "heading"; text: "Notifications" }
        P.PearlText { variant: "body";    text: "Receive updates when your plan completes." }
        P.PearlText { variant: "muted";   text: "32 items" }
        P.PearlText { variant: "label";   text: "Email" }
        P.PearlText { variant: "code";    text: "/usr/local/bin/dali" }
        P.PearlText { variant: "mono";    text: "42" }
        P.PearlText {
            text: "A long sentence that elides at the end because its width is constrained"
            Layout.preferredWidth: 260
            elide: Text.ElideRight
        }
    }
}
