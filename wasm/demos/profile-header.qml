import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    P.ProfileHeader {
        anchors.centerIn: parent
        width: 540
        initials: "MK"
        name: "Dr. Mehmet Kaya"
        title: "Oral & Maxillofacial Surgeon"
        stats: [
            { key: "LICENSE", value: "TR-DDS-21487" },
            { key: "SINCE",   value: "MAR 2024" },
            { key: "PLANS",   value: "1,247" }
        ]
    }
}
