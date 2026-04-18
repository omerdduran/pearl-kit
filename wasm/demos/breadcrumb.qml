import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        P.PearlText { variant: "muted"; text: "2-segment trail" }
        P.Breadcrumb {
            segments: [
                { label: "Cases" },
                { label: "#2847", current: true }
            ]
        }

        P.PearlText { variant: "muted"; text: "3-segment trail" }
        P.Breadcrumb {
            segments: [
                { label: "Project" },
                { label: "Planning" },
                { label: "Final", current: true }
            ]
        }

        P.PearlText { variant: "muted"; text: "5-segment deep path" }
        P.Breadcrumb {
            segments: [
                { label: "Workspace" },
                { label: "Patients" },
                { label: "A-0042" },
                { label: "Plan" },
                { label: "Implant #3", current: true }
            ]
        }
    }
}
