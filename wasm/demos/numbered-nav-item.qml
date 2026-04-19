import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 1
        width: 280

        P.NumberedNavItem {
            Layout.fillWidth: true
            index: "01"; label: "Profile"; subtitle: "Name \u00B7 signature"
        }
        P.NumberedNavItem {
            Layout.fillWidth: true
            index: "02"; label: "Clinical preferences"; subtitle: "Brands \u00B7 safety"
            checked: true
        }
        P.NumberedNavItem {
            Layout.fillWidth: true
            index: "03"; label: "Viewer"; subtitle: "Layout \u00B7 tools"
        }
        P.NumberedNavItem {
            Layout.fillWidth: true
            index: "04"; label: "Privacy"; subtitle: "Compliance \u00B7 cloud"
        }
    }
}
