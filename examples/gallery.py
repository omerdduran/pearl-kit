"""pearl-kit gallery — showcases Button, Input, Toggle, Select, CheckBox, Stepper, Text, Dialog, MessageBox, GroupBox, Separator, Card, FormRow, Splitter, ScrollArea, ProgressBar, Spinner, StatusBar, Toast, Tooltip, and Slider."""

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
    height: 1200
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
