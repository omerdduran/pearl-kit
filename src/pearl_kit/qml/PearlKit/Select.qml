import QtQuick
import QtQuick.Controls.Basic as QC
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

T.ComboBox {
    id: control

    // ---- public API
    property bool error: false
    property string size: "default"   // sm | default
    property string placeholderText: ""

    // ---- Qt template internals
    editable: false
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    leftPadding: 12
    rightPadding: 32   // chevron room
    topPadding: 8
    bottomPadding: 8
    implicitHeight: _sizing.h
    implicitWidth: Math.max(implicitContentWidth + leftPadding + rightPadding, 128)

    // ---- typography
    font.family:    Tokens.font.ui
    font.pixelSize: Tokens.font.size.sm
    font.weight:    Tokens.font.weight.regular

    // ---- size resolver
    readonly property QtObject _sizing: QtObject {
        readonly property int h: control.size === "sm" ? 32 : 36
    }

    // ---- state resolvers
    readonly property color _borderColor: {
        if (control.error)       return Tokens.destructive
        if (control.activeFocus) return Tokens.ring
        return Tokens.border
    }
    readonly property color _bgColor: {
        if (Tokens.isLight) return "transparent"
        const base = Tokens.input
        const alpha = control.hovered ? 0.5 : 0.3
        return Qt.rgba(base.r, base.g, base.b, alpha)
    }

    // ---- last valid index (for header/separator guard)
    property int _lastValidIndex: 0

    function _rowType(i) {
        if (i < 0 || i >= count) return "item"
        const src = model
        if (!src) return "item"
        if (typeof src === "object" && src.get) {
            const el = src.get(i)
            return el && el.type ? el.type : "item"
        }
        const plain = src[i]
        if (plain && typeof plain === "object" && plain.type)
            return plain.type
        return "item"
    }

    Component.onCompleted: {
        for (let i = 0; i < count; ++i) {
            if (_rowType(i) === "item") { _lastValidIndex = i; currentIndex = i; break }
        }
    }

    onActivated: function(index) {
        const t = _rowType(index)
        if (t === "item") {
            _lastValidIndex = index
        } else {
            currentIndex = _lastValidIndex
        }
    }

    // ---- background
    background: Rectangle {
        radius: Tokens.radius.md
        color: control._bgColor
        border.color: control._borderColor
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5

        Behavior on color        { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
        Behavior on border.color { ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic } }
    }

    // ---- contentItem (selected value display)
    contentItem: PearlText {
        leftPadding: 0
        rightPadding: 0
        text: control.currentIndex === -1 ? control.placeholderText : control.displayText
        color: control.currentIndex === -1
            ? (control.enabled ? Tokens.mutedForeground
                               : Qt.rgba(Tokens.mutedForeground.r, Tokens.mutedForeground.g, Tokens.mutedForeground.b, 0.5))
            : (control.enabled ? Tokens.foreground
                               : Qt.rgba(Tokens.foreground.r, Tokens.foreground.g, Tokens.foreground.b, 0.5))
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // ---- indicator (chevron)
    indicator: PearlChevron {
        x: control.width - width - 12
        y: (control.height - height) / 2
        width: 16
        height: 16
        strokeColor: Tokens.mutedForeground
        opacity: (control.enabled ? 1.0 : 0.5) * 0.5
    }

    // ---- popup
    popup: T.Popup {
        x: 0
        y: control.height + 4
        width: Math.max(control.width, 128)
        implicitHeight: Math.min(
            (contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding,
            320
        )
        padding: 4

        background: Rectangle {
            color: Tokens.popover
            radius: Tokens.radius.md
            border.color: Tokens.border
            border.width: 1
        }

        contentItem: ListView {
            id: listView
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            QC.ScrollIndicator.vertical: QC.ScrollIndicator { }
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale";   from: 0.95; to: 1.0; duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
    }

    // ---- delegate (item | header | separator via type role)
    delegate: T.ItemDelegate {
        id: item
        width: ListView.view ? ListView.view.width : implicitWidth

        readonly property string _type: {
            if (model && model.type !== undefined) return model.type
            if (modelData && typeof modelData === "object" && modelData.type !== undefined) return modelData.type
            return "item"
        }
        readonly property bool _isHeader:    _type === "header"
        readonly property bool _isSeparator: _type === "separator"
        readonly property bool _isItem:      !_isHeader && !_isSeparator
        readonly property string _label: {
            if (modelData !== undefined && typeof modelData !== "object") return modelData
            const role = control.textRole !== "" ? control.textRole : "text"
            if (model && model[role] !== undefined) return model[role]
            if (modelData && typeof modelData === "object" && modelData[role] !== undefined) return modelData[role]
            return ""
        }

        height: _isSeparator ? 9 : (_isHeader ? 28 : 32)
        padding: 0
        leftPadding: 8
        rightPadding: _isItem ? 32 : 8
        topPadding: _isSeparator ? 4 : 6
        bottomPadding: _isSeparator ? 4 : 6

        enabled: _isItem
        hoverEnabled: _isItem

        readonly property bool _active: _isItem && (ListView.isCurrentItem || hovered)

        background: Rectangle {
            radius: Tokens.radius.sm
            color: item._active ? Tokens.accent : "transparent"
            visible: !item._isSeparator
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        contentItem: Item {
            implicitWidth: _rowLabel.implicitWidth
            implicitHeight: item.height - item.topPadding - item.bottomPadding

            PearlText {
                id: _rowLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                visible: !item._isSeparator
                text: item._label
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: item._isHeader ? Tokens.font.size.xs : Tokens.font.size.sm
                font.weight: item._isHeader ? Tokens.font.weight.medium : Tokens.font.weight.regular
                color: item._isHeader
                    ? Tokens.mutedForeground
                    : (item._active ? Tokens.accentForeground : Tokens.popoverForeground)
            }

            Rectangle {
                visible: item._isSeparator
                height: 1
                color: Tokens.border
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: -4
                anchors.rightMargin: -4
            }

            Rectangle {
                visible: item._isItem && control.currentIndex === index
                width: 4
                height: 4
                radius: 2
                color: item._active ? Tokens.accentForeground : Tokens.foreground
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // ---- focus ring (keyboard-only, shadcn parity)
    PearlFocusRing {
        target: control
        offset: 0
        ringWidth: 3
        ringColor: control.error
            ? Qt.rgba(Tokens.destructive.r, Tokens.destructive.g, Tokens.destructive.b, 0.2)
            : Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
        visible: control.visualFocus
    }
}
