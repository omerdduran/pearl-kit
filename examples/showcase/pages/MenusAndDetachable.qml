import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Menus & Detachable"
    subtitle: "Menus, menu items, and detachable tab containers."
    gridPreset: "two-col"

    ShowcaseTile {
        label: "Menu (collapsed)"
        Item {
            width: 240
            height: 32
            PearlText { anchors.centerIn: parent; text: "Menu — instantiated as popup"; variant: "muted" }
        }
    }
    ShowcaseTile {
        label: "MenuItem"
        MenuItem {
            width: 240
            text: "Open File…"
        }
    }
    ShowcaseTile {
        label: "MenuSeparator"
        MenuSeparator { width: 240 }
    }
    ShowcaseTile {
        label: "DetachableTabView"
        DetachableTabView {
            width: 360
            height: 200
        }
    }
    ShowcaseTile {
        label: "FloatingWindow (placeholder)"
        Item {
            width: 240
            height: 60
            PearlText {
                anchors.centerIn: parent
                text: "Detached window — opens at runtime"
                variant: "muted"
            }
        }
    }
}
