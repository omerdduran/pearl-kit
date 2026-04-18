import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Pill (default)" }
        P.SegmentedControl {
            options: [
                { key: "a", label: "Analysis" },
                { key: "b", label: "Brief" },
                { key: "c", label: "Plan" }
            ]
            current: "a"
            variant: "pill"
        }

        P.PearlText { variant: "muted"; text: "Bordered" }
        P.SegmentedControl {
            options: [
                { key: "axial",    label: "Axial" },
                { key: "coronal",  label: "Coronal" },
                { key: "sagittal", label: "Sagittal" }
            ]
            current: "coronal"
            variant: "bordered"
        }

        P.PearlText { variant: "muted"; text: "Solid" }
        P.SegmentedControl {
            options: [
                { key: "d", label: "Day" },
                { key: "w", label: "Week" },
                { key: "m", label: "Month" },
                { key: "y", label: "Year" }
            ]
            current: "w"
            variant: "solid"
        }
    }
}
