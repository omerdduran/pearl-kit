import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText { variant: "muted"; text: "Sizes (sm 24 / default 32 / lg 40)" }
        RowLayout {
            spacing: 12
            P.Avatar { size: "sm";      initials: "OD" }
            P.Avatar { size: "default"; initials: "OD" }
            P.Avatar { size: "lg";      initials: "OD" }
        }

        P.PearlText { variant: "muted"; text: "Role variants" }
        RowLayout {
            spacing: 12
            P.Avatar { variant: "default";   initials: "?" }
            P.Avatar { variant: "primary";   initials: "AI" }
            P.Avatar { variant: "secondary"; initials: "OD" }
        }

        P.PearlText { variant: "muted"; text: "Chat layout — assistant vs user" }
        ColumnLayout {
            spacing: 8
            RowLayout {
                spacing: 8
                P.Avatar { variant: "primary"; initials: "AI" }
                P.PearlText {
                    Layout.preferredWidth: 420
                    wrapMode: Text.WordWrap
                    text: "Sure — here's how you can wire an Avatar into your chat UI."
                }
            }
            RowLayout {
                spacing: 8
                P.Avatar { variant: "secondary"; initials: "OD" }
                P.PearlText {
                    Layout.preferredWidth: 420
                    wrapMode: Text.WordWrap
                    text: "How do I build a chat view with a role indicator on each row?"
                }
            }
        }

        P.PearlText { variant: "muted"; text: "Disabled (50% opacity)" }
        RowLayout {
            spacing: 12
            P.Avatar { enabled: false; initials: "OD" }
            P.Avatar { enabled: false; variant: "primary"; initials: "AI" }
        }
    }
}
