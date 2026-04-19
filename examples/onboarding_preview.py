"""Preview of pearl-kit's experimental onboarding primitives.

Shows the 10 onboarding components composed into a recognizable shell that
mirrors the DALI design handoff (compact + editorial side by side):

    ┌────────────────────────────┬───────────────────────────────────┐
    │ Compact                    │ Editorial                         │
    │  ┌──────────────────────┐  │  ┌──────────┬─────────────────┐   │
    │  │ StepCircles          │  │  │ StepRail │ body            │   │
    │  ├──────────────────────┤  │  │          │ (FactGrid /     │   │
    │  │ body slot            │  │  │          │  SettingsToggle)│   │
    │  │ FeatureBullet x3 /   │  │  │          │                 │   │
    │  │ SignaturePad /       │  │  │          ├─────────────────┤   │
    │  │ FactGrid / etc.      │  │  │          │ NavFooter       │   │
    │  ├──────────────────────┤  │  └──────────┴─────────────────┘   │
    │  │ NavFooter            │  │                                   │
    │  └──────────────────────┘  │                                   │
    └────────────────────────────┴───────────────────────────────────┘

This file exercises every new component end-to-end so the preview catches
regressions before consumers (airontgen / DALI) wire the primitives into
their own onboarding flow.
"""

from __future__ import annotations

import sys
from pathlib import Path

from PySide6.QtGui import QFontDatabase, QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit

_EXAMPLES_DIR = Path(__file__).resolve().parent
_FONTS_DIR = _EXAMPLES_DIR / "fonts"
_FONT_FILES = (
    "DMSerifDisplay-Regular.ttf",
    "PlusJakartaSans-Regular.ttf",
    "PlusJakartaSans-Bold.ttf",
    "PlusJakartaSans-Light.ttf",
    "JetBrainsMono-Regular.ttf",
)


def _load_fonts() -> None:
    for name in _FONT_FILES:
        path = _FONTS_DIR / name
        if path.exists():
            QFontDatabase.addApplicationFont(str(path))


_QML = """
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import PearlKit 1.0 as P

ApplicationWindow {
    id: root
    width: 1480
    height: 900
    visible: true
    title: "pearl-kit · onboarding preview"
    color: "#FAFBFC"

    property int currentStep: 1
    property int totalSteps: 5
    readonly property var stepModel: [
        { n: "01", label: "Welcome",   sub: "Get started" },
        { n: "02", label: "Profile",   sub: "Who you are" },
        { n: "03", label: "Clinical",  sub: "Your defaults" },
        { n: "04", label: "AI & data", sub: "Privacy" },
        { n: "05", label: "Ready",     sub: "Sample case" }
    ]

    RowLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        // ───── Compact card ─────
        Rectangle {
            Layout.preferredWidth: 640
            Layout.fillHeight: true
            color: "#FFFFFF"
            border.color: "#E2E8F0"
            border.width: 1
            radius: 8

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 56
                    color: "#FFFFFF"
                    border.color: "#E2E8F0"
                    border.width: 1

                    P.StepCircles {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        currentIndex: root.currentStep
                        labelMode: "active"
                        model: root.stepModel
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ScrollView {
                        anchors.fill: parent
                        clip: true

                        ColumnLayout {
                            width: 568
                            x: 36
                            y: 32
                            spacing: 18

                            Text {
                                text: "Welcome to DALI"
                                color: "#1A202C"
                                font.family: "DM Serif Display"
                                font.pixelSize: 30
                                font.letterSpacing: -0.6
                                renderType: Text.NativeRendering
                            }

                            Text {
                                Layout.preferredWidth: 540
                                wrapMode: Text.WordWrap
                                text: "A few minutes to set up your profile, clinical defaults, and data-handling preferences."
                                color: "#4A5568"
                                font.family: "Plus Jakarta Sans"
                                font.pixelSize: 13
                                renderType: Text.NativeRendering
                            }

                            P.FactGrid {
                                Layout.preferredWidth: 540
                                model: [
                                    { key: "5 MIN",  value: "Typical setup",        sub: "Skip anything optional" },
                                    { key: "LOCAL",  value: "Data stays local",     sub: "HIPAA / KVKK default" },
                                    { key: "1,247",  value: "Clinicians onboarded", sub: "23 countries" },
                                    { key: "3.2.1",  value: "Clinical build",       sub: "License valid to 2027-04" }
                                ]
                            }

                            ColumnLayout {
                                Layout.preferredWidth: 540
                                spacing: 14
                                P.FeatureBullet { title: "AI segmentation"; description: "Bones, nerves, sinuses auto-detected." }
                                P.FeatureBullet { title: "Safety thresholds"; description: "Per-structure clearance bands flag sub-min plans." }
                                P.FeatureBullet { title: "Guide export"; description: "STL surgical guides direct to milling vendors." }
                            }

                            P.SignaturePad {
                                Layout.preferredWidth: 540
                                signed: true
                                signatureText: "M.Kaya"
                                onRequestRedraw: signed = !signed
                            }
                        }
                    }
                }

                P.OnboardingNavFooter {
                    Layout.fillWidth: true
                    currentStep: root.currentStep + 1
                    totalSteps: root.totalSteps
                    backEnabled: root.currentStep > 0
                    canSkip: root.currentStep === 2 || root.currentStep === 3
                    onBack: root.currentStep = Math.max(0, root.currentStep - 1)
                    onPrimary: root.currentStep = Math.min(root.totalSteps - 1, root.currentStep + 1)
                    onSkip: root.currentStep = Math.min(root.totalSteps - 1, root.currentStep + 1)
                }
            }
        }

        // ───── Editorial split ─────
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#FFFFFF"
            border.color: "#E2E8F0"
            border.width: 1
            radius: 8

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.preferredWidth: 320
                    Layout.fillHeight: true
                    color: "#FFFFFF"
                    border.color: "#ECEEF2"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 28
                        spacing: 24

                        Text {
                            text: "DALI"
                            color: "#1A202C"
                            font.family: "DM Serif Display"
                            font.pixelSize: 24
                            renderType: Text.NativeRendering
                        }

                        P.StepRail {
                            Layout.fillWidth: true
                            currentIndex: root.currentStep
                            model: root.stepModel
                            onStepClicked: index => root.currentStep = index
                        }

                        Item { Layout.fillHeight: true }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 0

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        ColumnLayout {
                            width: 600
                            x: 48
                            y: 48
                            spacing: 18

                            Text {
                                text: "Privacy & compliance"
                                color: "#1A202C"
                                font.family: "DM Serif Display"
                                font.pixelSize: 32
                                font.letterSpacing: -0.64
                                renderType: Text.NativeRendering
                            }

                            P.SettingsToggleCard {
                                Layout.preferredWidth: 560
                                title: "HIPAA / KVKK compliance mode"
                                description: "All DICOM data remains on the workstation. Only anonymized summaries leave the device for AI reasoning."
                                badgeText: "RECOMMENDED"
                                checked: true
                                highlighted: true
                            }

                            P.SettingsToggleCard {
                                Layout.preferredWidth: 560
                                title: "Send volumes to cloud for heavy inference"
                                description: "Disabled while compliance mode is on. All inference runs locally on your GPU."
                                checked: false
                                locked: true
                            }

                            P.SampleCaseCard {
                                Layout.preferredWidth: 560
                                title: "Demo \u00b7 Y\u0131lmaz, Ay\u015fe"
                                caseId: "#0000-00"
                                metaText: "MANDIBLE \u00b7 TOOTH 36/37 \u00b7 2 IMPLANTS \u00b7 STRAUMANN BLT"
                                previewTopRightLabel: "142 / 512"
                                metrics: [
                                    { key: "SAFETY",  value: "5 / 5 OK", valueColor: "#047857" },
                                    { key: "CANAL",   value: "3.2 mm" },
                                    { key: "AI TOUR", value: "Enabled",  valueColor: "#2563EB" }
                                ]
                            }

                            P.SummaryGrid {
                                Layout.preferredWidth: 560
                                model: [
                                    { key: "NAME",       value: "Dr. Mehmet Kaya" },
                                    { key: "LICENSE",    value: "TR-DDS-21487" },
                                    { key: "BRAND",      value: "STRAUMANN BLT" },
                                    { key: "CANAL MIN",  value: "2.5 mm" },
                                    { key: "COMPLIANCE", value: "HIPAA/KVKK ON", valueColor: "#047857" },
                                    { key: "REGION",     value: "EU-CENTRAL" }
                                ]
                            }
                        }
                    }

                    P.OnboardingNavFooter {
                        Layout.fillWidth: true
                        currentStep: root.currentStep + 1
                        totalSteps: root.totalSteps
                        backEnabled: root.currentStep > 0
                        canSkip: root.currentStep === 2 || root.currentStep === 3
                        secondaryText: root.currentStep === root.totalSteps - 1 ? "GO TO LIBRARY" : ""
                        primaryText: root.currentStep === root.totalSteps - 1
                            ? "Open sample case \u2192" : "Continue \u2192"
                        onBack: root.currentStep = Math.max(0, root.currentStep - 1)
                        onPrimary: root.currentStep = Math.min(root.totalSteps - 1, root.currentStep + 1)
                        onSkip: root.currentStep = Math.min(root.totalSteps - 1, root.currentStep + 1)
                    }
                }
            }
        }
    }
}
"""


def main() -> int:
    app = QGuiApplication(sys.argv)
    _load_fonts()
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(_QML.encode("utf-8"))
    if not engine.rootObjects():
        return 1
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
