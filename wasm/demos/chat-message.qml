import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12
        Layout.maximumWidth: 560

        P.ChatMessage {
            Layout.fillWidth: true
            role: "user"
            author: "DR. KAYA"
            text: "What's the safest angulation for #15 given the low bone height?"
        }
        P.ChatMessage {
            Layout.fillWidth: true
            role: "ai"
            author: "DALI"
            text: "At 10 mm bone height I recommend angulating the implant 8–10° distally to preserve IAN clearance while keeping the prosthetic screw access within the cusp."
            actionLabel: "Apply 8°"
        }
        P.ChatMessage {
            Layout.fillWidth: true
            role: "user"
            author: "DR. KAYA"
            text: "Run the risk check once more."
        }
        P.ChatMessage {
            Layout.fillWidth: true
            role: "ai"
            author: "DALI"
            text: "All clearances green. IAN 3.2 mm, sinus 8.1 mm, buccal 1.3 mm. Ready for approval."
        }
    }
}
