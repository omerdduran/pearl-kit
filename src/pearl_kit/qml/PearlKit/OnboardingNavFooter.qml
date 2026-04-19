// Source: design_handoff_onboarding/src/onboarding.jsx:506-554
// Onboarding footer band: ghost back (left) + mono "STEP X / Y" counter
// (center) + skip + optional secondary outline + primary accent (right).
// Generic — every label, signal, and enabled flag is exposed as a
// property so consumers can drive both intermediate and final steps.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property bool backEnabled: true
    property string backText: "\u2190 BACK"
    property int currentStep: 1
    property int totalSteps: 5
    property string counterTemplate: "STEP %1 / %2"
    property bool canSkip: false
    property string skipText: "SKIP"
    property string secondaryText: ""
    property string primaryText: "Continue \u2192"
    property bool primaryEnabled: true
    property color primaryColor: "#2563EB"
    property color background: "#FFFFFF"
    property color borderColor: "#E2E8F0"
    property color counterColor: "#9CA3AF"
    property color ghostColor: "#4A5568"
    property color ghostDisabled: "#CBD5E1"
    property color secondaryTextColor: "#1A202C"
    property int hPadding: 28
    property int vPadding: 16

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    signal back()
    signal skip()
    signal primary()
    signal secondary()

    implicitWidth: 640
    implicitHeight: 56 + vPadding

    Rectangle {
        anchors.fill: parent
        color: control.background

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: control.borderColor
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: control.hPadding
        anchors.rightMargin: control.hPadding
        spacing: 16

        Rectangle {
            id: _back
            Layout.preferredWidth: _backText.implicitWidth + 22
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: _backArea.containsMouse && control.backEnabled ? "#F7F8FA" : "transparent"

            Text {
                id: _backText
                anchors.centerIn: parent
                text: control.backText
                color: control.backEnabled ? control.ghostColor : control.ghostDisabled
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.letterSpacing: 0.88
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _backArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: control.backEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                enabled: control.backEnabled
                onClicked: control.back()
            }
        }

        Item { Layout.fillWidth: true }

        Text {
            text: control.counterTemplate.arg(control.currentStep).arg(control.totalSteps)
            color: control.counterColor
            font.family: control.fontFamilyMono
            font.pixelSize: 11
            font.letterSpacing: 1.05
            font.capitalization: Font.AllUppercase
            renderType: Text.NativeRendering
            antialiasing: true
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true }

        Rectangle {
            visible: control.canSkip
            Layout.preferredWidth: _skipText.implicitWidth + 22
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: _skipArea.containsMouse ? "#F7F8FA" : "transparent"

            Text {
                id: _skipText
                anchors.centerIn: parent
                text: control.skipText
                color: "#6B7280"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.letterSpacing: 0.88
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _skipArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: control.skip()
            }
        }

        Rectangle {
            visible: control.secondaryText !== ""
            Layout.preferredWidth: _secondaryText.implicitWidth + 26
            Layout.preferredHeight: 34
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: _secondaryArea.containsMouse ? "#F7F8FA" : "#FFFFFF"
            border.color: "#E2E8F0"
            border.width: 1

            Text {
                id: _secondaryText
                anchors.centerIn: parent
                text: control.secondaryText
                color: control.secondaryTextColor
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.letterSpacing: 0.66
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _secondaryArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: control.secondary()
            }
        }

        Rectangle {
            id: _primary
            Layout.preferredWidth: _primaryText.implicitWidth + 32
            Layout.preferredHeight: 34
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: {
                if (!control.primaryEnabled) return "#E2E8F0"
                return _primaryArea.containsMouse ? Qt.darker(control.primaryColor, 1.08) : control.primaryColor
            }
            Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }

            Text {
                id: _primaryText
                anchors.centerIn: parent
                text: control.primaryText
                color: control.primaryEnabled ? "#FFFFFF" : "#9CA3AF"
                font.family: control.fontFamilyUI
                font.pixelSize: 13
                font.weight: Font.DemiBold
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _primaryArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: control.primaryEnabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                enabled: control.primaryEnabled
                onClicked: control.primary()
            }
        }
    }
}
