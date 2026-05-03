import QtCore
import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

Item {
    id: control

    // ---- public API
    property string header: ""
    property bool expanded: true
    // When non-empty, the expanded state is mirrored to QSettings under
    // category "PearlKit.CollapsibleNavGroup.<persistKey>".
    property string persistKey: ""

    default property alias content: _bodyContent.data

    // ---- chrome
    readonly property int _headerHeight: 28
    readonly property int _hPadding: Tokens.space.x3
    readonly property int _gapBetweenChildren: 2

    implicitWidth: 240
    implicitHeight: _headerHeight + _bodyHost.height

    // ---- header (clickable toggle)
    T.Button {
        id: _headerBtn
        width: parent.width
        height: control._headerHeight
        focusPolicy: Qt.StrongFocus
        hoverEnabled: true

        onClicked: control.expanded = !control.expanded

        Keys.onUpPressed: {
            if (_bodyContent.children.length > 0) {
                _bodyContent.children[_bodyContent.children.length - 1].forceActiveFocus()
            }
        }
        Keys.onDownPressed: {
            if (control.expanded && _bodyContent.children.length > 0) {
                _bodyContent.children[0].forceActiveFocus()
            }
        }

        background: Rectangle {
            color: _headerBtn.hovered ? Tokens.accent : "transparent"
            radius: Tokens.radius.sm
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        contentItem: Item {
            anchors.fill: parent

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: control._hPadding
                anchors.rightMargin: control._hPadding
                spacing: Tokens.space.x2

                Item {
                    width: 12
                    height: 12
                    anchors.verticalCenter: parent.verticalCenter

                    PearlText {
                        anchors.centerIn: parent
                        text: "▸"
                        color: Tokens.mutedForeground
                        font.pixelSize: Tokens.font.size.xs
                        rotation: control.expanded ? 90 : 0
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Behavior on rotation {
                            NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
                        }
                    }
                }

                PearlText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: control.header
                    variant: "label"
                    color: Tokens.mutedForeground
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1.0
                }
            }
        }
    }

    // ---- body container (children land here via default property alias above)
    Item {
        id: _bodyHost
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: _headerBtn.bottom
        height: control.expanded ? _bodyContent.implicitHeight : 0
        clip: true
        opacity: control.expanded ? 1.0 : 0.0
        visible: height > 0 || control.expanded

        Behavior on height {
            NumberAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
        }
        Behavior on opacity {
            NumberAnimation { duration: Tokens.motion.fast }
        }

        Column {
            id: _bodyContent
            width: parent.width
            spacing: control._gapBetweenChildren
        }
    }

    // ---- optional QSettings persistence
    Loader {
        id: _persistLoader
        active: control.persistKey !== ""
        sourceComponent: _persistComp
    }

    Component {
        id: _persistComp
        Settings {
            category: "PearlKit.CollapsibleNavGroup." + control.persistKey
            property bool expandedState: true
            Component.onCompleted: control.expanded = expandedState
        }
    }

    onExpandedChanged: {
        if (_persistLoader.item) {
            _persistLoader.item.expandedState = expanded
        }
    }
}
