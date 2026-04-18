import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
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
        }

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
