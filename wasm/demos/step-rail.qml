import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 32

        P.StepRail {
            Layout.preferredWidth: 280
            Layout.alignment: Qt.AlignTop
            currentIndex: 2
            model: [
                { n: "01", label: "Welcome",   sub: "Get started"   },
                { n: "02", label: "Profile",   sub: "Who you are"   },
                { n: "03", label: "Clinical",  sub: "Your defaults" },
                { n: "04", label: "AI & data", sub: "Privacy"       },
                { n: "05", label: "Ready",     sub: "Sample case"   }
            ]
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            spacing: 6

            P.PearlText { variant: "muted"; text: "active row gets a soft accent halo;" }
            P.PearlText { variant: "muted"; text: "completed rows show a check; upcoming rows" }
            P.PearlText { variant: "muted"; text: "stay neutral. emits stepClicked(int)." }
        }
    }
}
