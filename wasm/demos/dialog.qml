import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText { variant: "muted"; text: "Click any button to open the dialog" }
        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.Button { text: "Simple dialog"; onClicked: simpleDialog.open() }
            P.Button { text: "Confirm destructive"; variant: "outline"; onClicked: confirmDialog.open() }
            P.Button { text: "No close button"; variant: "ghost"; onClicked: noCloseDialog.open() }
        }
    }

    P.Dialog {
        id: simpleDialog
        title: "Welcome"
        description: "Simple dialog with title, description, close button."
        Text {
            text: "Body content goes here — anything passed as a child of Dialog lands in the body column, spaced at 16 px."
            color: P.Tokens.foreground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.sm
            wrapMode: Text.WordWrap
            width: 460
        }
    }

    P.Dialog {
        id: confirmDialog
        title: "Delete file?"
        description: "This action cannot be undone. The file will be permanently removed."
        footer: Row {
            spacing: 8
            layoutDirection: Qt.RightToLeft
            P.Button { text: "Delete"; variant: "destructive"; onClicked: confirmDialog.close() }
            P.Button { text: "Cancel"; variant: "outline"; onClicked: confirmDialog.close() }
        }
    }

    P.Dialog {
        id: noCloseDialog
        title: "Forced choice"
        description: "No X button — you must pick one of the options below."
        showCloseButton: false
        footer: Row {
            spacing: 8
            layoutDirection: Qt.RightToLeft
            P.Button { text: "Accept"; onClicked: noCloseDialog.close() }
            P.Button { text: "Decline"; variant: "outline"; onClicked: noCloseDialog.close() }
        }
    }
}
