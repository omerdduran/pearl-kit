import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

Dialog {
    id: control

    property string variant: "info"
    property string heading: ""
    property string message: ""
    property string okText: "OK"
    property string cancelText: "Cancel"
    property string okVariant: variant === "error" ? "destructive" : "default"

    signal accepted()
    signal rejected()

    title: ""
    description: ""
    showCloseButton: false
    maxWidth: 420
    closePolicy: variant === "confirm"
        ? T.Popup.CloseOnEscape
        : (T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside)

    property Item _okButton: null

    QtObject {
        id: _state
        property bool resolved: false
    }

    onOpened: {
        _state.resolved = false
        if (_okButton)
            _okButton.forceActiveFocus()
    }
    onClosed: {
        if (!_state.resolved && control.variant === "confirm")
            control.rejected()
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 12

        PearlAlertIcon {
            Layout.alignment: Qt.AlignLeft
            variant: control.variant
        }

        PearlBaseText {
            visible: control.heading !== ""
            text: control.heading
            Layout.fillWidth: true
            font.pixelSize: Tokens.font.size.lg
            font.weight: Tokens.font.weight.semibold
            color: Tokens.foreground
            wrapMode: Text.WordWrap
        }

        PearlBaseText {
            visible: control.message !== ""
            text: control.message
            Layout.fillWidth: true
            font.pixelSize: Tokens.font.size.sm
            font.weight: Tokens.font.weight.regular
            color: Tokens.mutedForeground
            wrapMode: Text.WordWrap
        }
    }

    footer: Row {
        spacing: 8
        layoutDirection: Qt.RightToLeft

        Button {
            text: control.okText
            variant: control.okVariant
            Component.onCompleted: control._okButton = this
            onClicked: {
                _state.resolved = true
                control.accepted()
                control.close()
            }
        }

        Button {
            visible: control.variant === "confirm"
            text: control.cancelText
            variant: "outline"
            onClicked: {
                _state.resolved = true
                control.rejected()
                control.close()
            }
        }
    }
}
