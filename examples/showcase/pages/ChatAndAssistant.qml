import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Chat & Assistant"
    subtitle: "Clinical assistant chat surface primitives."
    gridPreset: "single-col"

    ShowcaseTile {
        label: "ChatComposer"
        ChatComposer {
            width: 600
        }
    }
    ShowcaseTile {
        label: "ChatMessage — user"
        ChatMessage {
            width: 600
        }
    }
    ShowcaseTile {
        label: "ChatMessage — assistant"
        ChatMessage {
            width: 600
        }
    }
}
