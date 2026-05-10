// Source: design_handoff_planning_workspace/src/report-tab.jsx:295-325
// PACS-style dense table. Header mono 9.5px on #FAFBFC; rows mono 11.5px
// on white. Consumer provides column defs and a flat rows array. Cell color
// / weight overrides come through per-row keys: `<col>Color`, `<col>Weight`.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    // columns: [{ key, label, align?: "left"|"center"|"right", mono?: bool, width?: int, elide?: int }]
    // `elide` accepts Text.ElideNone / ElideLeft / ElideMiddle / ElideRight
    // (defaults to Text.ElideRight). Cell text is constrained to its
    // column width and elided when overflowing.
    property var columns: []
    property var rows: []

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    property color borderColor: "#E2E8F0"
    property color headerBg: "#FAFBFC"
    property color rowBorderColor: "#F1F5F9"
    property color headerColor: "#6B7280"
    property color cellColor: "#1A202C"
    // Frame fill (the table's outer rectangle) and per-row body fill.
    // Exposed so consumers can theme dark / light without forking — the
    // hardcoded "#FFFFFF" default keeps existing call sites unchanged.
    property color bgColor: "#FFFFFF"
    property color rowBg: "#FFFFFF"

    property int headerHeight: 30
    property int rowHeight: 32

    implicitWidth: 640
    implicitHeight: headerHeight + rowHeight * rows.length + 2

    Rectangle {
        id: _frame
        anchors.fill: parent
        radius: 4
        color: control.bgColor
        border.color: control.borderColor
        border.width: 1
        clip: true

        Column {
            anchors.fill: parent
            anchors.margins: 1
            spacing: 0

            // Header row
            Rectangle {
                width: parent.width
                height: control.headerHeight
                color: control.headerBg

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Repeater {
                        model: control.columns

                        delegate: Item {
                            readonly property var _col: modelData
                            readonly property string _align: (_col && _col.align) ? _col.align : "left"
                            readonly property int _colWidth: (_col && _col.width !== undefined) ? _col.width : 0

                            Layout.preferredWidth: _colWidth
                            Layout.fillWidth: _colWidth <= 0
                            Layout.fillHeight: true

                            Text {
                                text: _col && _col.label ? _col.label : ""
                                color: control.headerColor
                                font.family: control.fontFamilyMono
                                font.pixelSize: 10
                                font.letterSpacing: 1.0
                                font.capitalization: Font.AllUppercase
                                font.weight: Font.Medium
                                renderType: Text.NativeRendering
                                antialiasing: true
                                anchors.fill: parent
                                anchors.leftMargin: parent._align === "right" ? 0 : 10
                                anchors.rightMargin: parent._align === "right" ? 10 : 0
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: parent._align === "right"
                                    ? Text.AlignRight
                                    : (parent._align === "center" ? Text.AlignHCenter : Text.AlignLeft)
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: control.borderColor
                }
            }

            // Body rows
            Repeater {
                model: control.rows

                delegate: Rectangle {
                    readonly property var _row: modelData
                    width: parent.width
                    height: control.rowHeight
                    color: control.rowBg

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Repeater {
                            model: control.columns

                            delegate: Item {
                                readonly property var _col: modelData
                                readonly property string _key: (_col && _col.key) ? _col.key : ""
                                readonly property bool _mono: _col ? (_col.mono !== false) : true
                                readonly property string _align: (_col && _col.align) ? _col.align : "left"
                                readonly property int _colWidth: (_col && _col.width !== undefined) ? _col.width : 0
                                readonly property int _elide: (_col && _col.elide !== undefined) ? _col.elide : Text.ElideRight

                                Layout.preferredWidth: _colWidth
                                Layout.fillWidth: _colWidth <= 0
                                Layout.fillHeight: true

                                Text {
                                    text: (_row && _key && _row[_key] !== undefined) ? String(_row[_key]) : ""
                                    color: (_row && _key && _row[_key + "Color"] !== undefined)
                                        ? _row[_key + "Color"]
                                        : control.cellColor
                                    font.family: _mono ? control.fontFamilyMono : control.fontFamilyUI
                                    font.pixelSize: 12
                                    font.weight: (_row && _key && _row[_key + "Weight"] !== undefined)
                                        ? _row[_key + "Weight"]
                                        : Font.Normal
                                    renderType: Text.NativeRendering
                                    antialiasing: true
                                    anchors.fill: parent
                                    anchors.leftMargin: parent._align === "right" ? 0 : 10
                                    anchors.rightMargin: parent._align === "right" ? 10 : 0
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: parent._align === "right"
                                        ? Text.AlignRight
                                        : (parent._align === "center" ? Text.AlignHCenter : Text.AlignLeft)
                                    elide: parent._elide
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: control.rowBorderColor
                    }
                }
            }
        }
    }
}
