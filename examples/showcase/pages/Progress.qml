import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Progress"
    subtitle: "Determinate and indeterminate progress affordances."
    gridPreset: "single-col"

    ShowcaseTile {
        label: "ProgressBar — determinate"
        ProgressBar {
            width: 480
            from: 0
            to: 100
            value: 38
        }
    }
    ShowcaseTile {
        label: "ProgressBar — indeterminate"
        ProgressBar {
            width: 480
            indeterminate: true
        }
    }
    ShowcaseTile {
        label: "ProgressLine"
        ProgressLine {
            width: 480
        }
    }
    ShowcaseTile {
        label: "StorageBar"
        StorageBar {
            width: 480
        }
    }
}
