import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "States" }
        Flow {
            Layout.fillWidth: true
            spacing: 16
            P.CheckBox { }
            P.CheckBox { checked: true }
            P.CheckBox { tristate: true; checkState: Qt.PartiallyChecked }
            P.CheckBox { error: true }
            P.CheckBox { error: true; checked: true }
            P.CheckBox { enabled: false }
            P.CheckBox { enabled: false; checked: true }
        }

        P.PearlText { variant: "muted"; text: "With label" }
        Row {
            spacing: 8
            P.CheckBox { id: cbNotify }
            P.PearlText {
                text: "Enable notifications"
                anchors.verticalCenter: parent.verticalCenter
                MouseArea { anchors.fill: parent; onClicked: cbNotify.toggle() }
            }
        }
    }
}
