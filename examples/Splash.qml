import QtQuick
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    id: control

    property int progress: 0
    property int currentStep: 0
    property real totalMs: 2750
    property string version: "DALI \u00B7 3.2.1"
    property string timestamp: "17.04.2026 \u00B7 09:24:18"

    signal ready()

    readonly property var _steps: [
        "Initializing runtime",
        "Loading volumetric engine",
        "Loading segmentation model \u00B7 dali-seg-v3.2",
        "Connecting to case database",
        "Ready",
    ]

    implicitWidth: 1280
    implicitHeight: 800

    Rectangle {
        anchors.fill: parent
        color: "#FAFBFC"
    }

    // faint clinical blue wash
    Rectangle {
        width: 820; height: 820
        radius: width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.38 - height / 2
        opacity: 0.7
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Qt.rgba(37/255, 99/255, 235/255, 0.07) }
            GradientStop { position: 1.0; color: Qt.rgba(37/255, 99/255, 235/255, 0.0) }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        P.TopMetaStrip {
            Layout.fillWidth: true
            leftText: control.version
            rightText: control.timestamp
            monoFontFamily: "JetBrains Mono"
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                anchors.centerIn: parent
                spacing: 40

                P.ScannerMark {
                    anchors.horizontalCenter: parent.horizontalCenter
                    diameter: 150
                }

                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "DALI"
                        color: "#1A202C"
                        font.family: "DM Serif Display"
                        font.pixelSize: 48
                        font.letterSpacing: -0.9
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Cone\u2011Beam CT Implant Planning Workstation"
                        color: "#4A5568"
                        font.family: "Plus Jakarta Sans"
                        font.pixelSize: 13
                        font.letterSpacing: 0.1
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                }

                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 360
                    spacing: 12

                    P.ProgressLine {
                        width: 360
                        value: control.progress
                    }
                    RowLayout {
                        width: 360
                        Text {
                            text: control._steps[control.currentStep]
                            color: "#4A5568"
                            font.family: "JetBrains Mono"
                            font.pixelSize: 11
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }
                        Item { Layout.fillWidth: true; Layout.preferredHeight: 1 }
                        Text {
                            text: String(control.progress).padStart(3, "0") + "%"
                            color: "#2563EB"
                            font.family: "JetBrains Mono"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }
                    }
                }
            }
        }

        P.SystemInfoGrid {
            Layout.fillWidth: true
            monoFontFamily: "JetBrains Mono"
            items: [
                { label: "Host",    value: "MacBook Pro \u00B7 M3 Max" },
                { label: "GPU",     value: "Metal \u00B7 38 cores" },
                { label: "Runtime", value: "dali\u2011core 3.2.1" },
                { label: "License", value: "Clinical \u00B7 valid", dot: "#10B981" },
            ]
        }
    }

    Timer {
        id: tick
        interval: 55
        repeat: true
        running: true
        property int t: 0
        onTriggered: {
            t += 2
            control.progress = Math.min(t, 100)
            if (t < 18)      control.currentStep = 0
            else if (t < 42) control.currentStep = 1
            else if (t < 70) control.currentStep = 2
            else if (t < 96) control.currentStep = 3
            else             control.currentStep = 4

            if (t >= 100) {
                running = false
                readyTimer.start()
            }
        }
    }

    Timer {
        id: readyTimer
        interval: 500
        repeat: false
        onTriggered: control.ready()
    }
}
