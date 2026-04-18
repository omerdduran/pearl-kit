import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText { variant: "muted"; text: "Plain" }
        P.TextArea {
            Layout.preferredWidth: 420
            placeholderText: "Clinical notes..."
        }

        P.PearlText { variant: "muted"; text: "Error" }
        P.TextArea {
            Layout.preferredWidth: 420
            placeholderText: "Required"
            text: "too short"
            error: true
        }

        P.PearlText { variant: "muted"; text: "Mono — log viewer" }
        P.TextArea {
            Layout.preferredWidth: 420
            Layout.preferredHeight: 120
            mono: true
            readOnly: true
            text: "[2026-04-18 10:00:01] INFO  boot: app started\n"
                  + "[2026-04-18 10:00:02] INFO  engine: register_qml ok\n"
                  + "[2026-04-18 10:00:03] WARN  plan: low density region\n"
                  + "[2026-04-18 10:00:04] ERROR export: nerve canal collision"
        }

        P.PearlText { variant: "muted"; text: "Disabled" }
        P.TextArea {
            Layout.preferredWidth: 420
            text: "read-only contents"
            enabled: false
        }
    }
}
