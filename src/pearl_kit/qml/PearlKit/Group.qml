// Source: design_handoff_settings/src/settings.jsx:229-238
// Sub-section container: mono uppercase title + 1 px bottom border +
// default-property slot beneath. 32 px outer margin-bottom.
import QtQuick
import PearlKit 1.0

Item {
    id: control

    property string title: ""
    property int titleFontSize: 10
    property int titleBottomPadding: 8
    property int outerBottomMargin: 32

    property string fontFamilyMono: Tokens.font.mono

    property color titleColor: "#9CA3AF"
    property color borderColor: "#E2E8F0"

    default property alias slotContent: _slot.data

    implicitWidth: 640
    implicitHeight: _header.implicitHeight
        + control.titleBottomPadding
        + 1
        + _slot.implicitHeight
        + control.outerBottomMargin

    Column {
        id: _col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        Item {
            id: _header
            visible: control.title !== ""
            width: parent.width
            implicitHeight: _titleText.implicitHeight + control.titleBottomPadding
            height: implicitHeight

            Text {
                id: _titleText
                text: control.title
                color: control.titleColor
                font.family: control.fontFamilyMono
                font.pixelSize: control.titleFontSize
                font.letterSpacing: 1.5
                font.capitalization: Font.AllUppercase
                renderType: Text.NativeRendering
                antialiasing: true
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: control.borderColor
            }
        }

        Item {
            id: _slot
            width: parent.width
            implicitHeight: children.length > 0 ? childrenRect.height : 0
            height: implicitHeight
        }
    }
}
