import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Typography"
    subtitle: "Text variants, mono blocks, and editorial flourishes."
    gridPreset: "single-col"

    ShowcaseTile {
        label: "PearlText — title"
        PearlText { variant: "title"; text: "The quick brown fox jumps." }
    }
    ShowcaseTile {
        label: "PearlText — heading"
        PearlText { variant: "heading"; text: "Section heading sample." }
    }
    ShowcaseTile {
        label: "PearlText — body"
        PearlText { variant: "body"; text: "Body copy renders at 14 px regular." }
    }
    ShowcaseTile {
        label: "PearlText — muted"
        PearlText { variant: "muted"; text: "Muted helper text — 14 px regular, mutedForeground." }
    }
    ShowcaseTile {
        label: "PearlText — label"
        PearlText { variant: "label"; text: "FORM LABEL" }
    }
    ShowcaseTile {
        label: "PearlText — code"
        PearlText { variant: "code"; text: "const x = computeRadius(node)" }
    }
    ShowcaseTile {
        label: "PearlText — mono"
        PearlText { variant: "mono"; text: "0xDEADBEEF  →  3735928559" }
    }
    ShowcaseTile {
        label: "SectionLabel"
        SectionLabel { text: "Foundations" }
    }
    ShowcaseTile {
        label: "SectionNumeral"
        SectionNumeral { text: "01" }
    }
    ShowcaseTile {
        label: "PullQuote"
        PullQuote {
            width: 600
            text: "Design is not just what it looks like. Design is how it works."
        }
    }
    ShowcaseTile {
        label: "CodeBlock"
        CodeBlock {
            width: 600
            language: "javascript"
            filename: "showcase.qml"
            code: "function tile(width, label) {\n    return new ShowcaseTile({width, label});\n}"
        }
    }
}
