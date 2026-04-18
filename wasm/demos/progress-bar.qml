import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText { variant: "muted"; text: "Determinate — 0 / 25 / 50 / 75 / 100" }
        P.ProgressBar { Layout.preferredWidth: 360; value: 0 }
        P.ProgressBar { Layout.preferredWidth: 360; value: 25 }
        P.ProgressBar { Layout.preferredWidth: 360; value: 50 }
        P.ProgressBar { Layout.preferredWidth: 360; value: 75 }
        P.ProgressBar { Layout.preferredWidth: 360; value: 100 }

        P.PearlText { variant: "muted"; text: "Custom range — bytes 0..1024, value 640" }
        P.ProgressBar { Layout.preferredWidth: 360; from: 0; to: 1024; value: 640 }

        P.PearlText { variant: "muted"; text: "Indeterminate — sliding bar" }
        P.ProgressBar { Layout.preferredWidth: 360; indeterminate: true }

        P.PearlText { variant: "muted"; text: "Disabled" }
        P.ProgressBar { Layout.preferredWidth: 360; value: 60; enabled: false }
    }
}
