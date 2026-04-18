import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.MenuItem {
    id: control

    property url iconSource: ""
    property string shortcut: ""
    property string variant: "default"
    property bool radio: false
    property bool inset: false

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus

    padding: 0
    leftPadding: Tokens.space.x2
    rightPadding: Tokens.space.x2
    topPadding: 6
    bottomPadding: 6
    spacing: Tokens.space.x2

    implicitWidth: Math.max(
        implicitBackgroundWidth + leftInset + rightInset,
        implicitContentWidth + leftPadding + rightPadding
    )
    implicitHeight: 32

    readonly property bool _active: control.highlighted || control.hovered
    readonly property bool _destructive: control.variant === "destructive"
    readonly property bool _showIndicatorZone: control.checkable || control.inset
    readonly property color _bg: {
        if (!control._active) return "transparent"
        if (control._destructive)
            return Qt.rgba(Tokens.destructive.r, Tokens.destructive.g, Tokens.destructive.b, 0.1)
        return Tokens.accent
    }
    readonly property color _fg: {
        if (control._destructive) return Tokens.destructive
        if (control._active)      return Tokens.accentForeground
        return Tokens.popoverForeground
    }

    background: Rectangle {
        radius: Tokens.radius.sm
        color: control._bg
        opacity: control.enabled ? 1.0 : 0.5
        Behavior on color {
            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
    }

    contentItem: RowLayout {
        spacing: Tokens.space.x2
        opacity: control.enabled ? 1.0 : 0.5

        Item {
            visible: control._showIndicatorZone
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16

            PearlCheckIcon {
                anchors.fill: parent
                visible: control.checkable && control.checked && !control.radio
                mode: "check"
                strokeColor: control._fg
                strokeWidth: 2.0
            }

            Rectangle {
                anchors.centerIn: parent
                visible: control.checkable && control.checked && control.radio
                width: 8
                height: 8
                radius: 9999
                color: control._fg
            }
        }

        Image {
            source: control.iconSource
            visible: control.iconSource != ""
            sourceSize: Qt.size(16, 16)
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
            fillMode: Image.PreserveAspectFit
        }

        PearlBaseText {
            text: control.text
            textFormat: Text.StyledText
            color: control._fg
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        PearlBaseText {
            text: control.shortcut
            visible: control.shortcut !== ""
            color: Tokens.mutedForeground
            font.pixelSize: Tokens.font.size.xs
            font.letterSpacing: 2.4
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        PearlChevron {
            visible: control.subMenu !== null
            direction: "right"
            strokeColor: control._fg
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
        }
    }
}
