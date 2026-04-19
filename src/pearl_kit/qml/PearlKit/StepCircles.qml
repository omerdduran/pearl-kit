// Source: design_handoff_onboarding/src/onboarding.jsx:451-503
// Horizontal step indicator: 24x24 circle (number/check) per step, hairline
// connectors between, optional inline label depending on labelMode.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    // [{ n: "01", label: "Welcome", sub: "Get started" }]
    property var model: []
    property int currentIndex: 0
    property string labelMode: "active"          // "active" | "all" | "none"
    property color accentColor: "#2563EB"
    property color activeTextColor: "#1A202C"
    property color doneTextColor: "#4A5568"
    property color upcomingTextColor: "#9CA3AF"
    property color upcomingBorder: "#E2E8F0"
    property color upcomingFill: "#F1F5F9"
    property int circleSize: 24
    property int interSpacing: 12

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    signal stepClicked(int index)

    implicitWidth: _row.implicitWidth
    implicitHeight: _row.implicitHeight

    RowLayout {
        id: _row
        anchors.fill: parent
        spacing: 0

        Repeater {
            id: _rep
            model: control.model

            delegate: RowLayout {
                id: _delegate
                Layout.fillWidth: index < (control.model ? control.model.length - 1 : 0)
                spacing: 0

                readonly property bool isDone: index < control.currentIndex
                readonly property bool isActive: index === control.currentIndex
                readonly property bool clickable: index <= control.currentIndex
                readonly property bool showLabel:
                    control.labelMode === "all" ||
                    (control.labelMode === "active" && isActive)

                Item {
                    Layout.preferredWidth: _step.implicitWidth
                    Layout.preferredHeight: _step.implicitHeight
                    Layout.alignment: Qt.AlignVCenter

                    RowLayout {
                        id: _step
                        anchors.fill: parent
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: control.circleSize
                            Layout.preferredHeight: control.circleSize
                            radius: control.circleSize / 2
                            color: _delegate.isDone ? control.accentColor
                                : _delegate.isActive ? "#FFFFFF" : control.upcomingFill
                            border.width: 1.5
                            border.color: (_delegate.isDone || _delegate.isActive)
                                ? control.accentColor : control.upcomingBorder

                            Text {
                                anchors.centerIn: parent
                                visible: !_delegate.isDone
                                text: modelData && modelData.n !== undefined ? String(modelData.n) : ""
                                color: _delegate.isActive ? control.accentColor : control.upcomingTextColor
                                font.family: control.fontFamilyMono
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                font.letterSpacing: 0.4
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: _delegate.isDone
                                text: "\u2713"
                                color: "#FFFFFF"
                                font.family: control.fontFamilyMono
                                font.pixelSize: 12
                                font.weight: Font.Bold
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: _delegate.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
                                enabled: _delegate.clickable
                                onClicked: control.stepClicked(index)
                            }
                        }

                        ColumnLayout {
                            visible: _delegate.showLabel
                            spacing: 2

                            Text {
                                text: modelData && modelData.label !== undefined ? String(modelData.label) : ""
                                color: _delegate.isActive ? control.activeTextColor
                                    : _delegate.isDone ? control.doneTextColor : control.upcomingTextColor
                                font.family: control.fontFamilyUI
                                font.pixelSize: 12
                                font.weight: _delegate.isActive ? Font.DemiBold : Font.Medium
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }

                            Text {
                                visible: control.labelMode === "all" && modelData && modelData.sub !== undefined && String(modelData.sub) !== ""
                                text: modelData && modelData.sub !== undefined ? String(modelData.sub) : ""
                                color: control.upcomingTextColor
                                font.family: control.fontFamilyMono
                                font.pixelSize: 9
                                font.letterSpacing: 0.6
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }
                        }
                    }
                }

                Item {
                    visible: index < (control.model ? control.model.length - 1 : 0)
                    Layout.fillWidth: true
                    Layout.preferredHeight: control.circleSize
                    Layout.minimumWidth: control.interSpacing * 2
                    Layout.leftMargin: control.interSpacing
                    Layout.rightMargin: control.interSpacing

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: 1
                        color: index < control.currentIndex ? control.accentColor : control.upcomingBorder
                    }
                }
            }
        }
    }
}
