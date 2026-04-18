// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:88-98
// 52×52 R/L/S/I orientation marker for 3D viewports.
import QtQuick
import PearlKit 1.0

Rectangle {
    id: control

    property string rLabel: "R"
    property string lLabel: "L"
    property string sLabel: "S"
    property string iLabel: "I"
    property string centerGlyph: "\u25C9"   // ◉

    property string fontFamilyMono: Tokens.font.mono

    implicitWidth: 52
    implicitHeight: 52
    width: implicitWidth
    height: implicitHeight

    radius: 4
    color: Qt.rgba(15 / 255, 23 / 255, 42 / 255, 0.6)
    border.color: "#334155"
    border.width: 1

    // 3×3 grid of labels centered in the cube
    Grid {
        anchors.centerIn: parent
        columns: 3
        rows: 3
        rowSpacing: 0
        columnSpacing: 0

        Item { width: 13; height: 13 }

        Text {
            width: 14; height: 13
            text: control.sLabel
            color: "#CBD5E1"
            font.family: control.fontFamilyMono
            font.pixelSize: 9
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Item { width: 13; height: 13 }

        Text {
            width: 13; height: 14
            text: control.rLabel
            color: "#CBD5E1"
            font.family: control.fontFamilyMono
            font.pixelSize: 9
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Text {
            width: 14; height: 14
            text: control.centerGlyph
            color: "#2563EB"
            font.family: control.fontFamilyMono
            font.pixelSize: 12
            font.weight: Font.Bold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Text {
            width: 13; height: 14
            text: control.lLabel
            color: "#CBD5E1"
            font.family: control.fontFamilyMono
            font.pixelSize: 9
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Item { width: 13; height: 13 }

        Text {
            width: 14; height: 13
            text: control.iLabel
            color: "#CBD5E1"
            font.family: control.fontFamilyMono
            font.pixelSize: 9
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            renderType: Text.NativeRendering
            antialiasing: true
        }

        Item { width: 13; height: 13 }
    }
}
