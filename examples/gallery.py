"""pearl-kit gallery — showcases Button, Input, TextArea, Toggle, Select, CheckBox, Stepper, Text, Dialog, MessageBox, GroupBox, Separator, Card, FormRow, Splitter, ScrollArea, ProgressBar, Spinner, StatusBar, Toast, Tooltip, Slider, StackedView, NavItem, TabBar, IconStrip, Avatar, Badge, CodeBlock, and the Menu family (MenuBar / Menu / MenuItem / MenuSeparator)."""

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
    height: 2000
    visible: true
    title: "pearl-kit gallery"
    color: P.Tokens.background

    ScrollView {
        id: scrollView
        anchors.fill: parent
        clip: true
        padding: 32
        contentWidth: availableWidth

        ColumnLayout {
            width: scrollView.availableWidth
            spacing: 24

        P.PearlText { variant: "title"; text: "Button" }

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

        P.PearlText { variant: "title"; text: "Input" }

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

        P.PearlText { variant: "title"; text: "TextArea" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            P.PearlText { variant: "muted"; text: "Plain — multiline notes" }
            P.TextArea {
                Layout.preferredWidth: 420
                placeholderText: "Clinical notes..."
            }

            P.PearlText { variant: "muted"; text: "Error state" }
            P.TextArea {
                Layout.preferredWidth: 420
                placeholderText: "Required"
                text: "too short"
                error: true
            }

            P.PearlText { variant: "muted"; text: "Mono — license keys / log viewer" }
            P.TextArea {
                Layout.preferredWidth: 420
                mono: true
                placeholderText: "XXXX-XXXX-XXXX-XXXX"
            }

            P.TextArea {
                Layout.preferredWidth: 420
                Layout.preferredHeight: 120
                mono: true
                readOnly: true
                text: "[2026-04-18 10:00:01] INFO  boot: app started\n"
                      + "[2026-04-18 10:00:02] INFO  engine: register_qml ok\n"
                      + "[2026-04-18 10:00:03] WARN  plan: low density region\n"
                      + "[2026-04-18 10:00:04] ERROR export: nerve canal collision\n"
                      + "[2026-04-18 10:00:05] INFO  auto-save: plan.json"
            }

            P.PearlText { variant: "muted"; text: "Disabled" }
            P.TextArea {
                Layout.preferredWidth: 420
                text: "read-only contents"
                enabled: false
            }
        }

        P.PearlText { variant: "title"; text: "Toggle" }

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

        P.PearlText { variant: "title"; text: "Select" }

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

        P.PearlText { variant: "title"; text: "CheckBox" }

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

        P.PearlText { variant: "title"; text: "Stepper" }

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

        P.PearlText { variant: "title"; text: "Text" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            P.PearlText { variant: "title";   text: "Settings" }
            P.PearlText { variant: "heading"; text: "Notifications" }
            P.PearlText { variant: "body";    text: "Receive updates when your plan completes." }
            P.PearlText { variant: "muted";   text: "32 items" }
            P.PearlText { variant: "label";   text: "Email" }
            P.PearlText { variant: "code";    text: "/usr/local/bin/dali" }
            P.PearlText { variant: "mono";    text: "42" }
            P.PearlText {
                text: "A long sentence that elides at the end because its width is constrained"
                Layout.preferredWidth: 260
                elide: Text.ElideRight
            }
        }

        P.PearlText { variant: "title"; text: "Dialog" }

        Flow {
            Layout.fillWidth: true
            spacing: 12

            P.Button { text: "Simple dialog"; onClicked: simpleDialog.open() }
            P.Button { text: "Confirm destructive"; variant: "outline"; onClicked: confirmDialog.open() }
            P.Button { text: "No close button"; variant: "ghost"; onClicked: noCloseDialog.open() }
        }

        P.PearlText { variant: "title"; text: "MessageBox" }

        Flow {
            Layout.fillWidth: true
            spacing: 12

            P.Button { text: "Info";    onClicked: mbInfo.open() }
            P.Button { text: "Warning"; variant: "secondary";   onClicked: mbWarning.open() }
            P.Button { text: "Error";   variant: "destructive"; onClicked: mbError.open() }
            P.Button { text: "Confirm"; variant: "outline";     onClicked: mbConfirm.open() }
        }

        P.PearlText { variant: "title"; text: "Toast" }

        Flow {
            Layout.fillWidth: true
            spacing: 8

            P.Button {
                text: "Default"
                size: "sm"
                onClicked: P.Toaster.show({title: "Heads up", description: "Something happened."})
            }
            P.Button {
                text: "Success"
                size: "sm"
                variant: "secondary"
                onClicked: P.Toaster.show({type: "success", title: "Saved", description: "Your changes are live."})
            }
            P.Button {
                text: "Info"
                size: "sm"
                variant: "secondary"
                onClicked: P.Toaster.show({type: "info", title: "Tip", description: "Press Cmd+K to search."})
            }
            P.Button {
                text: "Warning"
                size: "sm"
                variant: "outline"
                onClicked: P.Toaster.show({type: "warning", title: "Low disk space", description: "Under 10% remaining."})
            }
            P.Button {
                text: "Error"
                size: "sm"
                variant: "destructive"
                onClicked: P.Toaster.show({type: "error", title: "Upload failed", description: "Check your connection."})
            }
            P.Button {
                text: "Loading"
                size: "sm"
                variant: "ghost"
                onClicked: {
                    var id = P.Toaster.show({type: "loading", title: "Processing", description: "This may take a moment."})
                    loadingDismissTimer.pendingId = id
                    loadingDismissTimer.restart()
                }
            }
            P.Button {
                text: "Dismiss all"
                size: "sm"
                variant: "ghost"
                onClicked: P.Toaster.dismissAll()
            }
        }

        Timer {
            id: loadingDismissTimer
            interval: 1800
            property int pendingId: -1
            onTriggered: if (pendingId !== -1) P.Toaster.dismiss(pendingId)
        }

        P.PearlText { variant: "title"; text: "GroupBox" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            P.GroupBox {
                Layout.fillWidth: true
                title: "Notifications"
                description: "Choose how you'd like to be notified about plan progress."

                P.CheckBox { id: cbEmail; checked: true }
                Row {
                    spacing: 8
                    P.CheckBox { id: cbSms }
                    P.PearlText {
                        text: "Text messages"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            P.GroupBox {
                id: collapsibleSection
                Layout.fillWidth: true
                title: "Appearance"
                description: "Theme and density preferences."
                collapsible: true
                expanded: true

                Row {
                    spacing: 12
                    P.PearlText {
                        text: "Compact density"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    P.Toggle { }
                }
                P.Select {
                    width: 220
                    model: ["Light", "Dark", "DarkBlue"]
                }
            }

            Row {
                spacing: 12
                P.PearlText {
                    text: "Show advanced settings"
                    anchors.verticalCenter: parent.verticalCenter
                }
                P.Toggle { id: advancedToggle; checked: false }
            }

            P.GroupBox {
                Layout.fillWidth: true
                title: "Advanced — diagnostics"
                description: "Power-user options. Hidden unless 'Show advanced settings' is enabled."
                collapsible: true
                expanded: false
                advanced: true
                advancedVisible: advancedToggle.checked

                P.Stepper {
                    width: 200
                    from: 0
                    to: 1000
                    value: 250
                    suffix: " ms"
                }
                P.CheckBox { id: cbVerbose }
            }
        }

        P.PearlText { variant: "title"; text: "Separator" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            P.PearlText { variant: "body"; text: "Rows split by horizontal separators" }
            P.Separator { Layout.fillWidth: true }
            P.PearlText { variant: "muted"; text: "Second row — note the 1 px divider above." }
            P.Separator { Layout.fillWidth: true }
            P.PearlText { variant: "muted"; text: "Third row." }

            Row {
                spacing: 12
                height: 24
                P.PearlText {
                    text: "File"
                    anchors.verticalCenter: parent.verticalCenter
                }
                P.Separator {
                    orientation: "vertical"
                    height: parent.height
                }
                P.PearlText {
                    text: "Edit"
                    anchors.verticalCenter: parent.verticalCenter
                }
                P.Separator {
                    orientation: "vertical"
                    height: parent.height
                }
                P.PearlText {
                    text: "View"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        P.PearlText { variant: "title"; text: "Card" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            P.Card {
                Layout.preferredWidth: 420
                P.PearlText { variant: "heading"; text: "Plan summary" }
                P.PearlText { variant: "muted"; text: "Default card — border + card background, no accent." }
            }

            P.Card {
                Layout.preferredWidth: 420
                variant: "destructive"
                P.PearlText { variant: "heading"; text: "Collision detected" }
                P.PearlText {
                    variant: "muted"
                    width: 372
                    wrapMode: Text.WordWrap
                    text: "Implant #3 overlaps the mandibular nerve canal. Reposition before export."
                }
            }

            P.Card {
                Layout.preferredWidth: 420
                variant: "warning"
                P.PearlText { variant: "heading"; text: "Low bone density" }
                P.PearlText { variant: "muted"; text: "Region shows HU < 300. Consider alternate drilling protocol." }
            }

            P.Card {
                Layout.preferredWidth: 420
                variant: "success"
                P.PearlText { variant: "heading"; text: "Export complete" }
                P.PearlText { variant: "muted"; text: "All 4 implants saved to plan.json." }
            }

            P.Card {
                Layout.preferredWidth: 420
                variant: "info"
                P.PearlText { variant: "heading"; text: "Beta feature" }
                P.PearlText { variant: "muted"; text: "Auto-alignment is experimental. Review results before approving." }
            }

            P.Card {
                Layout.preferredWidth: 420
                padding: 16
                spacing: 8
                P.PearlText { variant: "label"; text: "Compact" }
                P.PearlText { variant: "muted"; text: "padding=16, spacing=8 — useful for dense lists." }
            }

            P.Card {
                Layout.preferredWidth: 420
                enabled: false
                P.PearlText { variant: "heading"; text: "Disabled card" }
                P.PearlText { variant: "muted"; text: "Fades background and content at 50 % alpha." }
            }
        }

        P.PearlText { variant: "title"; text: "FormRow" }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: 520
            spacing: 8

            P.FormRow {
                Layout.fillWidth: true
                label: "First name"
                P.Input { placeholderText: "Jane" }
            }
            P.FormRow {
                Layout.fillWidth: true
                label: "Email"
                hint: "We'll never share your address."
                P.Input { placeholderText: "you@example.com" }
            }
            P.FormRow {
                Layout.fillWidth: true
                label: "Password"
                error: "Password is required."
                P.Input {
                    placeholderText: "••••••••"
                    echoMode: TextInput.Password
                    error: true
                }
            }
            P.FormRow {
                Layout.fillWidth: true
                label: "Language"
                hint: "Interface language for menus and tooltips."
                P.Select { model: ["English", "Türkçe", "Deutsch"] }
            }
            P.FormRow {
                Layout.fillWidth: true
                label: "Notifications"
                P.Toggle { }
            }
            P.FormRow {
                Layout.fillWidth: true
                label: "Opacity"
                labelWidth: 100
                P.Stepper {
                    from: 0; to: 100; value: 75
                    suffix: "%"
                }
            }
            P.FormRow {
                Layout.fillWidth: true
                label: "API key"
                enabled: false
                P.Input { text: "sk-••••••" }
            }
            P.FormRow {
                Layout.fillWidth: true
                label: "Server endpoint URL"
                hint: "Label wraps when it exceeds labelWidth."
                labelWidth: 140
                P.Input { placeholderText: "https://api.example.com" }
            }
        }

        P.PearlText { variant: "title"; text: "Splitter" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            P.Splitter {
                Layout.fillWidth: true
                Layout.preferredHeight: 160

                Rectangle {
                    SplitView.preferredWidth: 180
                    SplitView.minimumWidth: 80
                    color: P.Tokens.muted
                    P.PearlText {
                        anchors.centerIn: parent
                        text: "Sidebar"
                        variant: "muted"
                    }
                }
                Rectangle {
                    SplitView.fillWidth: true
                    color: P.Tokens.card
                    P.PearlText {
                        anchors.centerIn: parent
                        text: "Editor (fill)"
                        variant: "body"
                    }
                }
                Rectangle {
                    SplitView.preferredWidth: 140
                    color: P.Tokens.muted
                    P.PearlText {
                        anchors.centerIn: parent
                        text: "Outline"
                        variant: "muted"
                    }
                }
            }

            P.Splitter {
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                orientation: Qt.Vertical
                withHandle: true

                Rectangle {
                    SplitView.preferredHeight: 120
                    color: P.Tokens.card
                    P.PearlText {
                        anchors.centerIn: parent
                        text: "Top pane (withHandle)"
                        variant: "body"
                    }
                }
                Rectangle {
                    SplitView.fillHeight: true
                    color: P.Tokens.muted
                    P.PearlText {
                        anchors.centerIn: parent
                        text: "Bottom pane (fill)"
                        variant: "muted"
                    }
                }
            }

            P.Splitter {
                Layout.fillWidth: true
                Layout.preferredHeight: 220

                Rectangle {
                    SplitView.preferredWidth: 140
                    color: P.Tokens.muted
                    P.PearlText {
                        anchors.centerIn: parent
                        text: "Files"
                        variant: "muted"
                    }
                }

                P.Splitter {
                    orientation: Qt.Vertical
                    SplitView.fillWidth: true

                    Rectangle {
                        SplitView.fillHeight: true
                        color: P.Tokens.card
                        P.PearlText {
                            anchors.centerIn: parent
                            text: "Nested — editor"
                            variant: "body"
                        }
                    }
                    Rectangle {
                        SplitView.preferredHeight: 80
                        color: P.Tokens.muted
                        P.PearlText {
                            anchors.centerIn: parent
                            text: "Nested — terminal"
                            variant: "muted"
                        }
                    }
                }
            }
        }

        P.PearlText { variant: "title"; text: "ScrollArea" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            P.PearlText {
                variant: "muted"
                text: "Auto-hide vertical scroll (hover to reveal thumb)."
            }
            P.ScrollArea {
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                Rectangle {
                    width: 380
                    height: 520
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    radius: P.Tokens.radius.md
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8
                        Repeater {
                            model: 16
                            P.PearlText { text: "Scrollable row #" + (index + 1) }
                        }
                    }
                }
            }

            P.PearlText {
                variant: "muted"
                text: "Always-visible scrollbars (autoHide: false)."
            }
            P.ScrollArea {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                autoHide: false
                Rectangle {
                    width: 900
                    height: 300
                    color: P.Tokens.muted
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        P.PearlText { variant: "heading"; text: "Wide + tall content" }
                        P.PearlText { variant: "muted"; text: "Both scrollbars are persistent." }
                    }
                }
            }

            P.PearlText {
                variant: "muted"
                text: "Disabled ScrollArea."
            }
            P.ScrollArea {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                enabled: false
                Rectangle {
                    width: 500
                    height: 300
                    color: P.Tokens.card
                    P.PearlText {
                        anchors.centerIn: parent
                        variant: "muted"
                        text: "Disabled — no interaction."
                    }
                }
            }
        }

        P.PearlText { variant: "title"; text: "ProgressBar" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            P.PearlText { variant: "muted"; text: "Determinate — 0 / 25 / 50 / 75 / 100" }

            P.ProgressBar {
                Layout.preferredWidth: 360
                value: 0
            }
            P.ProgressBar {
                Layout.preferredWidth: 360
                value: 25
            }
            P.ProgressBar {
                Layout.preferredWidth: 360
                value: 50
            }
            P.ProgressBar {
                Layout.preferredWidth: 360
                value: 75
            }
            P.ProgressBar {
                Layout.preferredWidth: 360
                value: 100
            }

            P.PearlText { variant: "muted"; text: "Custom range — bytes 0..1024, value 640" }
            P.ProgressBar {
                Layout.preferredWidth: 360
                from: 0; to: 1024
                value: 640
            }

            P.PearlText { variant: "muted"; text: "Indeterminate — sliding bar" }
            P.ProgressBar {
                Layout.preferredWidth: 360
                indeterminate: true
            }

            P.PearlText { variant: "muted"; text: "Disabled" }
            P.ProgressBar {
                Layout.preferredWidth: 360
                value: 60
                enabled: false
            }
        }

        P.PearlText { variant: "title"; text: "Spinner" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            P.PearlText { variant: "muted"; text: "Default 16 px, alongside a label." }
            Row {
                spacing: 8
                P.Spinner {
                    anchors.verticalCenter: parent.verticalCenter
                }
                P.PearlText {
                    text: "Loading..."
                    variant: "muted"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            P.PearlText { variant: "muted"; text: "Size overrides via width / height." }
            Row {
                spacing: 16
                P.Spinner { width: 12; height: 12; anchors.verticalCenter: parent.verticalCenter }
                P.Spinner { anchors.verticalCenter: parent.verticalCenter }
                P.Spinner { width: 20; height: 20; anchors.verticalCenter: parent.verticalCenter }
                P.Spinner { width: 24; height: 24; anchors.verticalCenter: parent.verticalCenter }
                P.Spinner { width: 32; height: 32; strokeWidth: 3; anchors.verticalCenter: parent.verticalCenter }
            }

            P.PearlText { variant: "muted"; text: "Color overrides." }
            Row {
                spacing: 16
                P.Spinner { width: 24; height: 24; color: P.Tokens.primary }
                P.Spinner { width: 24; height: 24; color: P.Tokens.destructive }
                P.Spinner { width: 24; height: 24; color: P.Tokens.success }
                P.Spinner { width: 24; height: 24; color: P.Tokens.foreground }
            }

            P.PearlText { variant: "muted"; text: "Paused spinner (running: false)." }
            P.Spinner { running: false; width: 24; height: 24 }

            P.PearlText { variant: "muted"; text: "Inside a Button, replacing an icon." }
            Row {
                spacing: 12
                P.Button {
                    text: "Saving..."
                    variant: "default"
                    enabled: false
                    leftPadding: 32
                    P.Spinner {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        color: P.Tokens.primaryForeground
                    }
                }
            }
        }

        P.PearlText { variant: "title"; text: "StatusBar" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            P.PearlText {
                variant: "muted"
                text: "Main-window footer — left hint, centered measurement, right status."
            }

            P.StatusBar {
                id: defaultBar
                Layout.fillWidth: true
                leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "12 implants placed" }
                centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "14.2 x 8.3 mm @ 200%" }
                rightContent: P.PearlText {
                    font.family: P.Tokens.font.ui
                    font.pixelSize: P.Tokens.font.size.xs
                    text: "Idle"
                    color: defaultBar.statusColor
                }
            }

            P.StatusBar {
                id: successBar
                Layout.fillWidth: true
                statusKind: "success"
                leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Press S to save" }
                centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Auto-aligned 4 / 4" }
                rightContent: P.PearlText {
                    font.family: P.Tokens.font.ui
                    font.pixelSize: P.Tokens.font.size.xs
                    text: "Saved"
                    color: successBar.statusColor
                }
            }

            P.StatusBar {
                id: warningBar
                Layout.fillWidth: true
                statusKind: "warning"
                leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Low bone density" }
                centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "HU 248" }
                rightContent: P.PearlText {
                    font.family: P.Tokens.font.ui
                    font.pixelSize: P.Tokens.font.size.xs
                    text: "Review"
                    color: warningBar.statusColor
                }
            }

            P.StatusBar {
                id: errorBar
                Layout.fillWidth: true
                statusKind: "error"
                leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Nerve canal collision" }
                centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Implant #3 overlap 1.2 mm" }
                rightContent: P.PearlText {
                    font.family: P.Tokens.font.ui
                    font.pixelSize: P.Tokens.font.size.xs
                    text: "Blocked"
                    color: errorBar.statusColor
                }
            }

            P.StatusBar {
                Layout.fillWidth: true
                enabled: false
                leftContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Disabled footer" }
                centerContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "\u2014" }
                rightContent: P.PearlText { variant: "muted"; font.pixelSize: P.Tokens.font.size.xs; text: "Inactive" }
            }
        }

        P.PearlText { variant: "title"; text: "Tooltip" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            Flow {
                Layout.fillWidth: true
                spacing: 16

                P.Button {
                    id: ttBtn1
                    text: "Hover me (top)"
                    P.Tooltip {
                        parent: ttBtn1
                        text: "Appears above the trigger"
                        placement: "top"
                        visible: ttBtn1.hovered
                    }
                }

                P.Button {
                    id: ttBtn2
                    text: "Hover me (bottom)"
                    variant: "outline"
                    P.Tooltip {
                        parent: ttBtn2
                        text: "Appears below"
                        placement: "bottom"
                        visible: ttBtn2.hovered
                    }
                }

                P.Button {
                    id: ttBtn3
                    text: "Delayed 500 ms"
                    variant: "secondary"
                    P.Tooltip {
                        parent: ttBtn3
                        text: "Apple-HIG-style delay"
                        delay: 500
                        visible: ttBtn3.hovered
                    }
                }

                P.Button {
                    id: ttBtn4
                    text: "Disabled (no tooltip)"
                    enabled: false
                    P.Tooltip {
                        parent: ttBtn4
                        text: "You should not see this"
                        visible: ttBtn4.hovered && ttBtn4.enabled
                    }
                }
            }

            Flow {
                Layout.fillWidth: true
                spacing: 16

                P.Input {
                    id: ttInput
                    placeholderText: "Hover for hint"
                    Layout.preferredWidth: 240
                    P.Tooltip {
                        parent: ttInput
                        text: "This field accepts any non-empty string up to 80 characters and trims whitespace on save."
                        placement: "bottom"
                        maxWidth: 280
                        visible: ttInput.hovered
                    }
                }
            }
        }

        P.PearlText { variant: "title"; text: "Slider" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            RowLayout {
                spacing: 16
                P.PearlText { variant: "muted"; text: "Horizontal"; Layout.preferredWidth: 110 }
                P.Slider {
                    Layout.preferredWidth: 240
                    from: 0; to: 100; value: 50
                }
            }

            RowLayout {
                spacing: 16
                P.PearlText { variant: "muted"; text: "Ticks"; Layout.preferredWidth: 110 }
                P.Slider {
                    Layout.preferredWidth: 240
                    from: 0; to: 100; value: 60
                    stepSize: 10; showTicks: true
                }
            }

            RowLayout {
                spacing: 16
                P.PearlText { variant: "muted"; text: "Window/Level"; Layout.preferredWidth: 110 }
                P.Slider {
                    Layout.preferredWidth: 240
                    from: 0; to: 6000; value: 2048; stepSize: 50
                }
            }

            RowLayout {
                spacing: 16
                P.PearlText { variant: "muted"; text: "Disabled"; Layout.preferredWidth: 110 }
                P.Slider {
                    Layout.preferredWidth: 240
                    from: 0; to: 100; value: 35
                    enabled: false
                }
            }

            RowLayout {
                spacing: 32
                P.PearlText { variant: "muted"; text: "Vertical"; Layout.preferredWidth: 110 }
                P.Slider {
                    orientation: Qt.Vertical
                    Layout.preferredHeight: 160
                    from: 0; to: 100; value: 40
                }
                P.Slider {
                    orientation: Qt.Vertical
                    Layout.preferredHeight: 160
                    from: 0; to: 100; value: 70
                    stepSize: 10; showTicks: true
                }
            }
        }

        P.PearlText { variant: "title"; text: "StackedView" }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                spacing: 4
                Repeater {
                    model: ["Home", "Settings", "About"]
                    delegate: P.Button {
                        Layout.preferredWidth: 120
                        text: modelData
                        variant: stackIndex.currentIndex === index ? "secondary" : "ghost"
                        onClicked: stackIndex.currentIndex = index
                    }
                }
            }

            P.StackedView {
                id: stackIndex
                animated: true
                Layout.fillWidth: true
                Layout.preferredHeight: 140

                Rectangle {
                    radius: P.Tokens.radius.lg
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    P.PearlText {
                        anchors.centerIn: parent
                        variant: "heading"
                        text: "Home pane"
                    }
                }
                Rectangle {
                    radius: P.Tokens.radius.lg
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    P.PearlText {
                        anchors.centerIn: parent
                        variant: "heading"
                        text: "Settings pane"
                    }
                }
                Rectangle {
                    radius: P.Tokens.radius.lg
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    P.PearlText {
                        anchors.centerIn: parent
                        variant: "heading"
                        text: "About pane"
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                spacing: 4
                Repeater {
                    model: [
                        { label: "Inbox",    key: "inbox" },
                        { label: "Drafts",   key: "drafts" },
                        { label: "Archive",  key: "archive" }
                    ]
                    delegate: P.Button {
                        Layout.preferredWidth: 120
                        text: modelData.label
                        variant: stackKeyed.currentKey === modelData.key ? "secondary" : "ghost"
                        onClicked: stackKeyed.currentKey = modelData.key
                    }
                }
            }

            P.StackedView {
                id: stackKeyed
                animated: true
                currentKey: "drafts"
                Layout.fillWidth: true
                Layout.preferredHeight: 140

                Rectangle {
                    property string stackKey: "inbox"
                    radius: P.Tokens.radius.lg
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    P.PearlText {
                        anchors.centerIn: parent
                        variant: "heading"
                        text: "Inbox — keyed"
                    }
                }
                Rectangle {
                    property string stackKey: "drafts"
                    radius: P.Tokens.radius.lg
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    P.PearlText {
                        anchors.centerIn: parent
                        variant: "heading"
                        text: "Drafts — keyed"
                    }
                }
                Rectangle {
                    property string stackKey: "archive"
                    radius: P.Tokens.radius.lg
                    color: P.Tokens.card
                    border.color: P.Tokens.border
                    border.width: 1
                    P.PearlText {
                        anchors.centerIn: parent
                        variant: "heading"
                        text: "Archive — keyed"
                    }
                }
            }
        }

        P.PearlText { variant: "title"; text: "TabBar" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            RowLayout {
                spacing: 12
                P.PearlText { variant: "muted"; text: "Default"; Layout.preferredWidth: 110 }
                P.TabBar {
                    Layout.preferredWidth: 360
                    P.TabButton { text: "Overview" }
                    P.TabButton { text: "Analytics" }
                    P.TabButton { text: "Reports" }
                    P.TabButton { text: "Notifications" }
                }
            }

            RowLayout {
                spacing: 12
                P.PearlText { variant: "muted"; text: "Line"; Layout.preferredWidth: 110 }
                P.TabBar {
                    variant: "line"
                    Layout.preferredWidth: 360
                    P.TabButton { text: "Code" }
                    P.TabButton { text: "Issues" }
                    P.TabButton { text: "Pull requests" }
                    P.TabButton { text: "Wiki" }
                }
            }

            RowLayout {
                spacing: 12
                P.PearlText { variant: "muted"; text: "Non-expanding"; Layout.preferredWidth: 110 }
                P.TabBar {
                    variant: "line"
                    expanding: false
                    Layout.preferredWidth: 500
                    P.TabButton { text: "report.pdf"; closable: true }
                    P.TabButton { text: "untitled-1.txt"; closable: true }
                    P.TabButton { text: "implant-plan.dali"; closable: true }
                }
            }

            RowLayout {
                spacing: 12
                P.PearlText { variant: "muted"; text: "Disabled"; Layout.preferredWidth: 110 }
                P.TabBar {
                    enabled: false
                    Layout.preferredWidth: 360
                    P.TabButton { text: "One" }
                    P.TabButton { text: "Two" }
                    P.TabButton { text: "Three" }
                }
            }
        }

        P.PearlText { variant: "title"; text: "NavItem" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            // 13-tab sidebar example mirroring settings_dialog.py usage
            RowLayout {
                Layout.fillWidth: true
                spacing: 24

                Rectangle {
                    Layout.preferredWidth: 220
                    Layout.preferredHeight: 13 * 32 + 12 * 4 + 24
                    color: P.Tokens.muted
                    radius: P.Tokens.radius.lg
                    border.color: P.Tokens.border
                    border.width: 1

                    ColumnLayout {
                        id: settingsNav
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 4

                        property int currentTab: 0
                        property var labels: [
                            "General", "Appearance", "Editor", "Files",
                            "Network", "Privacy", "Updates", "Accounts",
                            "Shortcuts", "Extensions", "Integrations", "Telemetry",
                            "About"
                        ]

                        Repeater {
                            model: settingsNav.labels
                            delegate: P.NavItem {
                                Layout.fillWidth: true
                                text: modelData
                                active: index === settingsNav.currentTab
                                onClicked: settingsNav.currentTab = index
                            }
                        }
                    }
                }

                P.PearlText {
                    Layout.alignment: Qt.AlignTop
                    variant: "muted"
                    text: "Tab: " + settingsNav.labels[settingsNav.currentTab]
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 24

                ColumnLayout {
                    Layout.preferredWidth: 200
                    spacing: 4
                    P.PearlText { variant: "muted"; text: "sm" }
                    P.NavItem { Layout.fillWidth: true; size: "sm"; text: "Compact row" }
                    P.NavItem { Layout.fillWidth: true; size: "sm"; text: "Active"; active: true }
                }
                ColumnLayout {
                    Layout.preferredWidth: 200
                    spacing: 4
                    P.PearlText { variant: "muted"; text: "default" }
                    P.NavItem { Layout.fillWidth: true; text: "Standard row" }
                    P.NavItem { Layout.fillWidth: true; text: "Active"; active: true }
                }
                ColumnLayout {
                    Layout.preferredWidth: 200
                    spacing: 4
                    P.PearlText { variant: "muted"; text: "lg" }
                    P.NavItem { Layout.fillWidth: true; size: "lg"; text: "Roomy row" }
                    P.NavItem { Layout.fillWidth: true; size: "lg"; text: "Active"; active: true }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 220
                spacing: 4
                P.PearlText { variant: "muted"; text: "disabled" }
                P.NavItem { Layout.fillWidth: true; text: "Inactive disabled"; enabled: false }
                P.NavItem { Layout.fillWidth: true; text: "Active disabled"; enabled: false; active: true }
            }
        }

        P.PearlText { variant: "title"; text: "IconStrip" }

        RowLayout {
            Layout.fillWidth: true
            spacing: 24

            P.IconStrip {
                Layout.preferredHeight: 360
                activeKey: stripDemo.activeKey
                items: [
                    { key: "viewer",       iconSource: "", label: "View" },
                    { key: "segmentation", iconSource: "", label: "Segment" },
                    { key: "implant",      iconSource: "", label: "Implant" },
                    { key: "analysis",     iconSource: "", label: "Analysis" }
                ]
                footerItems: [
                    { key: "ai",       iconSource: "", label: "AI" },
                    { key: "settings", iconSource: "", label: "Settings" }
                ]
                onItemClicked: function(key) { stripDemo.activeKey = key }
            }

            QtObject {
                id: stripDemo
                property string activeKey: "viewer"
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                P.PearlText { variant: "heading"; text: "Mode switcher" }
                P.PearlText { variant: "muted"; text: "Active: " + stripDemo.activeKey }
                P.PearlText {
                    variant: "muted"
                    wrapMode: Text.WordWrap
                    Layout.preferredWidth: 360
                    text: "Generic 48 px sidebar nav. items drives the top section, footerItems pins to the bottom, activeKey is controlled by the consumer. Click any tile to re-bind activeKey via the itemClicked(key) signal."
                }
            }

            P.IconStrip {
                Layout.preferredHeight: 280
                showLabels: false
                activeKey: "implant"
                items: [
                    { key: "viewer",       iconSource: "", label: "View" },
                    { key: "segmentation", iconSource: "", label: "Segment" },
                    { key: "implant",      iconSource: "", label: "Implant" }
                ]
            }
        }

        P.PearlText { variant: "title"; text: "Avatar" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            P.PearlText {
                variant: "muted"
                text: "Sizes (sm 24 / default 32 / lg 40)"
            }
            RowLayout {
                spacing: 12
                P.Avatar { size: "sm";      initials: "OD" }
                P.Avatar { size: "default"; initials: "OD" }
                P.Avatar { size: "lg";      initials: "OD" }
            }

            P.PearlText {
                variant: "muted"
                text: "Role variants (default / primary / secondary)"
            }
            RowLayout {
                spacing: 12
                P.Avatar { variant: "default";   initials: "?" }
                P.Avatar { variant: "primary";   initials: "AI" }
                P.Avatar { variant: "secondary"; initials: "OD" }
            }

            P.PearlText {
                variant: "muted"
                text: "Chat layout — assistant (primary) vs user (secondary)"
            }
            ColumnLayout {
                spacing: 8
                RowLayout {
                    spacing: 8
                    P.Avatar { variant: "primary"; initials: "AI" }
                    P.PearlText {
                        Layout.preferredWidth: 420
                        wrapMode: Text.WordWrap
                        text: "Sure — here's how you can wire an Avatar into your chat UI. Pair it with PearlText on the right for the message body."
                    }
                }
                RowLayout {
                    spacing: 8
                    P.Avatar { variant: "secondary"; initials: "OD" }
                    P.PearlText {
                        Layout.preferredWidth: 420
                        wrapMode: Text.WordWrap
                        text: "How do I build a chat view with a role indicator on each row?"
                    }
                }
            }

            P.PearlText {
                variant: "muted"
                text: "Disabled (50% opacity)"
            }
            RowLayout {
                spacing: 12
                P.Avatar { enabled: false; initials: "OD" }
                P.Avatar { enabled: false; variant: "primary"; initials: "AI" }
            }
        }

        P.PearlText { variant: "title"; text: "Menu" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            P.PearlText {
                variant: "muted"
                text: "Inline MenuBar — for real apps, assign to ApplicationWindow.menuBar."
            }

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

            P.PearlText {
                variant: "muted"
                text: "Right-click any of the cards below for a context menu."
            }

            Flow {
                Layout.fillWidth: true
                spacing: 12

                Repeater {
                    model: [
                        { label: "Document",   hint: "report.pdf" },
                        { label: "Image",      hint: "scan.png" },
                        { label: "Archive",    hint: "backup.zip" },
                        { label: "Annotation", hint: "notes.md" },
                        { label: "Plan",       hint: "implant.dali" }
                    ]
                    delegate: Rectangle {
                        id: cardRoot
                        width: 160
                        height: 72
                        radius: P.Tokens.radius.md
                        color: P.Tokens.muted
                        border.color: P.Tokens.border
                        border.width: 1

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 2
                            P.PearlText {
                                Layout.alignment: Qt.AlignHCenter
                                variant: "label"
                                text: modelData.label
                            }
                            P.PearlText {
                                Layout.alignment: Qt.AlignHCenter
                                variant: "muted"
                                text: modelData.hint
                            }
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
                            P.MenuItem { text: "Select &All"; shortcut: "Cmd+A" }
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

        P.PearlText { variant: "title"; text: "Badge" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            Flow {
                Layout.fillWidth: true
                spacing: 8
                P.Badge { text: "Default";     variant: "default" }
                P.Badge { text: "Secondary";   variant: "secondary" }
                P.Badge { text: "Destructive"; variant: "destructive" }
                P.Badge { text: "Outline";     variant: "outline" }
                P.Badge { text: "Ghost";       variant: "ghost" }
                P.Badge { text: "Link";        variant: "link" }
            }

            Flow {
                Layout.fillWidth: true
                spacing: 8
                P.Badge { text: "3 new" }
                P.Badge { text: "beta";      variant: "outline" }
                P.Badge { text: "v2.4.0";    variant: "secondary" }
                P.Badge { text: "failed";    variant: "destructive" }
                P.Badge { text: "streaming"; variant: "ghost" }
            }

            Flow {
                Layout.fillWidth: true
                spacing: 8
                P.Badge { text: "Disabled";         enabled: false }
                P.Badge { text: "Disabled outline"; variant: "outline"; enabled: false }
            }
        }

        P.PearlText { variant: "title"; text: "CodeBlock" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            P.CodeBlock {
                Layout.fillWidth: true
                Layout.preferredWidth: 520
                filename: "greet.ts"
                language: "typescript"
                code: "const greet = (name: string) => `Hello, ${name}!`\\nconsole.log(greet(\\"world\\"))\\n"
            }

            P.CodeBlock {
                Layout.fillWidth: true
                Layout.preferredWidth: 520
                filename: "install.sh"
                language: "bash"
                code: "$ pip install pearl-kit\\n$ uv run python examples/gallery.py\\n"
            }

            P.CodeBlock {
                Layout.fillWidth: true
                Layout.preferredWidth: 520
                code: "// no header, no copy button — read-only display\\nreturn 42;\\n"
                showCopyButton: false
            }

            P.CodeBlock {
                Layout.fillWidth: true
                Layout.preferredWidth: 520
                filename: "server.py"
                language: "python"
                maxBodyHeight: 160
                code: "from fastapi import FastAPI\\n\\napp = FastAPI()\\n\\n@app.get(\\"/\\")\\ndef read_root():\\n    return {\\"hello\\": \\"world\\"}\\n\\n@app.get(\\"/items/{item_id}\\")\\ndef read_item(item_id: int, q: str | None = None):\\n    return {\\"item_id\\": item_id, \\"q\\": q}\\n\\n# wide line:  this_is_a_very_long_comment_that_should_cause_the_horizontal_scrollbar_to_appear_when_the_content_exceeds_the_viewport_width\\n"
            }
        }

        P.PearlText { variant: "title"; text: "DetachableTabView" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            P.PearlText {
                variant: "muted"
                text: "Double-click a tab to pop it out to a floating window. Close or dock the window to re-dock."
            }

            P.DetachableTabView {
                id: dtv
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                variant: "line"

                P.DetachableTab {
                    title: "Home"
                    stackKey: "home"
                    permanent: true

                    Rectangle {
                        anchors.fill: parent
                        color: P.Tokens.card
                        border.color: P.Tokens.border
                        border.width: 1
                        radius: P.Tokens.radius.md

                        P.PearlText {
                            anchors.centerIn: parent
                            text: "Home — permanent, cannot detach"
                            variant: "label"
                        }
                    }
                }

                P.DetachableTab {
                    title: "Viewer"
                    stackKey: "viewer"

                    Rectangle {
                        anchors.fill: parent
                        color: P.Tokens.card
                        border.color: P.Tokens.border
                        border.width: 1
                        radius: P.Tokens.radius.md

                        P.PearlText {
                            anchors.centerIn: parent
                            text: "Viewer — double-click the tab to detach"
                            variant: "label"
                        }
                    }
                }

                P.DetachableTab {
                    title: "Editor"
                    stackKey: "editor"

                    Rectangle {
                        anchors.fill: parent
                        color: P.Tokens.card
                        border.color: P.Tokens.border
                        border.width: 1
                        radius: P.Tokens.radius.md

                        P.PearlText {
                            anchors.centerIn: parent
                            text: "Editor — also detachable"
                            variant: "label"
                        }
                    }
                }

                P.DetachableTab {
                    title: "Settings"
                    stackKey: "settings"
                    nonDetachable: true

                    Rectangle {
                        anchors.fill: parent
                        color: P.Tokens.card
                        border.color: P.Tokens.border
                        border.width: 1
                        radius: P.Tokens.radius.md

                        P.PearlText {
                            anchors.centerIn: parent
                            text: "Settings — non-detachable"
                            variant: "label"
                        }
                    }
                }
            }

            Row {
                spacing: 8
                P.Button {
                    text: "Detach Viewer"
                    variant: "outline"
                    onClicked: dtv.detachTabByKey("viewer")
                }
                P.Button {
                    text: "Close all floating"
                    variant: "ghost"
                    onClicked: dtv.closeAllFloating()
                }
            }
        }

        P.PearlText { variant: "title"; text: "ListView" }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                ColumnLayout {
                    Layout.preferredWidth: 240
                    spacing: 6
                    P.PearlText { variant: "muted"; text: "String model (recent files)" }
                    P.ListView {
                        Layout.preferredWidth: 240
                        Layout.preferredHeight: 220
                        currentIndex: 0
                        model: [
                            "plan-2026-04-18.dali",
                            "scan-left.dcm",
                            "scan-right.dcm",
                            "notes.md",
                            "export.pdf",
                            "archive.zip"
                        ]
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: 300
                    spacing: 6
                    P.PearlText { variant: "muted"; text: "Object model with trailing" }
                    P.ListView {
                        Layout.preferredWidth: 300
                        Layout.preferredHeight: 220
                        model: [
                            { label: "Implant #1", trailing: "4.2 x 11 mm" },
                            { label: "Implant #2", trailing: "3.8 x 10 mm" },
                            { label: "Implant #3", trailing: "5.0 x 13 mm" },
                            { label: "Implant #4 (locked)", trailing: "—", enabled: false },
                            { label: "Implant #5", trailing: "4.2 x 12 mm" }
                        ]
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: 260
                    spacing: 6
                    P.PearlText { variant: "muted"; text: "Separators (log entries)" }
                    P.ListView {
                        Layout.preferredWidth: 260
                        Layout.preferredHeight: 220
                        showSeparators: true
                        model: [
                            "10:00:01 boot: app started",
                            "10:00:02 engine: ok",
                            "10:00:03 plan: low density",
                            "10:00:04 export: collision",
                            "10:00:05 auto-save: plan.json"
                        ]
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                ColumnLayout {
                    Layout.preferredWidth: 280
                    spacing: 6
                    P.PearlText { variant: "muted"; text: "Flush inside Card" }
                    P.Card {
                        Layout.preferredWidth: 280
                        padding: 8
                        P.ListView {
                            Layout.preferredWidth: 264
                            Layout.preferredHeight: 180
                            variant: "flush"
                            model: ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
                        }
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: 240
                    spacing: 6
                    P.PearlText { variant: "muted"; text: "Empty state" }
                    P.ListView {
                        Layout.preferredWidth: 240
                        Layout.preferredHeight: 180
                        emptyText: "No recent files"
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: 240
                    spacing: 6
                    P.PearlText { variant: "muted"; text: "Disabled" }
                    P.ListView {
                        Layout.preferredWidth: 240
                        Layout.preferredHeight: 180
                        enabled: false
                        model: ["Read only", "No hover", "No selection"]
                    }
                }
            }
        }

        }
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

    P.MessageBox {
        id: mbInfo
        variant: "info"
        heading: "Saved successfully"
        message: "Your changes have been written to the project file."
    }

    P.MessageBox {
        id: mbWarning
        variant: "warning"
        heading: "Unsaved changes"
        message: "You have unsaved work. Switching projects will discard these edits."
    }

    P.MessageBox {
        id: mbError
        variant: "error"
        heading: "Failed to load file"
        message: "The file is corrupted or uses an unsupported format."
    }

    P.MessageBox {
        id: mbConfirm
        variant: "confirm"
        heading: "Delete annotation?"
        message: "This will permanently remove the implant placement from the current case."
        okText: "Delete"
        okVariant: "destructive"
        cancelText: "Keep"
    }

    P.ToasterHost { }
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
