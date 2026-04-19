// Source: design_handoff_onboarding/src/onboarding.jsx:651-693
// Vertical step list for editorial-shell left rail. Each row: 24px circle
// (number/check) + label + sub. Active row gets a soft 3px accent halo.
// Hairline separators between rows.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    // [{ n: "01", label: "Welcome", sub: "Get started" }]
    property var model: []
    property int currentIndex: 0
    property color accentColor: "#2563EB"
    property color hairline: "#ECEEF2"
    property color activeTextColor: "#1A202C"
    property color doneTextColor: "#4A5568"
    property color upcomingTextColor: "#8A93A0"
    property color activeBorder: "#2563EB"
    property color upcomingBorder: "#DDE2EA"
    property int circleSize: 24
    property int rowVerticalPadding: 13
    property int leftIndentColumn: 28
    property int columnGap: 12

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    signal stepClicked(int index)

    implicitWidth: 280
    implicitHeight: _col.implicitHeight

    ColumnLayout {
        id: _col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 0

        Repeater {
            id: _rep
            model: control.model

            delegate: Item {
                id: _delegate
                Layout.fillWidth: true
                Layout.preferredHeight: _row.implicitHeight + control.rowVerticalPadding * 2

                readonly property bool isDone: index < control.currentIndex
                readonly property bool isActive: index === control.currentIndex
                readonly property bool clickable: index <= control.currentIndex

                Rectangle {
                    visible: index < (control.model ? control.model.length - 1 : 0)
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: control.hairline
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: _delegate.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
                    enabled: _delegate.clickable
                    onClicked: control.stepClicked(index)
                }

                RowLayout {
                    id: _row
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10
                    spacing: control.columnGap

                    Item {
                        Layout.preferredWidth: control.leftIndentColumn
                        Layout.preferredHeight: control.circleSize

                        Rectangle {
                            visible: _delegate.isActive
                            anchors.centerIn: _circle
                            width: control.circleSize + 6
                            height: control.circleSize + 6
                            radius: width / 2
                            color: Qt.rgba(control.accentColor.r, control.accentColor.g, control.accentColor.b, 0.10)
                        }

                        Rectangle {
                            id: _circle
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: control.circleSize
                            height: control.circleSize
                            radius: width / 2
                            color: _delegate.isDone ? control.accentColor : "#FFFFFF"
                            border.width: 1.5
                            border.color: (_delegate.isDone || _delegate.isActive)
                                ? control.activeBorder : control.upcomingBorder

                            Text {
                                anchors.centerIn: parent
                                visible: !_delegate.isDone
                                text: modelData && modelData.n !== undefined ? String(modelData.n) : ""
                                color: _delegate.isActive ? control.accentColor : control.upcomingTextColor
                                font.family: control.fontFamilyMono
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: _delegate.isDone
                                text: "\u2713"
                                color: "#FFFFFF"
                                font.family: control.fontFamilyMono
                                font.pixelSize: 11
                                font.weight: Font.Bold
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: modelData && modelData.label !== undefined ? String(modelData.label) : ""
                            color: _delegate.isActive ? control.activeTextColor
                                : _delegate.isDone ? control.doneTextColor : control.upcomingTextColor
                            font.family: control.fontFamilyUI
                            font.pixelSize: 13
                            font.weight: _delegate.isActive ? Font.DemiBold : Font.Medium
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }

                        Text {
                            visible: modelData && modelData.sub !== undefined && String(modelData.sub) !== ""
                            text: modelData && modelData.sub !== undefined ? String(modelData.sub) : ""
                            color: _delegate.isActive ? control.accentColor : control.upcomingTextColor
                            font.family: control.fontFamilyMono
                            font.pixelSize: 10
                            font.letterSpacing: 0.6
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }
                    }
                }
            }
        }
    }
}
