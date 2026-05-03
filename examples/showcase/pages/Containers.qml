import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Containers"
    subtitle: "Surfaces, dividers, and split panels."
    gridPreset: "two-col"

    ShowcaseTile {
        label: "Card — default"
        Card {
            width: 320
            PearlText { variant: "heading"; text: "Card heading" }
            PearlText { variant: "muted"; text: "Card subtitle text." }
        }
    }
    ShowcaseTile {
        label: "Card — info accent"
        Card {
            width: 320
            variant: "info"
            PearlText { variant: "heading"; text: "Info card" }
            PearlText { variant: "muted"; text: "Left-edge accent stripe." }
        }
    }
    ShowcaseTile {
        label: "Card — destructive accent"
        Card {
            width: 320
            variant: "destructive"
            PearlText { variant: "heading"; text: "Destructive" }
            PearlText { variant: "muted"; text: "For collisions and conflicts." }
        }
    }
    ShowcaseTile {
        label: "Group"
        Group {
            width: 480
            title: "Group title"
            PearlText { text: "Slot content goes here." }
        }
    }
    ShowcaseTile {
        label: "GroupBox"
        GroupBox {
            width: 320
            title: "GroupBox heading"
            PearlText { text: "Children inside the box." }
        }
    }
    ShowcaseTile {
        label: "Separator"
        Separator { width: 240 }
    }
    ShowcaseTile {
        label: "Splitter"
        Splitter {
            width: 360
            height: 120
        }
    }
    ShowcaseTile {
        label: "ScrollArea"
        ScrollArea {
            width: 280
            height: 120
        }
    }
}
