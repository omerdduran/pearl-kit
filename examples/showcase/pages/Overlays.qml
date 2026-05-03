import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Overlays"
    subtitle: "Modal dialogs, confirmations, toasts, and tooltips."
    gridPreset: "two-col"

    ShowcaseTile {
        label: "Dialog (placeholder)"
        Item {
            width: 240
            height: 60
            PearlText {
                anchors.centerIn: parent
                text: "Dialog — instantiated at runtime"
                variant: "muted"
            }
        }
    }
    ShowcaseTile {
        label: "MessageBox (placeholder)"
        Item {
            width: 240
            height: 60
            PearlText {
                anchors.centerIn: parent
                text: "MessageBox — opens on demand"
                variant: "muted"
            }
        }
    }
    ShowcaseTile {
        label: "Toast"
        Toast {
            width: 320
            type: "success"
            title: "Saved"
            description: "Plan changes persisted to disk."
        }
    }
    ShowcaseTile {
        label: "Tooltip (placeholder)"
        Item {
            width: 240
            height: 60
            PearlText {
                anchors.centerIn: parent
                text: "Tooltip — attaches to a target"
                variant: "muted"
            }
        }
    }
}
