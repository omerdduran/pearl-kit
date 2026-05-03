import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Selection Controls"
    subtitle: "Boolean and multi-option pickers."
    gridPreset: "four-col"

    ShowcaseTile {
        label: "CheckBox"
        CheckBox { text: "Accept terms" }
    }
    ShowcaseTile {
        label: "CheckBox — checked"
        CheckBox { text: "Subscribed"; checked: true }
    }
    ShowcaseTile {
        label: "Toggle"
        Toggle { }
    }
    ShowcaseTile {
        label: "Toggle — checked"
        Toggle { checked: true }
    }
    ShowcaseTile {
        label: "Select"
        Select {
            width: 220
            model: ["Apple", "Banana", "Cherry"]
        }
    }
    ShowcaseTile {
        label: "SegmentedControl"
        SegmentedControl { }
    }
    ShowcaseTile {
        label: "StatusToggle"
        StatusToggle { }
    }
    ShowcaseTile {
        label: "SettingsToggleCard"
        SettingsToggleCard { width: 320 }
    }
}
