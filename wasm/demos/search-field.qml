import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Default ⌘K" }
        P.SearchField {
            Layout.preferredWidth: 360
            placeholderText: "Search cases..."
        }

        P.PearlText { variant: "muted"; text: "Custom shortcut hint" }
        P.SearchField {
            Layout.preferredWidth: 360
            placeholderText: "Find file"
            shortcutHint: "⌘F"
        }

        P.PearlText { variant: "muted"; text: "With a seeded query" }
        P.SearchField {
            Layout.preferredWidth: 360
            text: "implant"
            placeholderText: "Search..."
        }
    }
}
