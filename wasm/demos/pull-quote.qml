import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 24
        Layout.maximumWidth: 560

        P.PullQuote {
            Layout.fillWidth: true
            text: "Proper implant placement is fundamental to long-term success and patient satisfaction — the surgical plan is the product."
        }

        P.PullQuote {
            Layout.fillWidth: true
            text: "A rushed scan is a plan rewritten twice."
        }
    }
}
