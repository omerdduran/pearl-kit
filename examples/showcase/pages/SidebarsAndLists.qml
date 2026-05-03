import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Sidebars & Lists"
    subtitle: "Vertical navigation surfaces and list delegates."
    gridPreset: "two-col"

    ShowcaseTile {
        label: "NavItem"
        NavItem { width: 240; text: "Settings" }
    }
    ShowcaseTile {
        label: "NavItem — active"
        NavItem { width: 240; text: "Dashboard"; active: true }
    }
    ShowcaseTile {
        label: "NumberedNavItem"
        NumberedNavItem {
            width: 240
        }
    }
    ShowcaseTile {
        label: "IconStrip"
        IconStrip {
            width: 48
            height: 240
        }
    }
    ShowcaseTile {
        label: "StackedView"
        StackedView {
            width: 320
            height: 160
        }
    }
    ShowcaseTile {
        label: "ListView"
        ListView {
            width: 320
            height: 160
            model: 5
            delegate: NavItem { width: ListView.view.width; text: "Row " + (index + 1) }
        }
    }
}
