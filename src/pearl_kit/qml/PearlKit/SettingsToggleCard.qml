// Source: design_handoff_onboarding/src/onboarding.jsx:309-346
// Toggle row card for AI/privacy step. Title (+ optional badge) on top
// row, optional description below, Toggle on the right. `highlighted`
// switches to blue-tinted border + bg. `locked` disables the Toggle and
// fades the card.
import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    property string title: ""
    property string description: ""
    property string badgeText: ""
    property bool checked: false
    property bool highlighted: false
    property bool locked: false

    // Defaults bound to Tokens so the card follows Dark / Light without
    // per-consumer overrides. Override any of these from the call site to
    // pin a value (existing call sites that assigned hex strings keep
    // working unchanged).
    property color titleColor: Tokens.foreground
    property color descriptionColor: Tokens.mutedForeground
    property color badgeFg: "#047857"
    property color badgeBg: "#D1FAE5"
    property color highlightedBorder: Qt.rgba(Tokens.primary.r, Tokens.primary.g, Tokens.primary.b, 0.32)
    property color highlightedBackground: Qt.rgba(Tokens.primary.r, Tokens.primary.g, Tokens.primary.b, 0.10)
    property color defaultBorder: Tokens.border
    property color defaultBackground: Tokens.card
    property int radius: 5
    property int hPadding: 18
    property int vPadding: 16

    property string fontFamilyMono: Tokens.font.mono
    property string fontFamilyUI: Tokens.font.ui

    signal toggled(bool checked)

    implicitWidth: 540
    implicitHeight: _row.implicitHeight + vPadding * 2

    Rectangle {
        anchors.fill: parent
        radius: control.radius
        color: control.highlighted ? control.highlightedBackground : control.defaultBackground
        border.color: control.highlighted ? control.highlightedBorder : control.defaultBorder
        border.width: 1
        opacity: control.locked ? 0.5 : 1.0
    }

    RowLayout {
        id: _row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: control.hPadding
        anchors.rightMargin: control.hPadding
        spacing: 16

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: 4

            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Text {
                    text: control.title
                    color: control.titleColor
                    font.family: control.fontFamilyUI
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    renderType: Text.NativeRendering
                    antialiasing: true
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Rectangle {
                    visible: control.badgeText !== ""
                    Layout.preferredWidth: _badgeText.implicitWidth + 12
                    Layout.preferredHeight: _badgeText.implicitHeight + 4
                    Layout.alignment: Qt.AlignVCenter
                    radius: 3
                    color: control.badgeBg

                    Text {
                        id: _badgeText
                        anchors.centerIn: parent
                        text: control.badgeText
                        color: control.badgeFg
                        font.family: control.fontFamilyMono
                        font.pixelSize: 9
                        font.letterSpacing: 0.9
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                }
            }

            Text {
                visible: control.description !== ""
                text: control.description
                color: control.descriptionColor
                font.family: control.fontFamilyUI
                font.pixelSize: 12
                lineHeight: 1.55
                lineHeightMode: Text.ProportionalHeight
                renderType: Text.NativeRendering
                antialiasing: true
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }

        Toggle {
            id: _toggle
            Layout.alignment: Qt.AlignTop
            checked: control.checked
            enabled: !control.locked
            onToggled: {
                control.checked = checked
                control.toggled(checked)
            }
        }
    }
}
