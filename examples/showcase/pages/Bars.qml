import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Bars"
    subtitle: "Top, bottom, and contextual bars across surfaces."
    gridPreset: "single-col"

    ShowcaseTile {
        label: "TabBar"
        TabBar {
            width: 480
            TabButton { text: "Overview" }
            TabButton { text: "Plan" }
            TabButton { text: "Audit" }
        }
    }
    ShowcaseTile {
        label: "Breadcrumb"
        Breadcrumb {
            width: 480
        }
    }
    ShowcaseTile {
        label: "StatusBar"
        StatusBar {
            width: 600
        }
    }
    ShowcaseTile {
        label: "TopMetaStrip"
        TopMetaStrip {
            width: 600
        }
    }
    ShowcaseTile {
        label: "PatientStrip"
        PatientStrip {
            width: 600
        }
    }
}
