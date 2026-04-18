import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.Stepper {
            Layout.preferredWidth: 200
            from: 0; to: 100
            value: 50
            suffix: "%"
        }
        P.Stepper {
            Layout.preferredWidth: 200
            from: 0; to: 10
            decimals: 2
            stepSize: 0.1
            value: 2.5
            suffix: " mm"
        }
        P.Stepper {
            Layout.preferredWidth: 200
            from: 0; to: 1000
            specialValueText: "Auto"
        }
        P.Stepper {
            Layout.preferredWidth: 200
            error: true
            value: 42
        }
        P.Stepper {
            Layout.preferredWidth: 200
            enabled: false
            value: 12
            suffix: " px"
        }
    }
}
