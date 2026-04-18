import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        P.FormRow {
            Layout.fillWidth: true
            label: "First name"
            P.Input { placeholderText: "Jane" }
        }
        P.FormRow {
            Layout.fillWidth: true
            label: "Email"
            hint: "We'll never share your address."
            P.Input { placeholderText: "you@example.com" }
        }
        P.FormRow {
            Layout.fillWidth: true
            label: "Password"
            error: "Password is required."
            P.Input {
                placeholderText: "••••••••"
                echoMode: TextInput.Password
                error: true
            }
        }
        P.FormRow {
            Layout.fillWidth: true
            label: "Language"
            hint: "Interface language for menus and tooltips."
            P.Select { model: ["English", "Türkçe", "Deutsch"] }
        }
        P.FormRow {
            Layout.fillWidth: true
            label: "Notifications"
            P.Toggle { }
        }
        P.FormRow {
            Layout.fillWidth: true
            label: "API key"
            enabled: false
            P.Input { text: "sk-••••••" }
        }
    }
}
