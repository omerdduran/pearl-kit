import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Host telemetry footer" }
        P.SystemInfoGrid {
            Layout.fillWidth: true
            items: [
                { label: "HOST",   value: "MacBook Pro 16\"", dot: "#10B981" },
                { label: "RAM",    value: "64 GB" },
                { label: "GPU",    value: "M3 Max" },
                { label: "UPTIME", value: "4h 12m" }
            ]
        }

        P.PearlText { variant: "muted"; text: "Case progress footer" }
        P.SystemInfoGrid {
            Layout.fillWidth: true
            items: [
                { label: "CASE",     value: "A-0042", dot: "#2563EB" },
                { label: "PLACED",   value: "3 / 4" },
                { label: "EXPORTED", value: "plan.json" },
                { label: "SIGNED",   value: "Dr. Foster", dot: "#10B981" }
            ]
        }
    }
}
