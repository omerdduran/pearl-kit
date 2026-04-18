// Source: design_handoff_planning_workspace/src/report-tab.jsx:203-230
// Footer strip: count label + flex ProgressLine + export outline button +
// primary sign button. Sign button disabled until acknowledged == total.
// When signed, button turns green and shows the signed-sent label.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property int acknowledged: 0
    property int total: 0
    property bool signed: false
    property string signLabel: "SIGN & APPROVE \u2192"
    property string signedLabel: "\u2713 SIGNED \u00B7 SENT TO FAB"
    property string exportLabel: "EXPORT PDF"
    property string countLabel: "CHECKLIST"

    property string fontFamilyMono: Tokens.font.mono

    signal exportRequested()
    signal signRequested()

    readonly property bool _canSign: total > 0 && acknowledged >= total
    readonly property real _ratio: total > 0 ? acknowledged / total : 0

    implicitWidth: 720
    implicitHeight: 56

    Rectangle {
        anchors.fill: parent
        color: "#FAFBFC"

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: "#E2E8F0"
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        spacing: 16

        Text {
            text: control.countLabel + " \u00B7 " + control.acknowledged + " / " + control.total + " acknowledged"
            color: "#6B7280"
            font.family: control.fontFamilyMono
            font.pixelSize: 10
            font.letterSpacing: 1.0
            font.capitalization: Font.AllUppercase
            renderType: Text.NativeRendering
            antialiasing: true
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 3
            Layout.alignment: Qt.AlignVCenter
            radius: 2
            color: "#F1F5F9"
            clip: true

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * control._ratio
                color: control._canSign ? "#10B981" : "#1A202C"
                Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
                Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            }
        }

        // Export button — outline mono
        Rectangle {
            Layout.preferredWidth: _exportText.implicitWidth + 28
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: _exportArea.containsMouse ? "#F7F8FA" : "transparent"
            border.color: "#E2E8F0"
            border.width: 1

            Text {
                id: _exportText
                anchors.centerIn: parent
                text: control.exportLabel
                color: "#4A5568"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.letterSpacing: 0.66
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _exportArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: control.exportRequested()
            }
        }

        // Sign button — disabled until _canSign; green when signed
        Rectangle {
            Layout.preferredWidth: _signText.implicitWidth + 32
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignVCenter
            radius: 4
            color: {
                if (control.signed) return "#10B981"
                if (!control._canSign) return "#E2E8F0"
                return _signArea.containsMouse ? "#0F172A" : "#1A202C"
            }
            Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }

            Text {
                id: _signText
                anchors.centerIn: parent
                text: control.signed ? control.signedLabel : control.signLabel
                color: (control._canSign || control.signed) ? "#FFFFFF" : "#9CA3AF"
                font.family: control.fontFamilyMono
                font.pixelSize: 11
                font.letterSpacing: 0.66
                font.weight: Font.DemiBold
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _signArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: control._canSign ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                onClicked: {
                    if (control._canSign && !control.signed) {
                        control.signRequested()
                    }
                }
            }
        }
    }
}
