import QtQuick
import QtQuick.Window
import PearlKit 1.0
import PearlKit.internal 1.0

Window {
    id: win

    // ---- public API
    property string title: ""
    property Item content: null
    property int minWidth: 400
    property int minHeight: 300

    signal dockRequested()
    signal maximizeToggled()

    // ---- private
    readonly property bool _isMaximized: visibility === Window.Maximized

    // ---- frameless chrome
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"
    minimumWidth: minWidth
    minimumHeight: minHeight

    // Intercept close — always dock, never destroy
    onClosing: (close) => {
        close.accepted = false
        win.dockRequested()
    }

    // Auto-reparent content when assigned
    onContentChanged: {
        if (content) {
            content.parent = _contentArea
        }
    }

    // ---- outer border frame
    Rectangle {
        id: _chrome
        anchors.fill: parent
        color: Tokens.background
        border.color: Tokens.border
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 1
            spacing: 0

            // ---- Titlebar
            Rectangle {
                id: _titleBar
                width: parent.width
                height: 32
                color: Tokens.muted

                Rectangle {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    color: Tokens.border
                }

                MouseArea {
                    id: _dragArea
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: _buttons.left
                    anchors.rightMargin: 4
                    hoverEnabled: false
                    property point _pressPos: Qt.point(0, 0)
                    property bool _dragging: false
                    onPressed: (ev) => {
                        _pressPos = Qt.point(ev.x, ev.y)
                        _dragging = true
                    }
                    onReleased: { _dragging = false }
                    onPositionChanged: (ev) => {
                        if (_dragging && (ev.buttons & Qt.LeftButton)) {
                            if (win._isMaximized) return
                            win.x += ev.x - _pressPos.x
                            win.y += ev.y - _pressPos.y
                        }
                    }
                    onDoubleClicked: win._toggleMaximize()
                }

                PearlBaseText {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    text: win.title
                    font.weight: Tokens.font.weight.semibold
                    elide: Text.ElideRight
                    width: _titleBar.width - 12 - (_buttons.width + 8)
                }

                Row {
                    id: _buttons
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    spacing: 2

                    ChromeBtn {
                        objectName: "dockButton"
                        iconKind: "dock"
                        onClicked: win.dockRequested()
                    }
                    ChromeBtn {
                        objectName: "maximizeButton"
                        iconKind: "maximize"
                        restored: win._isMaximized
                        onClicked: win._toggleMaximize()
                    }
                    ChromeBtn {
                        objectName: "closeButton"
                        iconKind: "close"
                        isClose: true
                        onClicked: win.dockRequested()
                    }
                }
            }

            // ---- Content area (reparented DetachableTab lives here)
            Item {
                id: _contentArea
                objectName: "contentArea"
                width: parent.width
                height: parent.height - _titleBar.height
            }
        }

        // ---- Bottom-right resize grip
        MouseArea {
            id: _resizeGrip
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 16
            height: 16
            cursorShape: Qt.SizeFDiagCursor
            visible: !win._isMaximized
            property int _startW: 0
            property int _startH: 0
            property point _startGlobal: Qt.point(0, 0)
            onPressed: (ev) => {
                _startW = win.width
                _startH = win.height
                _startGlobal = mapToGlobal(ev.x, ev.y)
            }
            onPositionChanged: (ev) => {
                if (pressed && (ev.buttons & Qt.LeftButton)) {
                    const gp = mapToGlobal(ev.x, ev.y)
                    win.width = Math.max(win.minWidth, _startW + (gp.x - _startGlobal.x))
                    win.height = Math.max(win.minHeight, _startH + (gp.y - _startGlobal.y))
                }
            }
        }
    }

    function _toggleMaximize() {
        if (win.visibility === Window.Maximized) {
            win.visibility = Window.Windowed
        } else {
            win.visibility = Window.Maximized
        }
        win.maximizeToggled()
    }

    component ChromeBtn: Item {
        id: btn
        property string iconKind: "close"
        property bool isClose: false
        property bool restored: false
        signal clicked()
        width: 24
        height: 24

        property bool _hovered: false
        property color _activeStroke: {
            if (btn._hovered && btn.isClose) return Tokens.destructiveForeground
            return Tokens.foreground
        }

        Rectangle {
            anchors.fill: parent
            radius: Tokens.radius.sm
            color: {
                if (!btn._hovered) return "transparent"
                if (btn.isClose) return Tokens.destructive
                return Qt.rgba(Tokens.foreground.r, Tokens.foreground.g, Tokens.foreground.b, 0.08)
            }
            Behavior on color {
                ColorAnimation { duration: Tokens.motion.fast; easing.type: Easing.OutCubic }
            }
        }

        Loader {
            anchors.centerIn: parent
            width: 14
            height: 14
            sourceComponent: {
                if (btn.iconKind === "dock") return _dockComp
                if (btn.iconKind === "maximize") return _maxComp
                return _closeComp
            }
        }

        Component { id: _dockComp
            PearlDockIcon {
                width: 14
                height: 14
                strokeColor: btn._activeStroke
                strokeWidth: 1.4
            }
        }
        Component { id: _maxComp
            PearlMaximizeIcon {
                width: 14
                height: 14
                restored: btn.restored
                strokeColor: btn._activeStroke
                strokeWidth: 1.4
            }
        }
        Component { id: _closeComp
            PearlXIcon {
                width: 14
                height: 14
                strokeColor: btn._activeStroke
                strokeWidth: 1.6
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: btn._hovered = true
            onExited: btn._hovered = false
            onClicked: btn.clicked()
        }
    }
}
