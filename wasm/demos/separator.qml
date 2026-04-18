import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText { variant: "body"; text: "Rows split by horizontal separators" }
        P.Separator { Layout.fillWidth: true }
        P.PearlText { variant: "muted"; text: "Second row — note the 1 px divider above." }
        P.Separator { Layout.fillWidth: true }
        P.PearlText { variant: "muted"; text: "Third row." }

        Row {
            spacing: 12
            height: 24
            P.PearlText { text: "File"; anchors.verticalCenter: parent.verticalCenter }
            P.Separator { orientation: "vertical"; height: parent.height }
            P.PearlText { text: "Edit"; anchors.verticalCenter: parent.verticalCenter }
            P.Separator { orientation: "vertical"; height: parent.height }
            P.PearlText { text: "View"; anchors.verticalCenter: parent.verticalCenter }
        }
    }
}
