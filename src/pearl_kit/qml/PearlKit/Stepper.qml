import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

Item {
    id: control

    // ---- public API (all values are real; internal int scaling is hidden)
    property real from: 0
    property real to: 100
    property real value: 0
    property real stepSize: 1
    property int  decimals: 0           // 0..3
    property string suffix: ""
    property string specialValueText: "" // shown when value == from
    property bool editable: true
    property bool error: false

    // ---- default sizing
    implicitWidth: 160
    implicitHeight: 36
    activeFocusOnTab: true

    // ---- internal scaling
    readonly property int _scale: {
        const d = Math.max(0, Math.min(3, decimals))
        return Math.pow(10, d)
    }

    // forward keyboard focus to the SpinBox
    onActiveFocusChanged: if (activeFocus) _sb.forceActiveFocus()

    // ---- state resolvers
    readonly property color _borderColor: {
        if (error)             return Tokens.destructive
        if (_sb.activeFocus)   return Tokens.ring
        return Tokens.border
    }
    readonly property color _bgColor: Tokens.isLight
        ? "transparent"
        : Qt.rgba(Tokens.input.r, Tokens.input.g, Tokens.input.b, 0.3)

    T.SpinBox {
        id: _sb
        anchors.fill: parent

        from: Math.round(control.from * control._scale)
        to:   Math.round(control.to   * control._scale)
        stepSize: Math.max(1, Math.round(control.stepSize * control._scale))
        value: Math.round(control.value * control._scale)
        editable: control.editable
        wrap: false
        hoverEnabled: true
        focusPolicy: Qt.StrongFocus

        padding: 0
        topPadding: 0
        bottomPadding: 0
        leftPadding: 32
        rightPadding: 32

        font.family:    Tokens.font.ui
        font.pixelSize: Tokens.font.size.sm
        font.weight:    Tokens.font.weight.regular

        // User-initiated changes propagate back to public value
        onValueModified: {
            const unscaled = _sb.value / control._scale
            if (Math.abs(control.value - unscaled) > 0.5 / control._scale)
                control.value = unscaled
        }

        // ---- format / parse (decimals + suffix + specialValueText)
        textFromValue: function(value, locale) {
            if (control.specialValueText !== "" && value === _sb.from)
                return control.specialValueText
            const real = value / control._scale
            const formatted = Number(real).toLocaleString(locale, 'f', control.decimals)
            return formatted + control.suffix
        }

        valueFromText: function(text, locale) {
            if (control.specialValueText !== "" && text === control.specialValueText)
                return _sb.from
            let stripped = String(text).trim()
            if (control.suffix !== "" && stripped.endsWith(control.suffix))
                stripped = stripped.slice(0, -control.suffix.length).trim()
            const real = Number.fromLocaleString(locale, stripped)
            if (isNaN(real)) return _sb.value
            return Math.round(real * control._scale)
        }

        validator: control.decimals > 0 ? _doubleValidator : _intValidator

        // ---- background (Input-style rectangle)
        background: Rectangle {
            id: bg
            radius: Tokens.radius.md
            color: control._bgColor
            border.color: control._borderColor
            border.width: 1
            opacity: control.enabled ? 1.0 : 0.5

            Behavior on color        { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
            Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
        }

        // ---- contentItem (centered line edit)
        contentItem: TextInput {
            id: _te
            text: _sb.displayText
            font: _sb.font
            color: control.enabled
                ? Tokens.foreground
                : Qt.rgba(Tokens.foreground.r, Tokens.foreground.g, Tokens.foreground.b, 0.5)
            selectionColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.35)
            selectedTextColor: Tokens.foreground
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            readOnly: !_sb.editable
            validator: _sb.validator
            inputMethodHints: Qt.ImhFormattedNumbersOnly

            // focus-in: show raw value, select all
            onActiveFocusChanged: {
                if (activeFocus) {
                    const raw = (_sb.value / control._scale).toFixed(control.decimals)
                    text = raw
                    selectAll()
                } else {
                    text = Qt.binding(function() { return _sb.displayText })
                }
            }

            Keys.onEscapePressed: {
                text = Qt.binding(function() { return _sb.displayText })
                focus = false
            }
        }

        // ---- up button (right edge)
        up.indicator: Rectangle {
            x: _sb.width - width
            y: 0
            width: 32
            height: _sb.height
            radius: 0
            color: {
                if (!enabled) return "transparent"
                if (_sb.up.pressed) return Qt.rgba(Tokens.accent.r, Tokens.accent.g, Tokens.accent.b, 0.6)
                if (_sb.up.hovered) return Qt.rgba(Tokens.accent.r, Tokens.accent.g, Tokens.accent.b, 0.4)
                return "transparent"
            }
            enabled: _sb.value < _sb.to
            opacity: (control.enabled ? 1.0 : 0.5) * (enabled ? 1.0 : 0.4)

            Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }

            PearlText {
                anchors.centerIn: parent
                text: "+"
                color: Tokens.foreground
                font.pixelSize: Tokens.font.size.md
            }
        }

        // ---- down button (left edge)
        down.indicator: Rectangle {
            x: 0
            y: 0
            width: 32
            height: _sb.height
            radius: 0
            color: {
                if (!enabled) return "transparent"
                if (_sb.down.pressed) return Qt.rgba(Tokens.accent.r, Tokens.accent.g, Tokens.accent.b, 0.6)
                if (_sb.down.hovered) return Qt.rgba(Tokens.accent.r, Tokens.accent.g, Tokens.accent.b, 0.4)
                return "transparent"
            }
            enabled: _sb.value > _sb.from
            opacity: (control.enabled ? 1.0 : 0.5) * (enabled ? 1.0 : 0.4)

            Behavior on color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }

            PearlText {
                anchors.centerIn: parent
                text: "\u2212"   // minus sign (U+2212), visually heavier than hyphen
                color: Tokens.foreground
                font.pixelSize: Tokens.font.size.md
            }
        }
    }

    // Validators used by _sb.validator expression
    IntValidator {
        id: _intValidator
        bottom: _sb.from
        top:    _sb.to
    }
    DoubleValidator {
        id: _doubleValidator
        bottom: control.from
        top:    control.to
        decimals: control.decimals
        notation: DoubleValidator.StandardNotation
    }

    // ---- focus ring (Input-style: activeFocus, 3px @ ring/50, error = destructive/0.2)
    PearlFocusRing {
        target: _sb.background
        offset: 0
        ringWidth: 3
        ringColor: control.error
            ? Qt.rgba(Tokens.destructive.r, Tokens.destructive.g, Tokens.destructive.b,
                      Tokens.isLight ? 0.2 : 0.4)
            : Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: _sb.activeFocus
    }
}
