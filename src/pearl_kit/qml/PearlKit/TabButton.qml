import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.TabButton {
    id: control

    // ---- public API
    property url iconSource: ""
    property bool closable: false
    signal closeRequested()

    // ---- Qt template internals
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    leftPadding: 8
    rightPadding: 8
    topPadding: 4
    bottomPadding: 4

    // ---- parent TabBar lookup for variant / expanding / spacing awareness
    readonly property Item _bar: T.TabBar.tabBar
    readonly property bool _lineVariant: _bar && _bar.variant === "line"
    readonly property bool _expanding: !_bar || _bar.expanding

    implicitHeight: _lineVariant ? 30 : 29
    implicitWidth: Math.max(implicitContentWidth + leftPadding + rightPadding, 60)

    // Override T.TabBar's default fillItems behavior when consumer wants content-sized tabs.
    Binding on width {
        when: control._bar !== null && !control._expanding
        value: control.implicitWidth
        restoreMode: Binding.RestoreBindingOrValue
    }

    // ---- text color (shadcn: idle text-foreground/60, hover/active text-foreground, disabled /50)
    readonly property color _textColor: {
        if (!enabled) return Qt.rgba(Tokens.foreground.r, Tokens.foreground.g, Tokens.foreground.b, 0.5)
        if (checked || hovered) return Tokens.foreground
        return Qt.rgba(Tokens.foreground.r, Tokens.foreground.g, Tokens.foreground.b, 0.6)
    }

    // ---- background (variant-aware)
    background: Rectangle {
        color: !control._lineVariant && control.checked ? Tokens.background : "transparent"
        radius: control._lineVariant ? 0 : Tokens.radius.md
        border.color: "transparent"
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5

        // shadcn shadow-sm approximation on active default variant — subtle hairline at bottom
        Rectangle {
            visible: !control._lineVariant && control.checked
            anchors.fill: parent
            anchors.topMargin: 1
            radius: parent.radius
            color: "transparent"
            border.color: Qt.rgba(0, 0, 0, 0.06)
            border.width: 1
            z: -1
        }

        // Line variant underline (shadcn after:h-0.5 after:bg-foreground)
        Rectangle {
            id: _underline
            visible: control._lineVariant
            opacity: control.checked ? 1.0 : 0.0
            height: 2
            color: Tokens.foreground
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -1
            Behavior on opacity {
                NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        Behavior on color {
            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
    }

    // ---- content row: icon + label + optional close ×
    contentItem: Row {
        spacing: 6
        opacity: control.enabled ? 1.0 : 0.5

        Image {
            source: control.iconSource
            visible: control.iconSource != ""
            sourceSize: Qt.size(16, 16)
            width: 16
            height: 16
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
        }

        PearlBaseText {
            id: _label
            text: control.text
            visible: control.text !== ""
            color: control._textColor
            font.weight: Tokens.font.weight.medium
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        Item {
            id: _closeSlot
            visible: control.closable
            width: 12
            height: 12
            anchors.verticalCenter: parent.verticalCenter

            PearlXIcon {
                anchors.fill: parent
                strokeColor: _closeMouse.containsMouse
                    ? Tokens.foreground
                    : Qt.rgba(Tokens.foreground.r, Tokens.foreground.g, Tokens.foreground.b, 0.6)
                strokeWidth: 1.5
            }

            MouseArea {
                id: _closeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                preventStealing: true
                acceptedButtons: Qt.LeftButton
                onPressed: (ev) => { ev.accepted = true }
                onClicked: (ev) => {
                    ev.accepted = true
                    control.closeRequested()
                }
            }
        }
    }

    // ---- focus ring (shadcn 3px @ ring/50, keyboard-only)
    PearlFocusRing {
        target: control
        offset: 0
        ringWidth: 3
        ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
