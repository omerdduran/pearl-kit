// Source: design_handoff_onboarding/src/onboarding.jsx:380-421
// Composite case card for the Ready step: SampleCasePreview hero on top
// and a meta block (serif title + caseId, mono meta line, hairline + 3
// metric chips) at the bottom. CTA is the consumer's responsibility.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string title: ""
    property string caseId: ""
    property string metaText: ""
    // [{ key: "SAFETY", value: "5 / 5 OK", valueColor: "#047857" }]
    property var metrics: []

    property string previewTopLeftLabel: "SAMPLE \u00B7 3D VOLUMETRIC"
    property string previewTopRightLabel: ""
    property int previewMarkerCount: 2
    property int previewHeight: 140

    property color background: "#FFFFFF"
    property color borderColor: "#E2E8F0"
    property color titleColor: "#1A202C"
    property color caseIdColor: "#9CA3AF"
    property color metaColor: "#6B7280"
    property color metricKeyColor: "#9CA3AF"
    property color metricValueColor: "#1A202C"
    property color hairlineColor: "#F1F5F9"
    property int radius: 6

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui
    property string fontFamilySerif: "Times New Roman"

    implicitWidth: 540
    implicitHeight: control.previewHeight + _meta.implicitHeight + 28

    Rectangle {
        anchors.fill: parent
        radius: control.radius
        color: control.background
        border.color: control.borderColor
        border.width: 1
        clip: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            SampleCasePreview {
                Layout.fillWidth: true
                Layout.preferredHeight: control.previewHeight
                topLeftLabel: control.previewTopLeftLabel
                topRightLabel: control.previewTopRightLabel
                markerCount: control.previewMarkerCount
                previewHeight: control.previewHeight
            }

            ColumnLayout {
                id: _meta
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.topMargin: 14
                Layout.bottomMargin: 14
                spacing: 0

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: control.title
                        color: control.titleColor
                        font.family: control.fontFamilySerif
                        font.pixelSize: 17
                        font.letterSpacing: -0.17
                        renderType: Text.NativeRendering
                        antialiasing: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        visible: control.caseId !== ""
                        text: control.caseId
                        color: control.caseIdColor
                        font.family: control.fontFamilyMono
                        font.pixelSize: 10
                        font.letterSpacing: 0.6
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                }

                Item { Layout.preferredHeight: 4 }

                Text {
                    visible: control.metaText !== ""
                    text: control.metaText
                    color: control.metaColor
                    font.family: control.fontFamilyMono
                    font.pixelSize: 11
                    font.letterSpacing: 0.4
                    font.capitalization: Font.AllUppercase
                    renderType: Text.NativeRendering
                    antialiasing: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Item { Layout.preferredHeight: 10 }

                Rectangle {
                    visible: control.metrics && control.metrics.length > 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: control.hairlineColor
                }

                Item { Layout.preferredHeight: 10; visible: control.metrics && control.metrics.length > 0 }

                RowLayout {
                    Layout.fillWidth: true
                    visible: control.metrics && control.metrics.length > 0
                    spacing: 16

                    Repeater {
                        model: control.metrics

                        delegate: RowLayout {
                            spacing: 4

                            Text {
                                text: modelData && modelData.key !== undefined ? String(modelData.key) + " " : ""
                                color: control.metricKeyColor
                                font.family: control.fontFamilyMono
                                font.pixelSize: 11
                                font.letterSpacing: 0.5
                                font.capitalization: Font.AllUppercase
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }

                            Text {
                                text: modelData && modelData.value !== undefined ? String(modelData.value) : ""
                                color: modelData && modelData.valueColor !== undefined
                                    ? modelData.valueColor : control.metricValueColor
                                font.family: control.fontFamilyMono
                                font.pixelSize: 11
                                font.weight: Font.DemiBold
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }
                        }
                    }
                }
            }
        }
    }
}
