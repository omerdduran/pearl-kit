import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        Layout.maximumWidth: 560

        P.SubjectCard {
            Layout.fillWidth: true
            identifier: "I2"
            tooth: "#14"
            brand: "Straumann"
            status: "ok"
            parameters: [
                { key: "Diameter", value: "4.1 mm" },
                { key: "Length",   value: "12.0 mm" },
                { key: "Grade",    value: "IV" },
                { key: "Angle",    value: "0°" }
            ]
            metrics: [
                { key: "IAN",   value: "3.2 mm",  tone: "ok" },
                { key: "Sinus", value: "8.1 mm",  tone: "ok" }
            ]
        }

        P.SubjectCard {
            Layout.fillWidth: true
            identifier: "I3"
            tooth: "#17"
            brand: "MIS"
            status: "warn"
            parameters: [
                { key: "Diameter", value: "4.1 mm" },
                { key: "Length",   value: "10.0 mm" },
                { key: "Grade",    value: "III" },
                { key: "Angle",    value: "8°" }
            ]
            metrics: [
                { key: "IAN",     value: "2.1 mm", tone: "warn" },
                { key: "Buccal",  value: "0.9 mm", tone: "warn" }
            ]
        }
    }
}
