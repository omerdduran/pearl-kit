import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Cards"
    subtitle: "Rich tile-style content containers across surfaces."
    gridPreset: "two-col"

    ShowcaseTile {
        label: "InfoCard"
        InfoCard {
            width: 360
        }
    }
    ShowcaseTile {
        label: "PlanCard"
        PlanCard {
            width: 360
        }
    }
    ShowcaseTile {
        label: "BrandTile"
        BrandTile {
            width: 280
            height: 200
        }
    }
    ShowcaseTile {
        label: "SampleCaseCard"
        SampleCaseCard {
            width: 360
        }
    }
    ShowcaseTile {
        label: "StatTile"
        StatTile {
            width: 240
        }
    }
    ShowcaseTile {
        label: "SubjectCard"
        SubjectCard {
            width: 360
        }
    }
    ShowcaseTile {
        label: "AISuggestionCard"
        AISuggestionCard {
            width: 360
        }
    }
}
