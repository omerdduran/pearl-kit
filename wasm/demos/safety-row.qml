import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 8
        Layout.maximumWidth: 520

        P.SafetyRow { Layout.fillWidth: true; label: "Inferior Alveolar Nerve"; value: 3.2; min: 2.0; unit: "mm" }
        P.SafetyRow { Layout.fillWidth: true; label: "Maxillary Sinus";         value: 8.1; min: 2.0; unit: "mm" }
        P.SafetyRow { Layout.fillWidth: true; label: "Adjacent Root";           value: 1.4; min: 1.5; unit: "mm" }
        P.SafetyRow { Layout.fillWidth: true; label: "Buccal Plate";            value: 0.9; min: 1.0; unit: "mm" }
    }
}
