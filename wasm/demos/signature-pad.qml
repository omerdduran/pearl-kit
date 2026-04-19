import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 18

        P.PearlText { variant: "muted"; text: "Unsigned — dashed grey, mono placeholder" }
        P.SignaturePad {
            Layout.fillWidth: true
            signed: false
        }

        P.PearlText { variant: "muted"; text: "Signed — accent border + cursive name" }
        P.SignaturePad {
            id: signed
            Layout.fillWidth: true
            signed: true
            signatureText: "M.Kaya"
            onRequestRedraw: signed = !signed
        }
    }
}
