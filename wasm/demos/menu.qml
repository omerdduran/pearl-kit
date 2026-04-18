import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Inline MenuBar — submenus work via the Tools menu" }

        P.MenuBar {
            Layout.fillWidth: true
            P.Menu {
                title: "&File"
                P.MenuItem { text: "&New File"; shortcut: "Cmd+N" }
                P.MenuItem { text: "&Open...";  shortcut: "Cmd+O" }
                P.MenuSeparator {}
                P.MenuItem { text: "&Close";    shortcut: "Cmd+W" }
                P.MenuItem { text: "&Quit";     shortcut: "Cmd+Q"; variant: "destructive" }
            }
            P.Menu {
                title: "&View"
                P.MenuItem { text: "Show &Toolbar";  checkable: true; checked: true }
                P.MenuItem { text: "Show &Sidebar";  checkable: true }
                P.MenuSeparator {}
                P.MenuItem { text: "&List";    checkable: true; checked: true; radio: true }
                P.MenuItem { text: "&Grid";    checkable: true; radio: true }
                P.MenuItem { text: "&Gallery"; checkable: true; radio: true }
            }
            P.Menu {
                title: "&Tools"
                P.MenuItem { text: "&Preferences"; shortcut: "Cmd+," }
                P.MenuSeparator {}
                P.Menu {
                    title: "&Export"
                    P.MenuItem { text: "PDF" }
                    P.MenuItem { text: "PNG" }
                    P.MenuItem { text: "SVG" }
                }
            }
            P.Menu {
                title: "&Help"
                P.MenuItem { text: "&Documentation"; shortcut: "F1" }
                P.MenuItem { text: "&About pearl-kit" }
            }
        }

        P.PearlText { variant: "muted"; text: "Right-click a card below for a context menu" }

        Flow {
            Layout.fillWidth: true
            spacing: 12

            Repeater {
                model: [
                    { label: "Document", hint: "report.pdf" },
                    { label: "Image",    hint: "scan.png" },
                    { label: "Archive",  hint: "backup.zip" }
                ]
                delegate: Rectangle {
                    width: 160
                    height: 72
                    radius: P.Tokens.radius.md
                    color: P.Tokens.muted
                    border.color: P.Tokens.border
                    border.width: 1

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2
                        P.PearlText { Layout.alignment: Qt.AlignHCenter; variant: "label"; text: modelData.label }
                        P.PearlText { Layout.alignment: Qt.AlignHCenter; variant: "muted"; text: modelData.hint }
                    }

                    P.Menu {
                        id: cardMenu
                        P.MenuItem { text: "&Open"; shortcut: "Enter" }
                        P.MenuItem { text: "Open in &New Window"; shortcut: "Cmd+Return" }
                        P.MenuSeparator {}
                        P.MenuItem { text: "&Copy"; shortcut: "Cmd+C" }
                        P.MenuItem { text: "C&ut";  shortcut: "Cmd+X" }
                        P.MenuItem { text: "&Paste"; shortcut: "Cmd+V" }
                        P.MenuSeparator {}
                        P.MenuItem { text: "&Delete"; shortcut: "Del"; variant: "destructive" }
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        onClicked: function(mouse) { cardMenu.popup(mouse.x, mouse.y) }
                    }
                }
            }
        }
    }
}
