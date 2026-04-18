import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        Layout.maximumWidth: 520

        P.PearlText { variant: "muted"; text: "Mono values (IDs, codes, measurements)" }
        P.MetaRow { Layout.fillWidth: true; label: "CASE";    value: "A-0042";   valueMono: true }
        P.MetaRow { Layout.fillWidth: true; label: "SCANNER"; value: "GALILEOS"; valueMono: true }
        P.MetaRow { Layout.fillWidth: true; label: "HU";      value: "248";      valueMono: true }

        P.PearlText { variant: "muted"; text: "Sans values (names, prose)" }
        P.MetaRow { Layout.fillWidth: true; label: "PATIENT"; value: "Jane Foster";   valueMono: false }
        P.MetaRow { Layout.fillWidth: true; label: "DOCTOR";  value: "Dr. Ömer Duran"; valueMono: false }
        P.MetaRow { Layout.fillWidth: true; label: "NOTE";    value: "Low bone density region"; valueMono: false }
    }
}
