import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16

        P.SignaturePreview {
            text: "M.Kaya"
            fontFamilyCursive: "Dancing Script"
        }

        P.SignaturePreview {
            text: "A.S. Yilmaz"
            actionLabel: "CHANGE"
            fontFamilyCursive: "Dancing Script"
        }
    }
}
