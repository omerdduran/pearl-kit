// Source: design_handoff_planning_workspace/src/planning-viewer.jsx:210-228
// Compound: optional back-button slot + Breadcrumb + vertical divider +
// 2-row name/meta block. Consumer supplies `segments`, `name`, `meta`;
// back() signal fires when the back-affordance is clicked.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property var segments: []
    property string name: ""
    property string meta: ""
    property bool showBackButton: true
    property url backIconSource: ""

    property string fontFamilyUI: Tokens.font.ui
    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilySerif: "Times New Roman"

    property color dividerColor: "#E2E8F0"
    property color nameColor: "#1A202C"
    property color metaColor: "#9CA3AF"

    signal back()

    implicitHeight: 48
    implicitWidth: _row.implicitWidth + 28

    RowLayout {
        id: _row
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
        spacing: 14

        // Back affordance — minimal native-look pill, click emits back()
        Rectangle {
            visible: control.showBackButton
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            radius: 4
            color: _backArea.containsMouse ? "#F1F5F9" : "transparent"

            Image {
                visible: control.backIconSource != ""
                source: control.backIconSource
                sourceSize: Qt.size(16, 16)
                width: 16
                height: 16
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
            }

            // Default glyph fallback when no icon provided
            Text {
                visible: control.backIconSource == ""
                text: "\u2190"
                anchors.centerIn: parent
                font.family: control.fontFamilyUI
                font.pixelSize: 14
                color: "#4A5568"
                renderType: Text.NativeRendering
                antialiasing: true
            }

            MouseArea {
                id: _backArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: control.back()
            }

            Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
        }

        Breadcrumb {
            segments: control.segments
            fontFamily: control.fontFamilyMono
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 18
            color: control.dividerColor
        }

        ColumnLayout {
            spacing: 2

            Text {
                text: control.name
                color: control.nameColor
                font.family: control.fontFamilySerif
                font.pixelSize: 16
                font.letterSpacing: -0.01 * 16
                renderType: Text.NativeRendering
                antialiasing: true
            }

            Text {
                text: control.meta
                color: control.metaColor
                font.family: control.fontFamilyMono
                font.pixelSize: 10
                renderType: Text.NativeRendering
                antialiasing: true
            }
        }
    }
}
