import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    // ---- public API
    property string label: ""
    property string description: ""
    default property alias sample: _sampleSlot.data

    // Default to filling its layout cell when hosted in a GridLayout / RowLayout / ColumnLayout
    // (e.g. inside ShowcasePage's grid). No effect when parent isn't a layout.
    Layout.fillWidth: true

    // ---- chrome — token-derived only
    readonly property int _padding: Tokens.space.x5
    readonly property int _gap: Tokens.space.x3

    implicitWidth: 280
    implicitHeight: 2 * _padding + _column.implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: Tokens.radius.md
        color: Tokens.card
        border.color: Tokens.border
        border.width: 1
        opacity: control.enabled ? 1.0 : 0.5
    }

    Column {
        id: _column
        x: control._padding
        y: control._padding
        width: parent.width - 2 * control._padding
        spacing: control._gap

        Item {
            id: _sampleSlot
            width: parent.width
            implicitHeight: children.length > 0 ? childrenRect.height : 0
            height: implicitHeight
        }

        Item {
            id: _footerHost
            visible: control.label !== "" || control.description !== ""
            width: parent.width
            implicitHeight: _divider.height + control._gap + _footerColumn.implicitHeight
            height: implicitHeight

            Rectangle {
                id: _divider
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 1
                color: Tokens.border
                opacity: 0.5
            }

            Column {
                id: _footerColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: _divider.bottom
                anchors.topMargin: control._gap
                spacing: 2

                PearlText {
                    width: parent.width
                    visible: control.label !== ""
                    text: control.label
                    variant: "label"
                    elide: Text.ElideRight
                }

                PearlText {
                    width: parent.width
                    visible: control.description !== ""
                    text: control.description
                    variant: "muted"
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
