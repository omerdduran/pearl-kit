import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    RowLayout {
        anchors.fill: parent
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
                text: "Generic 48 px sidebar nav. items drives the top section, footerItems pins to the bottom, activeKey is controlled by the consumer."
            }
        }

        P.IconStrip {
            Layout.preferredHeight: 260
            showLabels: false
            activeKey: "implant"
            items: [
                { key: "viewer",       iconSource: "", label: "View" },
                { key: "segmentation", iconSource: "", label: "Segment" },
                { key: "implant",      iconSource: "", label: "Implant" }
            ]
        }
    }
}
