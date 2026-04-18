import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        P.PearlText { variant: "muted"; text: "Sizes and states" }
        Flow {
            Layout.fillWidth: true
            spacing: 12
            P.Select { model: ["Apple", "Banana", "Cherry", "Date"] }
            P.Select {
                size: "sm"
                model: ["sm", "md", "lg", "xl"]
            }
            P.Select {
                error: true
                model: ["invalid option"]
            }
            P.Select {
                enabled: false
                model: ["disabled"]
            }
        }

        P.PearlText { variant: "muted"; text: "Grouped + separators" }
        P.Select {
            Layout.preferredWidth: 260
            textRole: "text"
            valueRole: "value"
            model: ListModel {
                ListElement { type: "header"; text: "Latin"; value: "" }
                ListElement { type: "item";   text: "English";    value: "en" }
                ListElement { type: "item";   text: "Türkçe";     value: "tr" }
                ListElement { type: "item";   text: "Deutsch";    value: "de" }
                ListElement { type: "separator"; text: ""; value: "" }
                ListElement { type: "header"; text: "CJK"; value: "" }
                ListElement { type: "item";   text: "日本語";      value: "ja" }
                ListElement { type: "item";   text: "中文";        value: "zh" }
            }
        }
    }
}
