import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

// shadcn-flavored radio: 18px circular indicator + filled inner dot, with an
// inline label (unlike CheckBox, which is label-less — radios in DALI carry
// their own `text`). autoExclusive / ButtonGroup come free from T.RadioButton.
T.RadioButton {
    id: control

    // ---- public API
    property bool error: false

    // ---- Qt template internals
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    spacing: 8

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             Math.max(implicitContentHeight, implicitIndicatorHeight)
                             + topPadding + bottomPadding)

    // ---- state resolvers (CheckBox parity, circular)
    readonly property color _borderColor: {
        if (error)   return Tokens.destructive
        if (checked) return Tokens.primary
        return Tokens.input
    }
    readonly property color _bgColor: {
        if (checked)        return Tokens.primary
        if (Tokens.isLight) return "transparent"
        return Qt.rgba(Tokens.input.r, Tokens.input.g, Tokens.input.b, 0.3)
    }

    // ---- indicator (18x18 circle + inner filled dot when checked)
    indicator: Rectangle {
        x: 0
        y: (control.height - height) / 2
        implicitWidth: 18
        implicitHeight: 18
        width: 18
        height: 18
        radius: width / 2
        color: control._bgColor
        border.color: control._borderColor
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5

        Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
        Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }

        Rectangle {
            anchors.centerIn: parent
            width: 8
            height: 8
            radius: width / 2
            color: Tokens.primaryForeground
            visible: control.checked
            scale: control.checked ? 1.0 : 0.0
            Behavior on scale { NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutBack } }
        }
    }

    // ---- contentItem (inline label, vertically aligned with the indicator)
    contentItem: PearlBaseText {
        text: control.text
        visible: control.text !== ""
        leftPadding: control.indicator.width + control.spacing
        verticalAlignment: Text.AlignVCenter
        font.weight: Tokens.font.weight.regular
        opacity: control.enabled ? 1.0 : 0.5
    }

    // ---- focus ring (shadcn 3px @ ring/50, keyboard-only)
    PearlFocusRing {
        target: control.indicator
        offset: 0
        ringWidth: 3
        ringColor: control.error
            ? Qt.rgba(Tokens.destructive.r, Tokens.destructive.g, Tokens.destructive.b,
                      Tokens.isLight ? 0.2 : 0.4)
            : Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
