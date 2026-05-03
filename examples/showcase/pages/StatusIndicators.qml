import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Status Indicators"
    subtitle: "Compact pills, dots, and live state markers."
    gridPreset: "four-col"

    ShowcaseTile {
        label: "Badge — default"
        Badge { text: "New" }
    }
    ShowcaseTile {
        label: "Badge — destructive"
        Badge { text: "Error"; variant: "destructive" }
    }
    ShowcaseTile {
        label: "Badge — outline"
        Badge { text: "Beta"; variant: "outline" }
    }
    ShowcaseTile {
        label: "Chip"
        Chip { text: "Filter" }
    }
    ShowcaseTile {
        label: "StatusPill"
        StatusPill { text: "Active" }
    }
    ShowcaseTile {
        label: "SaveIndicator"
        SaveIndicator { }
    }
    ShowcaseTile {
        label: "ConnectionStatus"
        ConnectionStatus { }
    }
    ShowcaseTile {
        label: "Spinner"
        Spinner { }
    }
}
