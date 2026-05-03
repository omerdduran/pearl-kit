import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Onboarding & Steps"
    subtitle: "Step indicators, checklists, and onboarding chrome."
    gridPreset: "two-col"

    ShowcaseTile {
        label: "StepCircles"
        StepCircles {
            width: 360
        }
    }
    ShowcaseTile {
        label: "StepRail"
        StepRail {
            width: 360
        }
    }
    ShowcaseTile {
        label: "ChecklistItem"
        ChecklistItem {
            width: 360
        }
    }
    ShowcaseTile {
        label: "FeatureBullet"
        FeatureBullet {
            width: 360
        }
    }
    ShowcaseTile {
        label: "ApproveBar"
        ApproveBar {
            width: 600
        }
    }
    ShowcaseTile {
        label: "OnboardingNavFooter"
        OnboardingNavFooter {
            width: 600
        }
    }
}
