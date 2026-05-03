import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Audit & Editorial"
    subtitle: "Audit log rows, signatures, and editorial flourishes."
    gridPreset: "single-col"

    ShowcaseTile {
        label: "AuditLogRow"
        AuditLogRow {
            width: 720
        }
    }
    ShowcaseTile {
        label: "SignaturePreview"
        SignaturePreview {
            width: 320
            height: 120
        }
    }
    ShowcaseTile {
        label: "EditorialHero"
        EditorialHero {
            width: 720
        }
    }
    ShowcaseTile {
        label: "Thumb"
        Thumb {
            width: 96
            height: 96
        }
    }
}
