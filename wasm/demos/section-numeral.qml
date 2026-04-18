import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        P.SectionNumeral { numeral: "I";   label: "Anatomy & Placement" }
        P.SectionNumeral { numeral: "II";  label: "Safety Zones" }
        P.SectionNumeral { numeral: "III"; label: "Prosthetic Planning" }
        P.SectionNumeral { numeral: "IV";  label: "Approval & Export" }
    }
}
