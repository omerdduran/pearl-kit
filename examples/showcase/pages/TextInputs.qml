import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

ShowcasePage {
    title: "Text Inputs"
    subtitle: "Single-line, multiline, search, and signature inputs."
    gridPreset: "two-col"

    ShowcaseTile {
        label: "Input — placeholder"
        Input {
            width: 300
            placeholderText: "you@example.com"
        }
    }
    ShowcaseTile {
        label: "Input — error"
        Input {
            width: 300
            placeholderText: "Required"
            text: "not-an-email"
            error: true
        }
    }
    ShowcaseTile {
        label: "Input — disabled"
        Input {
            width: 300
            text: "read-only"
            enabled: false
        }
    }
    ShowcaseTile {
        label: "TextArea — plain"
        TextArea {
            width: 300
            placeholderText: "Clinical notes..."
        }
    }
    ShowcaseTile {
        label: "TextArea — mono"
        TextArea {
            width: 300
            mono: true
            placeholderText: "XXXX-XXXX-XXXX-XXXX"
        }
    }
    ShowcaseTile {
        label: "SuffixInput"
        SuffixInput { width: 200 }
    }
    ShowcaseTile {
        label: "SearchField"
        SearchField { width: 280; placeholderText: "Search components..." }
    }
    ShowcaseTile {
        label: "SignaturePad"
        SignaturePad { width: 360; height: 140 }
    }
}
