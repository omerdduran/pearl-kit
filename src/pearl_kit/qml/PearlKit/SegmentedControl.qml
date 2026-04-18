// Source:
//   planning-viewer.jsx:231-254 (pill variant — mode tabs)
//   report-tab.jsx:51-72        (bordered variant — variant switcher)
//   planning-viewer.jsx:407-416 (solid variant — length grid)
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    // options: [{ key: string, label: string }]
    property var options: []
    property string current: ""
    property string variant: "pill"       // "pill" | "bordered" | "solid"
    property int columns: 0               // 0 = flow row; >0 = grid columns
    property string fontFamily: Tokens.font.mono
    property int fontPixelSize: 11
    property real letterSpacing: 0.04 * fontPixelSize

    signal changed(string key)

    readonly property bool _isPill: variant === "pill"
    readonly property bool _isBordered: variant === "bordered"
    readonly property bool _isSolid: variant === "solid"

    implicitWidth: _grid.implicitWidth + (_isPill ? 4 : 0)
    implicitHeight: _grid.implicitHeight + (_isPill ? 4 : 0)

    Rectangle {
        anchors.fill: parent
        radius: control._isPill ? 6 : (control._isBordered ? 4 : 3)
        color: control._isPill ? "#F1F5F9" : "transparent"
        border.color: control._isBordered ? "#E2E8F0" : "transparent"
        border.width: control._isBordered ? 1 : 0
    }

    GridLayout {
        id: _grid
        columns: control.columns > 0 ? control.columns : Math.max(1, control.options.length)
        columnSpacing: control._isSolid ? 3 : 0
        rowSpacing: control._isSolid ? 3 : 0
        anchors.centerIn: parent

        Repeater {
            model: control.options

            Rectangle {
                id: _cell
                readonly property string _key: modelData && modelData.key !== undefined ? modelData.key : String(modelData)
                readonly property string _label: modelData && modelData.label !== undefined ? modelData.label : _key
                readonly property bool _active: control.current === _key

                Layout.fillWidth: control.columns > 0
                implicitWidth: _text.implicitWidth + (control._isPill ? 28 : (control._isBordered ? 22 : 14))
                implicitHeight: control._isPill ? 24 : (control._isBordered ? 24 : 22)

                radius: control._isPill ? 4 : (control._isSolid ? 3 : 0)
                color: {
                    if (control._isPill)     return _cell._active ? "#FFFFFF" : "transparent"
                    if (control._isBordered) return _cell._active ? "#1A202C" : "transparent"
                    return _cell._active ? "#2563EB" : "#F1F5F9"
                }

                border.color: control._isBordered && index !== 0 ? "#E2E8F0" : "transparent"
                border.width: control._isBordered && index !== 0 ? 0 : 0

                // Divider line on bordered variant between cells
                Rectangle {
                    visible: control._isBordered && index !== 0
                    width: 1
                    height: parent.height
                    color: "#E2E8F0"
                    anchors.left: parent.left
                }

                Rectangle {
                    // shadow analogue for pill active cell
                    visible: control._isPill && _cell._active
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.color: Qt.rgba(15 / 255, 23 / 255, 42 / 255, 0.06)
                    border.width: 1
                    z: -1
                }

                Text {
                    id: _text
                    text: _cell._label
                    anchors.centerIn: parent
                    color: {
                        if (control._isPill)     return _cell._active ? "#2563EB" : "#6B7280"
                        if (control._isBordered) return _cell._active ? "#FFFFFF" : "#6B7280"
                        return _cell._active ? "#FFFFFF" : "#4A5568"
                    }
                    font.family: control.fontFamily
                    font.pixelSize: control.fontPixelSize
                    font.letterSpacing: control.letterSpacing
                    font.weight: _cell._active
                        ? (control._isPill ? Font.DemiBold : (control._isBordered ? Font.DemiBold : Font.DemiBold))
                        : Font.Normal
                    renderType: Text.NativeRendering
                    antialiasing: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (control.current !== _cell._key) {
                            control.current = _cell._key
                            control.changed(_cell._key)
                        }
                    }
                }

                Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
            }
        }
    }
}
