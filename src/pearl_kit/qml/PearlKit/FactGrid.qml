// Source: design_handoff_onboarding/src/onboarding.jsx:164-181
// Welcome-step 2-col stat grid: bordered container with 1px hairlines
// (achieved via parent border background + per-cell white fill spaced by
// rowSpacing/columnSpacing). Each cell: mono key + medium value + sub.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    // [{ key: "5 MIN", value: "Typical setup", sub: "Skip anything optional" }]
    property var model: []
    property int columns: 2
    property int cellPadding: 14

    property color background: "#E2E8F0"
    property color cellBackground: "#FFFFFF"
    property color borderColor: "#E2E8F0"
    property color keyColor: "#9CA3AF"
    property color valueColor: "#1A202C"
    property color subColor: "#6B7280"
    property int radius: 5

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    implicitWidth: 540
    implicitHeight: _grid.implicitHeight + 2

    Rectangle {
        anchors.fill: parent
        radius: control.radius
        color: control.background
        border.color: control.borderColor
        border.width: 1
        clip: true

        GridLayout {
            id: _grid
            anchors.fill: parent
            anchors.margins: 1
            columns: control.columns
            rowSpacing: 1
            columnSpacing: 1

            Repeater {
                model: control.model

                delegate: Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: _cell.implicitHeight + control.cellPadding * 2
                    color: control.cellBackground

                    ColumnLayout {
                        id: _cell
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.leftMargin: control.cellPadding + 2
                        anchors.rightMargin: control.cellPadding + 2
                        anchors.topMargin: control.cellPadding
                        spacing: 4

                        Text {
                            text: modelData && modelData.key !== undefined ? String(modelData.key) : ""
                            color: control.keyColor
                            font.family: control.fontFamilyMono
                            font.pixelSize: 10
                            font.letterSpacing: 1.3
                            font.capitalization: Font.AllUppercase
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }

                        Text {
                            text: modelData && modelData.value !== undefined ? String(modelData.value) : ""
                            color: control.valueColor
                            font.family: control.fontFamilyUI
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            renderType: Text.NativeRendering
                            antialiasing: true
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        Text {
                            visible: modelData && modelData.sub !== undefined && String(modelData.sub) !== ""
                            text: modelData && modelData.sub !== undefined ? String(modelData.sub) : ""
                            color: control.subColor
                            font.family: control.fontFamilyUI
                            font.pixelSize: 11
                            renderType: Text.NativeRendering
                            antialiasing: true
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }
}
