import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Default R/L/S/I" }
        Row {
            spacing: 16
            P.OrientationCube { }
            P.OrientationCube { centerGlyph: "△" }
            P.OrientationCube { centerGlyph: "◆" }
        }

        P.PearlText {
            variant: "muted"
            Layout.preferredWidth: 420
            wrapMode: Text.WordWrap
            text: "Drop into any Viewport2D / Render3D corner as an anatomical orientation marker — right / left / superior / inferior around a centered glyph."
        }
    }
}
