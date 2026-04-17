"""pearl-kit gallery — showcases Button, Input, Toggle, Select, CheckBox, Stepper, and Dialog."""

from __future__ import annotations

import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit

_QML = """
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models
import PearlKit 1.0 as P

ApplicationWindow {
    width: 880
    height: 1280
    visible: true
    title: "pearl-kit gallery"
    color: P.Tokens.background

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 32
        spacing: 24

        Text {
            text: "Button"
            color: P.Tokens.foreground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.xl
            font.weight: P.Tokens.font.weight.semibold
        }

        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.Button { text: "Default";     variant: "default" }
            P.Button { text: "Destructive"; variant: "destructive" }
            P.Button { text: "Outline";     variant: "outline" }
            P.Button { text: "Secondary";   variant: "secondary" }
            P.Button { text: "Ghost";       variant: "ghost" }
            P.Button { text: "Link";        variant: "link" }
        }

        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.Button { text: "xs"; size: "xs" }
            P.Button { text: "sm"; size: "sm" }
            P.Button { text: "Default"; size: "default" }
            P.Button { text: "lg"; size: "lg" }
            P.Button { size: "icon" }
        }

        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.Button { text: "Disabled default"; variant: "default"; enabled: false }
            P.Button { text: "Disabled dest";    variant: "destructive"; enabled: false }
            P.Button { text: "Disabled outline"; variant: "outline"; enabled: false }
        }

        Text {
            text: "Input"
            color: P.Tokens.foreground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.xl
            font.weight: P.Tokens.font.weight.semibold
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            P.Input {
                Layout.preferredWidth: 320
                placeholderText: "you@example.com"
            }
            P.Input {
                Layout.preferredWidth: 320
                placeholderText: "Search..."
            }
            P.Input {
                Layout.preferredWidth: 320
                placeholderText: "Invalid email"
                text: "not-an-email"
                error: true
            }
            P.Input {
                Layout.preferredWidth: 320
                placeholderText: "Disabled"
                text: "read-only value"
                enabled: false
            }
        }

        Text {
            text: "Toggle"
            color: P.Tokens.foreground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.xl
            font.weight: P.Tokens.font.weight.semibold
        }

        Flow {
            Layout.fillWidth: true
            spacing: 16
            P.Toggle { }
            P.Toggle { checked: true }
            P.Toggle { size: "sm" }
            P.Toggle { size: "sm"; checked: true }
            P.Toggle { enabled: false }
            P.Toggle { enabled: false; checked: true }
        }

        Text {
            text: "Select"
            color: P.Tokens.foreground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.xl
            font.weight: P.Tokens.font.weight.semibold
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            Flow {
                Layout.fillWidth: true
                spacing: 12

                P.Select {
                    model: ["Apple", "Banana", "Cherry", "Date"]
                }
                P.Select {
                    size: "sm"
                    model: ["sm", "md", "lg", "xl"]
                }
                P.Select {
                    error: true
                    model: ["invalid option"]
                }
                P.Select {
                    enabled: false
                    model: ["disabled"]
                }
            }

            P.Select {
                Layout.preferredWidth: 260
                textRole: "text"
                valueRole: "value"
                model: ListModel {
                    ListElement { type: "header"; text: "Latin"; value: "" }
                    ListElement { type: "item";   text: "English";    value: "en" }
                    ListElement { type: "item";   text: "Türkçe";     value: "tr" }
                    ListElement { type: "item";   text: "Deutsch";    value: "de" }
                    ListElement { type: "separator"; text: ""; value: "" }
                    ListElement { type: "header"; text: "CJK"; value: "" }
                    ListElement { type: "item";   text: "日本語";      value: "ja" }
                    ListElement { type: "item";   text: "中文";        value: "zh" }
                }
            }
        }

        Text {
            text: "CheckBox"
            color: P.Tokens.foreground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.xl
            font.weight: P.Tokens.font.weight.semibold
        }

        Flow {
            Layout.fillWidth: true
            spacing: 16
            P.CheckBox { }
            P.CheckBox { checked: true }
            P.CheckBox { tristate: true; checkState: Qt.PartiallyChecked }
            P.CheckBox { error: true }
            P.CheckBox { error: true; checked: true }
            P.CheckBox { enabled: false }
            P.CheckBox { enabled: false; checked: true }
        }

        Row {
            spacing: 8
            P.CheckBox { id: cbNotify }
            Text {
                text: "Enable notifications"
                color: P.Tokens.foreground
                font.family: P.Tokens.font.ui
                font.pixelSize: P.Tokens.font.size.sm
                anchors.verticalCenter: parent.verticalCenter
                MouseArea { anchors.fill: parent; onClicked: cbNotify.toggle() }
            }
        }

        Text {
            text: "Stepper"
            color: P.Tokens.foreground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.xl
            font.weight: P.Tokens.font.weight.semibold
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            P.Stepper {
                Layout.preferredWidth: 200
                from: 0; to: 100
                value: 50
                suffix: "%"
            }
            P.Stepper {
                Layout.preferredWidth: 200
                from: 0; to: 10
                decimals: 2
                stepSize: 0.1
                value: 2.5
                suffix: " mm"
            }
            P.Stepper {
                Layout.preferredWidth: 200
                from: 0; to: 1000
                specialValueText: "Auto"
            }
            P.Stepper {
                Layout.preferredWidth: 200
                error: true
                value: 42
            }
            P.Stepper {
                Layout.preferredWidth: 200
                enabled: false
                value: 12
                suffix: " px"
            }
        }

        Text {
            text: "Dialog"
            color: P.Tokens.foreground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.xl
            font.weight: P.Tokens.font.weight.semibold
        }

        Flow {
            Layout.fillWidth: true
            spacing: 12

            P.Button { text: "Simple dialog"; onClicked: simpleDialog.open() }
            P.Button { text: "Confirm destructive"; variant: "outline"; onClicked: confirmDialog.open() }
            P.Button { text: "No close button"; variant: "ghost"; onClicked: noCloseDialog.open() }
        }

        Item { Layout.fillHeight: true }
    }

    P.Dialog {
        id: simpleDialog
        title: "Welcome"
        description: "Simple dialog with title, description, close button."
        Text {
            text: "Body content goes here — anything passed as a child of Dialog lands in the body column, spaced at 16 px."
            color: P.Tokens.foreground
            font.family: P.Tokens.font.ui
            font.pixelSize: P.Tokens.font.size.sm
            wrapMode: Text.WordWrap
            width: 460
        }
    }

    P.Dialog {
        id: confirmDialog
        title: "Delete file?"
        description: "This action cannot be undone. The file will be permanently removed."
        footer: Row {
            spacing: 8
            layoutDirection: Qt.RightToLeft
            P.Button { text: "Delete"; variant: "destructive"; onClicked: confirmDialog.close() }
            P.Button { text: "Cancel"; variant: "outline"; onClicked: confirmDialog.close() }
        }
    }

    P.Dialog {
        id: noCloseDialog
        title: "Forced choice"
        description: "No X button — you must pick one of the options below."
        showCloseButton: false
        footer: Row {
            spacing: 8
            layoutDirection: Qt.RightToLeft
            P.Button { text: "Accept"; onClicked: noCloseDialog.close() }
            P.Button { text: "Decline"; variant: "outline"; onClicked: noCloseDialog.close() }
        }
    }
}
"""


def main() -> int:
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(_QML.encode("utf-8"))
    if not engine.rootObjects():
        return 1
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
