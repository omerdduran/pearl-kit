import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    Row {
        anchors.centerIn: parent
        spacing: 16

        P.PlanCard {
            title: "Solo Clinician"
            price: "\u20AC180"
        }

        P.PlanCard {
            title: "Practice"
            price: "\u20AC480"
        }
    }
}
