import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 24

        P.PearlText { variant: "muted"; text: "labelMode: \"active\" — current step labelled" }
        P.StepCircles {
            Layout.fillWidth: true
            currentIndex: 1
            labelMode: "active"
            model: [
                { n: "01", label: "Welcome",   sub: "Get started" },
                { n: "02", label: "Profile",   sub: "Who you are" },
                { n: "03", label: "Clinical",  sub: "Your defaults" },
                { n: "04", label: "AI & data", sub: "Privacy" },
                { n: "05", label: "Ready",     sub: "Sample case" }
            ]
        }

        P.PearlText { variant: "muted"; text: "labelMode: \"all\" — every step labelled" }
        P.StepCircles {
            Layout.fillWidth: true
            currentIndex: 2
            labelMode: "all"
            model: [
                { n: "01", label: "Welcome",   sub: "Get started" },
                { n: "02", label: "Profile",   sub: "Who you are" },
                { n: "03", label: "Clinical",  sub: "Your defaults" },
                { n: "04", label: "AI & data", sub: "Privacy" },
                { n: "05", label: "Ready",     sub: "Sample case" }
            ]
        }

        P.PearlText { variant: "muted"; text: "labelMode: \"none\" — circles only" }
        P.StepCircles {
            Layout.fillWidth: true
            currentIndex: 3
            labelMode: "none"
            model: [
                { n: "01" }, { n: "02" }, { n: "03" }, { n: "04" }, { n: "05" }
            ]
        }
    }
}
