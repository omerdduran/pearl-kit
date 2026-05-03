import QtCore
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import PearlKit 1.0

ApplicationWindow {
    id: shell
    width: 1440
    height: 900
    visible: true
    title: "PearlKit Showcase"
    color: Tokens.background

    property string activeCategory: prefs.lastCategory
    onActiveCategoryChanged: prefs.lastCategory = activeCategory

    Settings {
        id: prefs
        category: "PearlKit.Showcase"
        property string lastCategory: "Tokens & Theme"
    }

    readonly property var _qmlMap: ({
        "Tokens & Theme":      "pages/TokensAndTheme.qml",
        "Typography":          "pages/Typography.qml",
        "Buttons":             "pages/Buttons.qml",
        "Text Inputs":         "pages/TextInputs.qml",
        "Selection Controls":  "pages/SelectionControls.qml",
        "Sliders & Steppers":  "pages/SlidersAndSteppers.qml",
        "Containers":          "pages/Containers.qml",
        "Form Rows":           "pages/FormRows.qml",
        "Bars":                "pages/Bars.qml",
        "Sidebars & Lists":    "pages/SidebarsAndLists.qml",
        "Menus & Detachable":  "pages/MenusAndDetachable.qml",
        "Status Indicators":   "pages/StatusIndicators.qml",
        "Progress":            "pages/Progress.qml",
        "Overlays":            "pages/Overlays.qml",
        "Cards":               "pages/Cards.qml",
        "Tables & Grids":      "pages/TablesAndGrids.qml",
        "People":              "pages/People.qml",
        "Clinical Primitives": "pages/ClinicalPrimitives.qml",
        "Chat & Assistant":    "pages/ChatAndAssistant.qml",
        "Onboarding & Steps":  "pages/OnboardingAndSteps.qml",
        "Audit & Editorial":   "pages/AuditAndEditorial.qml"
    })

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ---- sidebar
        Rectangle {
            id: _sidebar
            Layout.preferredWidth: 280
            Layout.fillHeight: true
            color: Tokens.card
            border.color: Tokens.border
            border.width: 0

            Rectangle {
                width: 1
                height: parent.height
                anchors.right: parent.right
                color: Tokens.border
            }

            Flickable {
                anchors.fill: parent
                anchors.margins: Tokens.space.x4
                anchors.rightMargin: Tokens.space.x3
                contentWidth: width
                contentHeight: _navColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: _navColumn
                    width: parent.width
                    spacing: Tokens.space.x4

                    // FOUNDATIONS
                    CollapsibleNavGroup {
                        width: parent.width
                        header: "FOUNDATIONS"
                        persistKey: "showcase.foundations"
                        NavItem {
                            width: parent.width
                            text: "Tokens & Theme"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Typography"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                    }

                    // FORM PRIMITIVES
                    CollapsibleNavGroup {
                        width: parent.width
                        header: "FORM PRIMITIVES"
                        persistKey: "showcase.formPrimitives"
                        NavItem {
                            width: parent.width
                            text: "Buttons"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Text Inputs"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Selection Controls"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Sliders & Steppers"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                    }

                    // LAYOUT & STRUCTURE
                    CollapsibleNavGroup {
                        width: parent.width
                        header: "LAYOUT & STRUCTURE"
                        persistKey: "showcase.layoutStructure"
                        NavItem {
                            width: parent.width
                            text: "Containers"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Form Rows"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                    }

                    // NAVIGATION
                    CollapsibleNavGroup {
                        width: parent.width
                        header: "NAVIGATION"
                        persistKey: "showcase.navigation"
                        NavItem {
                            width: parent.width
                            text: "Bars"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Sidebars & Lists"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Menus & Detachable"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                    }

                    // FEEDBACK
                    CollapsibleNavGroup {
                        width: parent.width
                        header: "FEEDBACK"
                        persistKey: "showcase.feedback"
                        NavItem {
                            width: parent.width
                            text: "Status Indicators"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Progress"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Overlays"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                    }

                    // DATA DISPLAY
                    CollapsibleNavGroup {
                        width: parent.width
                        header: "DATA DISPLAY"
                        persistKey: "showcase.dataDisplay"
                        NavItem {
                            width: parent.width
                            text: "Cards"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Tables & Grids"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "People"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                    }

                    // DOMAIN
                    CollapsibleNavGroup {
                        width: parent.width
                        header: "DOMAIN"
                        persistKey: "showcase.domain"
                        NavItem {
                            width: parent.width
                            text: "Clinical Primitives"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Chat & Assistant"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Onboarding & Steps"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                        NavItem {
                            width: parent.width
                            text: "Audit & Editorial"
                            active: shell.activeCategory === text
                            onClicked: shell.activeCategory = text
                        }
                    }
                }
            }
        }

        // ---- content area
        Loader {
            id: _pageLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: {
                const path = shell._qmlMap[shell.activeCategory]
                return path ? path : ""
            }
            asynchronous: false
            onStatusChanged: {
                if (status === Loader.Error) {
                    console.warn("Showcase: failed to load page for '" + shell.activeCategory + "'")
                }
            }
        }
    }
}
