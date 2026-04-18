import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        Layout.maximumWidth: 560

        P.PearlText { variant: "muted"; text: "Default" }
        P.ChatComposer {
            Layout.fillWidth: true
            placeholder: "Ask about bone, safety, alternatives…"
            onSubmitted: function(t) { console.log("submitted:", t) }
        }

        P.PearlText { variant: "muted"; text: "Custom submit label" }
        P.ChatComposer {
            Layout.fillWidth: true
            placeholder: "Type a prompt"
            submitLabel: "SEND"
        }
    }
}
