import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Form Rows"
    subtitle: "Label-aligned rows for settings and forms."
    gridPreset: "single-col"

    ShowcaseTile {
        label: "FormRow"
        FormRow {
            width: 600
            label: "Email"
            Input { width: 320; placeholderText: "you@example.com" }
        }
    }
    ShowcaseTile {
        label: "SettingsRow"
        SettingsRow {
            width: 600
        }
    }
    ShowcaseTile {
        label: "SettingsHeader"
        SettingsHeader {
            width: 600
            eyebrow: "PREFERENCES"
            title: "Notifications"
            description: "Configure how DALI alerts you about plan and analysis events."
        }
    }
    ShowcaseTile {
        label: "MetaRow"
        MetaRow {
            width: 600
        }
    }
    ShowcaseTile {
        label: "SafetyRow"
        SafetyRow {
            width: 600
        }
    }
}
