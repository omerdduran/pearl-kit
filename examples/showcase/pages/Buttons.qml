import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Buttons"
    subtitle: "Primary and secondary actions across the app."
    gridPreset: "four-col"

    ShowcaseTile {
        label: "Button — default"
        Button { text: "Default"; variant: "default" }
    }
    ShowcaseTile {
        label: "Button — secondary"
        Button { text: "Secondary"; variant: "secondary" }
    }
    ShowcaseTile {
        label: "Button — destructive"
        Button { text: "Delete"; variant: "destructive" }
    }
    ShowcaseTile {
        label: "Button — outline"
        Button { text: "Outline"; variant: "outline" }
    }
    ShowcaseTile {
        label: "Button — ghost"
        Button { text: "Ghost"; variant: "ghost" }
    }
    ShowcaseTile {
        label: "Button — link"
        Button { text: "Link"; variant: "link" }
    }
    ShowcaseTile {
        label: "Button — sm"
        Button { text: "Small"; size: "sm" }
    }
    ShowcaseTile {
        label: "Button — lg"
        Button { text: "Large"; size: "lg" }
    }
    ShowcaseTile {
        label: "Button — disabled"
        Button { text: "Disabled"; enabled: false }
    }
    ShowcaseTile {
        label: "ToolButton"
        ToolButton { label: "Tool"; iconKey: "wrench" }
    }
    ShowcaseTile {
        label: "IconBadge"
        IconBadge { }
    }
}
