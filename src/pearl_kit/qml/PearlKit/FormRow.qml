import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    // ---- public API
    property string label: ""
    property string hint: ""
    property string error: ""
    property int labelWidth: 120

    default property alias content: _slot.data

    // ---- helpers
    readonly property bool _hasError: control.error.length > 0
    readonly property bool _hasMeta: _hasError || control.hint.length > 0

    // ---- geometry
    implicitWidth: _grid.implicitWidth
    implicitHeight: _grid.implicitHeight

    GridLayout {
        id: _grid
        anchors.fill: parent
        columns: 2
        columnSpacing: Tokens.space.x3
        rowSpacing: Tokens.space.x1

        // Row 0, Col 0 — label
        PearlText {
            id: _labelText
            Layout.row: 0
            Layout.column: 0
            Layout.preferredWidth: control.labelWidth
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            variant: "label"
            text: control.label
            wrapMode: Text.WordWrap

            readonly property color _base: control._hasError
                ? Tokens.destructive
                : Tokens.foreground
            color: control.enabled
                ? _base
                : Qt.rgba(_base.r, _base.g, _base.b, 0.5)

            Behavior on color {
                ColorAnimation {
                    duration: Tokens.motion.fast
                }
            }
        }

        // Row 0, Col 1 — input slot
        Item {
            id: _slot
            Layout.row: 0
            Layout.column: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            implicitHeight: children.length > 0 ? children[0].implicitHeight : 0

            onChildrenChanged: _bindFirstChildWidth()
            Component.onCompleted: _bindFirstChildWidth()

            function _bindFirstChildWidth() {
                if (children.length > 0) {
                    children[0].width = Qt.binding(function () {
                        return _slot.width;
                    });
                }
            }
        }

        // Row 1, Col 1 — hint or error (column 0 left empty intentionally)
        PearlText {
            id: _metaText
            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: true
            variant: "muted"
            text: control._hasError ? control.error : control.hint
            visible: control._hasMeta
            wrapMode: Text.WordWrap

            readonly property color _base: control._hasError
                ? Tokens.destructive
                : Tokens.mutedForeground
            color: control.enabled
                ? _base
                : Qt.rgba(_base.r, _base.g, _base.b, 0.5)

            Behavior on color {
                ColorAnimation {
                    duration: Tokens.motion.fast
                }
            }
        }
    }
}
