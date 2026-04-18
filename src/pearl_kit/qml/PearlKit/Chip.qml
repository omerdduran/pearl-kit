// Source:
//   report-tab.jsx:128-136 (variant "soft" — suggested-prompts)
//   report-tab.jsx:115-122 (variant "outline" — APPLY TO PLAN action)
// Small clickable mono pill. No hover effect in the handoff; we add a
// subtle tinted hover so mouse users get feedback.
import QtQuick
import QtQuick.Templates as T
import PearlKit 1.0

T.AbstractButton {
    id: control

    property string variant: "soft"        // "soft" | "outline"
    property string fontFamily: Tokens.font.mono

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    leftPadding: control.variant === "soft" ? 8 : 10
    rightPadding: leftPadding
    topPadding: control.variant === "soft" ? 4 : 5
    bottomPadding: topPadding

    readonly property bool _soft: variant === "soft"

    readonly property color _bg: _soft
        ? (control.hovered ? "#EEF2F6" : "#F7F8FA")
        : (control.hovered ? "#F1F5F9" : "transparent")
    readonly property color _borderColor: _soft ? "#E2E8F0" : "#1A202C"
    readonly property color _fg: _soft ? "#4A5568" : "#1A202C"

    implicitHeight: _soft ? 22 : 26
    implicitWidth: implicitContentWidth + leftPadding + rightPadding

    background: Rectangle {
        radius: 3
        color: control._bg
        border.color: control._borderColor
        border.width: 1
        Behavior on color { ColorAnimation { duration: Tokens.motion.fast } }
    }

    contentItem: Text {
        text: control.text
        color: control._fg
        font.family: control.fontFamily
        font.pixelSize: control._soft ? 10.5 : 11
        font.letterSpacing: control._soft ? 0.02 * 10.5 : 0.04 * 11
        renderType: Text.NativeRendering
        antialiasing: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
