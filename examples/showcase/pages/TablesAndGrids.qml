import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Tables & Grids"
    subtitle: "Tabular data, fact strips, and filter bars."
    gridPreset: "single-col"

    ShowcaseTile {
        label: "DataTable"
        DataTable {
            width: 720
            height: 240
        }
    }
    ShowcaseTile {
        label: "FactGrid"
        FactGrid {
            width: 720
        }
    }
    ShowcaseTile {
        label: "SummaryGrid"
        SummaryGrid {
            width: 720
        }
    }
    ShowcaseTile {
        label: "SystemInfoGrid"
        SystemInfoGrid {
            width: 720
        }
    }
    ShowcaseTile {
        label: "FilterRow"
        FilterRow {
            width: 720
        }
    }
}
