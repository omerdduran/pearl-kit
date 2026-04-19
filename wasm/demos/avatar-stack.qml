import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 24

        P.PearlText { variant: "muted"; text: "Three teammates" }
        P.AvatarStack {
            Layout.alignment: Qt.AlignHCenter
            avatars: [
                { initials: "MK", background: "#DBEAFE", foreground: "#1E3A8A" },
                { initials: "AS", background: "#FEF3C7", foreground: "#92400E" },
                { initials: "EK", background: "#D1FAE5", foreground: "#065F46" }
            ]
        }

        P.PearlText { variant: "muted"; text: "Five teammates with overflow chip" }
        P.AvatarStack {
            Layout.alignment: Qt.AlignHCenter
            avatars: [
                { initials: "MK", background: "#DBEAFE", foreground: "#1E3A8A" },
                { initials: "AS", background: "#FEF3C7", foreground: "#92400E" },
                { initials: "EK", background: "#D1FAE5", foreground: "#065F46" },
                { initials: "DT", background: "#E0E7FF", foreground: "#3730A3" },
                { initials: "+3", background: "#F1F5F9", foreground: "#475569" }
            ]
        }
    }
}
