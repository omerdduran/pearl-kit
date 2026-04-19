import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        P.PearlText { variant: "muted"; text: "Default — ON / OFF" }
        Row {
            spacing: 24
            P.StatusToggle { checked: true }
            P.StatusToggle { checked: false }
        }

        P.PearlText { variant: "muted"; text: "Custom labels — Enabled / Disabled" }
        Row {
            spacing: 24
            P.StatusToggle { checked: true;  labelOn: "Enabled"; labelOff: "Disabled" }
            P.StatusToggle { checked: false; labelOn: "Enabled"; labelOff: "Disabled" }
        }
    }
}
