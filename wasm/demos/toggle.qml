import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Default size" }
        Flow {
            Layout.fillWidth: true
            spacing: 16
            P.Toggle { }
            P.Toggle { checked: true }
            P.Toggle { enabled: false }
            P.Toggle { enabled: false; checked: true }
        }

        P.PearlText { variant: "muted"; text: "Small size" }
        Flow {
            Layout.fillWidth: true
            spacing: 16
            P.Toggle { size: "sm" }
            P.Toggle { size: "sm"; checked: true }
            P.Toggle { size: "sm"; enabled: false }
            P.Toggle { size: "sm"; enabled: false; checked: true }
        }
    }
}
