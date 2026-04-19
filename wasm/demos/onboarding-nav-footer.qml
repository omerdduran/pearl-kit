import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 22

        P.PearlText { variant: "muted"; text: "First step — back disabled" }
        P.OnboardingNavFooter {
            Layout.fillWidth: true
            currentStep: 1
            totalSteps: 5
            backEnabled: false
        }

        P.PearlText { variant: "muted"; text: "Mid step — skippable" }
        P.OnboardingNavFooter {
            Layout.fillWidth: true
            currentStep: 3
            totalSteps: 5
            canSkip: true
        }

        P.PearlText { variant: "muted"; text: "Final step — secondary outline + primary CTA" }
        P.OnboardingNavFooter {
            Layout.fillWidth: true
            currentStep: 5
            totalSteps: 5
            secondaryText: "GO TO LIBRARY"
            primaryText: "Open sample case \u2192"
        }
    }
}
