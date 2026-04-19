import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        P.FeatureBullet {
            Layout.fillWidth: true
            title: "AI segmentation"
            description: "Bones, nerves, sinuses auto-detected from CBCT volumes."
        }

        P.FeatureBullet {
            Layout.fillWidth: true
            title: "Safety thresholds"
            description: "Per-structure clearance bands flag sub-min plans."
        }

        P.FeatureBullet {
            Layout.fillWidth: true
            title: "Guide export"
            description: "STL surgical guides direct to milling vendors."
        }

        P.FeatureBullet {
            Layout.fillWidth: true
            title: "Title-only bullet"
        }
    }
}
