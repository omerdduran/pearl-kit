import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    id: root

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12
        width: Math.min(parent.width - 48, 520)

        P.PearlText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            variant: "title"
            text: "pearl-kit"
        }

        P.PearlText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            variant: "muted"
            text: "Interactive component gallery — open this URL with "
                + "?demo=<component> to preview a specific primitive. "
                + "See the navigation on pearl-kit's docs site for the full list."
        }

        Flow {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            P.Badge { text: "button"   }
            P.Badge { text: "input"    ; variant: "outline" }
            P.Badge { text: "toggle"   ; variant: "outline" }
            P.Badge { text: "select"   ; variant: "outline" }
            P.Badge { text: "dialog"   ; variant: "outline" }
            P.Badge { text: "tabbar"   ; variant: "outline" }
            P.Badge { text: "+25 more" ; variant: "secondary" }
        }
    }
}
