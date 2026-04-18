import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText { variant: "muted"; text: "Four variants, each with its own glyph" }
        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.Button { text: "Info";    onClicked: mbInfo.open() }
            P.Button { text: "Warning"; variant: "secondary";   onClicked: mbWarning.open() }
            P.Button { text: "Error";   variant: "destructive"; onClicked: mbError.open() }
            P.Button { text: "Confirm"; variant: "outline";     onClicked: mbConfirm.open() }
        }
    }

    P.MessageBox {
        id: mbInfo
        variant: "info"
        heading: "Saved successfully"
        message: "Your changes have been written to the project file."
    }
    P.MessageBox {
        id: mbWarning
        variant: "warning"
        heading: "Unsaved changes"
        message: "You have unsaved work. Switching projects will discard these edits."
    }
    P.MessageBox {
        id: mbError
        variant: "error"
        heading: "Failed to load file"
        message: "The file is corrupted or uses an unsupported format."
    }
    P.MessageBox {
        id: mbConfirm
        variant: "confirm"
        heading: "Delete annotation?"
        message: "This will permanently remove the implant placement from the current case."
        okText: "Delete"
        okVariant: "destructive"
        cancelText: "Keep"
    }
}
