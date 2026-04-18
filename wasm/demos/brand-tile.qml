import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Size scale" }
        Row {
            spacing: 12
            P.BrandTile { tileSize: 24; iconSize: 14 }
            P.BrandTile { tileSize: 32; iconSize: 18 }
            P.BrandTile { tileSize: 48; iconSize: 26 }
            P.BrandTile { tileSize: 64; iconSize: 36 }
            P.BrandTile { tileSize: 96; iconSize: 52 }
        }

        P.PearlText { variant: "muted"; text: "Color variations" }
        Row {
            spacing: 12
            P.BrandTile { tileSize: 48; iconSize: 26 }
            P.BrandTile {
                tileSize: 48; iconSize: 26
                gradientStart: "#FEE2E2"; gradientEnd: "#FCA5A5"
                toothStroke: "#991B1B"
            }
            P.BrandTile {
                tileSize: 48; iconSize: 26
                gradientStart: "#DCFCE7"; gradientEnd: "#86EFAC"
                toothStroke: "#166534"
            }
            P.BrandTile {
                tileSize: 48; iconSize: 26
                gradientStart: "#F3E8FF"; gradientEnd: "#D8B4FE"
                toothStroke: "#6B21A8"
            }
        }
    }
}
