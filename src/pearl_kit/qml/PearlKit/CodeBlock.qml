import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import PearlKit 1.0
import PearlKit.internal 1.0

Item {
    id: control

    // ---- public API
    property string code: ""
    property string language: ""
    property string filename: ""
    property bool showCopyButton: true
    property int copyTimeout: 2000
    readonly property bool copied: _copied
    property int maxBodyHeight: 360

    signal copyRequested()

    // ---- private state
    property bool _copied: false
    readonly property bool _hasHeader: control.filename !== "" || control.showCopyButton

    implicitWidth: 480
    implicitHeight: _surface.implicitHeight

    function copyToClipboard() {
        _clipboardHelper.text = control.code
        _clipboardHelper.selectAll()
        _clipboardHelper.copy()
        _clipboardHelper.deselect()
        control._copied = true
        control.copyRequested()
        _copiedTimer.restart()
    }

    // ---- hidden clipboard helper (TextEdit.copy() works without focus)
    TextEdit {
        id: _clipboardHelper
        visible: false
        width: 0
        height: 0
    }

    Timer {
        id: _copiedTimer
        interval: control.copyTimeout
        repeat: false
        onTriggered: control._copied = false
    }

    // ---- surface (rounded, bordered, clipped)
    Rectangle {
        id: _surface
        anchors.fill: parent
        color: Tokens.card
        border.color: Tokens.border
        border.width: 1
        radius: Tokens.radius.md
        clip: true
        opacity: control.enabled ? 1.0 : 0.5
        implicitHeight: _col.implicitHeight

        ColumnLayout {
            id: _col
            anchors.fill: parent
            spacing: 0

            // ---- header (filename + copy button)
            Rectangle {
                id: _header
                visible: control._hasHeader
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                color: Tokens.muted

                PearlText {
                    id: _filenameText
                    visible: control.filename !== ""
                    text: control.filename
                    color: Tokens.mutedForeground
                    font.family: Tokens.font.mono
                    font.pixelSize: Tokens.font.size.xs
                    font.weight: Tokens.font.weight.regular
                    anchors.left: parent.left
                    anchors.leftMargin: Tokens.space.x4
                    anchors.right: _copyBtn.visible ? _copyBtn.left : parent.right
                    anchors.rightMargin: Tokens.space.x2
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                }

                // ---- copy button (ghost, 36 x 36 icon — T.Button, not public Button,
                //      because we need a custom Canvas glyph swap inside contentItem)
                T.Button {
                    id: _copyBtn
                    visible: control.showCopyButton
                    hoverEnabled: true
                    focusPolicy: Qt.StrongFocus
                    padding: 0
                    implicitWidth: 36
                    implicitHeight: 36
                    anchors.right: parent.right
                    anchors.rightMargin: Tokens.space.x1
                    anchors.verticalCenter: parent.verticalCenter

                    background: Rectangle {
                        color: (_copyBtn.down || _copyBtn.hovered) ? Tokens.accent : "transparent"
                        radius: Tokens.radius.md
                        opacity: _copyBtn.enabled ? 1.0 : 0.5
                        Behavior on color {
                            ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
                        }
                    }

                    contentItem: Item {
                        PearlCopyIcon {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            visible: !control._copied
                            strokeColor: (_copyBtn.down || _copyBtn.hovered)
                                ? Tokens.accentForeground
                                : Tokens.mutedForeground
                        }
                        PearlCheckIcon {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            visible: control._copied
                            strokeColor: Tokens.success
                            strokeWidth: 1.8
                        }
                    }

                    PearlFocusRing {
                        target: _copyBtn
                        offset: 0
                        ringWidth: 3
                        ringColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.5)
                        visible: _copyBtn.visualFocus
                    }

                    onClicked: control.copyToClipboard()
                }
            }

            // ---- hairline under header
            Rectangle {
                visible: control._hasHeader
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Tokens.border
            }

            // ---- body: selectable monospace text with horizontal + vertical scroll
            Flickable {
                id: _body
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 48
                Layout.preferredHeight: Math.min(
                    _code.contentHeight + 2 * Tokens.space.x4,
                    control.maxBodyHeight
                )
                clip: true
                contentWidth: _code.contentWidth + 2 * Tokens.space.x4
                contentHeight: _code.contentHeight + 2 * Tokens.space.x4
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.HorizontalAndVerticalFlick

                TextEdit {
                    id: _code
                    x: Tokens.space.x4
                    y: Tokens.space.x4
                    text: control.code
                    readOnly: true
                    selectByMouse: true
                    selectionColor: Qt.rgba(Tokens.ring.r, Tokens.ring.g, Tokens.ring.b, 0.35)
                    selectedTextColor: Tokens.foreground
                    color: Tokens.foreground
                    font.family: Tokens.font.mono
                    font.pixelSize: Tokens.font.size.sm
                    wrapMode: TextEdit.NoWrap
                    activeFocusOnPress: true
                    persistentSelection: true
                    renderType: TextEdit.NativeRendering
                }
            }
        }
    }
}
