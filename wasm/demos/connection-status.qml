import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        P.ConnectionStatus { state: "online";  caption: "\u00B7 last echo 2s ago" }
        P.ConnectionStatus { state: "offline"; caption: "\u00B7 reconnecting" }
        P.ConnectionStatus { state: "error";   caption: "\u00B7 check DICOM node" }
    }
}
