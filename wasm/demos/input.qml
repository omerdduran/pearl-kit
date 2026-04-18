import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.Input {
            Layout.preferredWidth: 320
            placeholderText: "you@example.com"
        }
        P.Input {
            Layout.preferredWidth: 320
            placeholderText: "Search..."
        }
        P.Input {
            Layout.preferredWidth: 320
            placeholderText: "Invalid email"
            text: "not-an-email"
            error: true
        }
        P.Input {
            Layout.preferredWidth: 320
            placeholderText: "Disabled"
            text: "read-only value"
            enabled: false
        }
    }
}
