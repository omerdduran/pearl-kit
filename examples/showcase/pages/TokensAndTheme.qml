import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Tokens & Theme"
    subtitle: "Foundational design values flowing through every component."
    gridPreset: "flow"

    ShowcaseTile {
        label: "ColorDot — primary"
        ColorDot { color: Tokens.primary }
    }
    ShowcaseTile {
        label: "ColorDot — accent"
        ColorDot { color: Tokens.accent }
    }
    ShowcaseTile {
        label: "ColorDot — destructive"
        ColorDot { color: Tokens.destructive }
    }
    ShowcaseTile {
        label: "ColorDot — success"
        ColorDot { color: Tokens.success }
    }
    ShowcaseTile {
        label: "ColorDot — warning"
        ColorDot { color: Tokens.warning }
    }
    ShowcaseTile {
        label: "ThemeTile — Light"
        ThemeTile { width: 160; height: 96 }
    }
    ShowcaseTile {
        label: "ThemeTile — Dark"
        ThemeTile { width: 160; height: 96 }
    }
}
