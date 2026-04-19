import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 18

        P.StorageBar {
            Layout.preferredWidth: 360
            used: 412
            total: 1247
            topLabel: "412 GB used \u00B7 1,247 cases"
            bottomLabel: "876 GB available \u00B7 1.2 TB total"
        }

        P.StorageBar {
            Layout.preferredWidth: 360
            used: 1100
            total: 1247
            topLabel: "1.1 TB used \u00B7 1,247 cases"
            bottomLabel: "147 GB available \u00B7 archive recommended"
        }
    }
}
