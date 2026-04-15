"""pearl-kit gallery — showcases Button, Input, Toggle, and Select."""

from __future__ import annotations

import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import pearl_kit

_QML = """
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQml.Models
import PearlKit 1.0 as P

Window {
    width: 880
    height: 1120
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

        Item { Layout.fillHeight: true }
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
