import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    id: control

    signal openStudy(int index)
    signal exportStudy(int index)
    signal importCbct()

    property var cases: [
        { mrn: "2041-04", pt: "Y\u0131lmaz, Ay\u015Fe",  sex: "F", age: 54, dob: "1972\u201103\u201114",
          acq: "2026\u201104\u201117 \u00B7 08:22", site: "#22", proc: "Single implant",
          dose: "142 mGy\u00B7cm\u00B2", state: "ready", by: "M. \u00D6zdemir", thumb: "3d" },
        { mrn: "2039-04", pt: "Demir, Mehmet", sex: "M", age: 61, dob: "1965\u201111\u201102",
          acq: "2026\u201104\u201117 \u00B7 09:05", site: "#36 #37", proc: "Multi implant",
          dose: "168 mGy\u00B7cm\u00B2", state: "processing", by: "M. \u00D6zdemir", thumb: "axial" },
        { mrn: "2037-04", pt: "Kaya, Selin", sex: "F", age: 42, dob: "1984\u201106\u201128",
          acq: "2026\u201104\u201116 \u00B7 16:48", site: "#14", proc: "Sinus lift",
          dose: "156 mGy\u00B7cm\u00B2", state: "reviewed", by: "A. Aksoy", thumb: "coronal" },
        { mrn: "2035-04", pt: "\u00D6zt\u00FCrk, Can", sex: "M", age: 38, dob: "1988\u201101\u201119",
          acq: "2026\u201104\u201116 \u00B7 11:10", site: "#46", proc: "Bridge abutment",
          dose: "138 mGy\u00B7cm\u00B2", state: "ready", by: "M. \u00D6zdemir", thumb: "3d" },
        { mrn: "2033-04", pt: "Arslan, Deniz", sex: "M", age: 29, dob: "1997\u201108\u201104",
          acq: "2026\u201104\u201115 \u00B7 14:30", site: "#48", proc: "Third molar",
          dose: "124 mGy\u00B7cm\u00B2", state: "reviewed", by: "A. Aksoy", thumb: "sagittal" },
        { mrn: "2031-04", pt: "\u015Eahin, Elif", sex: "F", age: 47, dob: "1979\u201102\u201111",
          acq: "2026\u201104\u201114 \u00B7 10:15", site: "Full arch", proc: "All\u2011on\u20114 planning",
          dose: "184 mGy\u00B7cm\u00B2", state: "ready", by: "M. \u00D6zdemir", thumb: "3d" },
    ]

    property int selectedIndex: 0
    property string searchText: ""
    property string filterKey: "all"

    readonly property var _filtered: {
        const q = control.searchText.toLowerCase()
        return control.cases.filter(function (c) {
            if (control.filterKey !== "all" && c.state !== control.filterKey) return false
            if (q === "") return true
            return c.pt.toLowerCase().indexOf(q) >= 0
                || c.mrn.indexOf(q) >= 0
                || c.site.toLowerCase().indexOf(q) >= 0
        })
    }
    readonly property var _selected: _filtered.length > 0
        ? _filtered[Math.min(control.selectedIndex, _filtered.length - 1)]
        : control.cases[0]

    function _stateStrip(s) {
        switch (s) { case "processing": return "#F59E0B"; case "reviewed": return "#10B981"; default: return "#2563EB" }
    }

    implicitWidth: 1280
    implicitHeight: 800

    Rectangle { anchors.fill: parent; color: "#FAFBFC" }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ── LEFT RAIL ───────────────────────────────────────
        Rectangle {
            Layout.preferredWidth: 232
            Layout.fillHeight: true
            color: "#FFFFFF"

            Rectangle {
                anchors.top: parent.top; anchors.right: parent.right; anchors.bottom: parent.bottom
                width: 1; color: "#ECEEF2"
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                anchors.topMargin: 20
                spacing: 0

                // brand block
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    P.BrandTile { tileSize: 28; iconSize: 16 }
                    ColumnLayout {
                        spacing: 3
                        Text {
                            text: "DALI"
                            color: "#1A202C"
                            font.family: "DM Serif Display"
                            font.pixelSize: 18
                            font.letterSpacing: -0.18
                            lineHeight: 1.0
                            lineHeightMode: Text.ProportionalHeight
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }
                        Text {
                            text: "3.2.1 \u00B7 CLINICAL"
                            color: "#8A93A0"
                            font.family: "JetBrains Mono"
                            font.pixelSize: 9
                            font.letterSpacing: 0.54
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }
                    }
                    Item { Layout.fillWidth: true }
                }

                Item { Layout.preferredHeight: 24 }

                P.Button {
                    Layout.fillWidth: true
                    text: "+   Import CBCT"
                    variant: "default"
                    onClicked: control.importCbct()
                }

                Item { Layout.preferredHeight: 24 }

                P.SectionLabel { text: "Filter"; fontFamily: "JetBrains Mono" }

                Item { Layout.preferredHeight: 8 }

                Repeater {
                    model: [
                        { k: "all",        label: "All studies"         },
                        { k: "ready",      label: "Ready for planning"  },
                        { k: "processing", label: "AI processing"       },
                        { k: "reviewed",   label: "Reviewed"            },
                    ]
                    delegate: P.FilterRow {
                        required property var modelData
                        Layout.fillWidth: true
                        label: modelData.label
                        active: control.filterKey === modelData.k
                        stripColor: control._stateStrip(modelData.k)
                        monoFontFamily: "JetBrains Mono"
                        sansFontFamily: "Plus Jakarta Sans"
                        count: modelData.k === "all"
                            ? control.cases.length
                            : control.cases.filter(function (c) { return c.state === modelData.k }).length
                        onClicked: {
                            control.filterKey = modelData.k
                            control.selectedIndex = 0
                        }
                    }
                }

                Item { Layout.preferredHeight: 16 }

                P.SectionLabel { text: "Site"; fontFamily: "JetBrains Mono" }

                Item { Layout.preferredHeight: 8 }

                Repeater {
                    model: [
                        { label: "\u00D6zdemir Oral Surgery", dot: "#2563EB" },
                        { label: "Aksoy Maxillofacial",       dot: "#10B981" },
                    ]
                    delegate: RowLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.preferredHeight: 28
                        spacing: 8
                        Item { Layout.preferredWidth: 2 }
                        Rectangle {
                            width: 6; height: 6; radius: 3
                            color: modelData.dot
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            text: modelData.label
                            color: "#4A5568"
                            font.family: "Plus Jakarta Sans"
                            font.pixelSize: 13
                            renderType: Text.NativeRendering
                            antialiasing: true
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                P.InfoCard {
                    Layout.fillWidth: true
                    tone: "info"

                    Row {
                        spacing: 6
                        Rectangle { width: 6; height: 6; radius: 3; color: "#10B981"; anchors.verticalCenter: parent.verticalCenter }
                        Text {
                            text: "AI engine \u00B7 online"
                            color: "#1D4ED8"
                            font.family: "JetBrains Mono"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            renderType: Text.NativeRendering
                            antialiasing: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    Text {
                        text: "Synced 2 min ago"
                        color: "#1E3A8A"
                        font.family: "JetBrains Mono"
                        font.pixelSize: 11
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                    Text {
                        text: "License \u00B7 clinical"
                        color: "#1E3A8A"
                        font.family: "JetBrains Mono"
                        font.pixelSize: 11
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                }
            }
        }

        // ── MAIN TABLE ────────────────────────────────────
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // header
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 92
                    Rectangle {
                        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
                        height: 1; color: "#ECEEF2"
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 28
                        anchors.rightMargin: 28
                        anchors.topMargin: 20
                        anchors.bottomMargin: 16
                        spacing: 20

                        ColumnLayout {
                            Layout.alignment: Qt.AlignBottom
                            spacing: 6
                            Text {
                                text: "STUDIES \u00B7 17.04.2026"
                                color: "#2563EB"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 11
                                font.letterSpacing: 1.0
                                font.weight: Font.Medium
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }
                            Text {
                                text: "Case Library"
                                color: "#1A202C"
                                font.family: "DM Serif Display"
                                font.pixelSize: 30
                                font.letterSpacing: -0.45
                                lineHeight: 1.1
                                lineHeightMode: Text.ProportionalHeight
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }
                            Text {
                                text: control._filtered.length + " / " + control.cases.length + " studies"
                                color: "#6B7280"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 11
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }
                        }

                        Item { Layout.fillWidth: true }

                        P.SearchField {
                            id: search
                            Layout.alignment: Qt.AlignBottom
                            Layout.preferredWidth: 280
                            placeholderText: "Search by name, MRN, site\u2026"
                            fontFamily: "Plus Jakarta Sans"
                            monoFontFamily: "JetBrains Mono"
                            onTextChanged: control.searchText = text
                        }
                    }
                }

                // table header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    color: "#F7F8FA"
                    Rectangle {
                        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
                        height: 1; color: "#ECEEF2"
                    }
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 24
                        spacing: 0

                        Item { Layout.preferredWidth: 4 }
                        Item { Layout.preferredWidth: 68 }
                        HeaderCell { text: "Patient";     Layout.preferredWidth: 220 }
                        HeaderCell { text: "Acquisition"; Layout.preferredWidth: 170 }
                        HeaderCell { text: "Site";        Layout.preferredWidth: 90  }
                        HeaderCell { text: "Procedure";   Layout.preferredWidth: 160 }
                        HeaderCell { text: "Dose";        Layout.preferredWidth: 120 }
                        HeaderCell { text: "Status";      Layout.fillWidth: true }
                    }
                }

                // table body
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: control._filtered
                    interactive: true
                    spacing: 0

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        readonly property bool isSel: index === control.selectedIndex
                        readonly property color stripColor: control._stateStrip(modelData.state)

                        width: ListView.view ? ListView.view.width : 0
                        height: 60
                        color: isSel ? "#EFF6FF" : (index % 2 === 0 ? "#FFFFFF" : "#FCFCFD")

                        Behavior on color { ColorAnimation { duration: 120 } }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: control.selectedIndex = index
                        }

                        Rectangle {
                            visible: parent.isSel
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 4
                            color: parent.stripColor
                        }

                        Rectangle {
                            anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
                            height: 1; color: "#F4F5F8"
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 24
                            anchors.topMargin: 10
                            anchors.bottomMargin: 10
                            spacing: 0

                            Item { Layout.preferredWidth: 4 }

                            P.Thumb {
                                Layout.preferredWidth: 56
                                Layout.preferredHeight: 40
                                Layout.rightMargin: 12
                                kind: modelData.thumb
                                accent: parent.parent.isSel
                                monoFontFamily: "JetBrains Mono"
                            }

                            ColumnLayout {
                                Layout.preferredWidth: 220
                                spacing: 2
                                Text {
                                    text: modelData.pt
                                    color: "#1A202C"
                                    font.family: "Plus Jakarta Sans"
                                    font.pixelSize: 13
                                    font.weight: Font.Medium
                                    renderType: Text.NativeRendering
                                    antialiasing: true
                                }
                                Text {
                                    text: modelData.mrn + " \u00B7 DOB " + modelData.dob + " \u00B7 " + modelData.sex + " " + modelData.age
                                    color: "#8A93A0"
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 11
                                    renderType: Text.NativeRendering
                                    antialiasing: true
                                }
                            }

                            Text {
                                Layout.preferredWidth: 170
                                text: modelData.acq
                                color: "#4A5568"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 12
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }

                            Text {
                                Layout.preferredWidth: 90
                                text: modelData.site
                                color: "#1A202C"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 12
                                font.weight: Font.Medium
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }

                            Text {
                                Layout.preferredWidth: 160
                                text: modelData.proc
                                color: "#1A202C"
                                font.family: "Plus Jakarta Sans"
                                font.pixelSize: 13
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }

                            Text {
                                Layout.preferredWidth: 120
                                text: modelData.dose
                                color: "#4A5568"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 11
                                renderType: Text.NativeRendering
                                antialiasing: true
                            }

                            P.StatusPill {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignLeft
                                state: modelData.state
                                text: modelData.state === "processing" ? "Processing"
                                    : modelData.state === "reviewed"   ? "Reviewed"
                                                                       : "Ready"
                                fontFamily: "JetBrains Mono"
                            }
                        }
                    }
                }
            }
        }

        // ── RIGHT DETAIL PANEL ────────────────────────────
        Rectangle {
            Layout.preferredWidth: 360
            Layout.fillHeight: true
            color: "#FFFFFF"

            Rectangle {
                anchors.top: parent.top; anchors.left: parent.left; anchors.bottom: parent.bottom
                width: 1; color: "#ECEEF2"
            }

            ScrollView {
                id: detailScroll
                anchors.fill: parent
                clip: true
                padding: 20
                contentWidth: availableWidth

                ColumnLayout {
                    width: detailScroll.availableWidth
                    spacing: 0

                    Text {
                        text: "SELECTED STUDY"
                        color: "#2563EB"
                        font.family: "JetBrains Mono"
                        font.pixelSize: 10
                        font.letterSpacing: 1.0
                        font.weight: Font.Medium
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                    Item { Layout.preferredHeight: 6 }
                    Text {
                        text: control._selected.pt
                        color: "#1A202C"
                        font.family: "DM Serif Display"
                        font.pixelSize: 24
                        font.letterSpacing: -0.24
                        lineHeight: 1.15
                        lineHeightMode: Text.ProportionalHeight
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }
                    Item { Layout.preferredHeight: 6 }
                    Text {
                        text: control._selected.mrn + " \u00B7 " + control._selected.sex + " " + control._selected.age + " \u00B7 DOB " + control._selected.dob
                        color: "#6B7280"
                        font.family: "JetBrains Mono"
                        font.pixelSize: 11
                        renderType: Text.NativeRendering
                        antialiasing: true
                    }

                    Item { Layout.preferredHeight: 16 }

                    P.Render3D {
                        Layout.preferredWidth: 320
                        Layout.preferredHeight: 200
                        monoFontFamily: "JetBrains Mono"
                    }

                    Item { Layout.preferredHeight: 6 }

                    RowLayout {
                        spacing: 6
                        P.Thumb { Layout.preferredWidth: 102; Layout.preferredHeight: 70; kind: "axial";    monoFontFamily: "JetBrains Mono" }
                        P.Thumb { Layout.preferredWidth: 102; Layout.preferredHeight: 70; kind: "coronal";  monoFontFamily: "JetBrains Mono" }
                        P.Thumb { Layout.preferredWidth: 102; Layout.preferredHeight: 70; kind: "sagittal"; monoFontFamily: "JetBrains Mono" }
                    }

                    Item { Layout.preferredHeight: 18 }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 320
                        Layout.preferredHeight: 1
                        color: "#ECEEF2"
                    }

                    Item { Layout.preferredHeight: 14 }

                    P.MetaRow { Layout.preferredWidth: 320; label: "Site";        value: control._selected.site; valueMono: true;  monoFontFamily: "JetBrains Mono"; sansFontFamily: "Plus Jakarta Sans" }
                    P.MetaRow { Layout.preferredWidth: 320; label: "Procedure";   value: control._selected.proc; valueMono: false; monoFontFamily: "JetBrains Mono"; sansFontFamily: "Plus Jakarta Sans" }
                    P.MetaRow { Layout.preferredWidth: 320; label: "Acquisition"; value: control._selected.acq;  valueMono: true;  monoFontFamily: "JetBrains Mono"; sansFontFamily: "Plus Jakarta Sans" }
                    P.MetaRow { Layout.preferredWidth: 320; label: "Dose";        value: control._selected.dose; valueMono: true;  monoFontFamily: "JetBrains Mono"; sansFontFamily: "Plus Jakarta Sans" }
                    P.MetaRow { Layout.preferredWidth: 320; label: "Planner";     value: control._selected.by;   valueMono: false; monoFontFamily: "JetBrains Mono"; sansFontFamily: "Plus Jakarta Sans" }

                    Item { Layout.preferredHeight: 16 }

                    P.InfoCard {
                        Layout.preferredWidth: 320
                        tone: control._selected.state === "processing" ? "warning" : "info"

                        Row {
                            spacing: 8
                            Rectangle {
                                width: 8; height: 8; radius: 4
                                color: control._stateStrip(control._selected.state)
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: "AI pipeline"
                                color: "#1A202C"
                                font.family: "Plus Jakarta Sans"
                                font.pixelSize: 12
                                font.weight: Font.DemiBold
                                renderType: Text.NativeRendering
                                antialiasing: true
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Item { width: 80; height: 1 }
                            Text {
                                text: "dali\u2011seg\u2011v3.2"
                                color: "#6B7280"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 10
                                renderType: Text.NativeRendering
                                antialiasing: true
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Item { height: 4; width: 1 }

                        Repeater {
                            model: [
                                { label: "Volume",              value: "512\u00B3 \u00B7 0.3mm",        done: true },
                                { label: "Tooth segmentation",  value: "28/28 \u00B7 DICE 0.97",        done: true },
                                { label: "Mandibular canal",    value: "L+R \u00B7 1.8mm safety",       done: control._selected.state !== "processing" },
                                { label: "Implant proposal",
                                  value: control._selected.state === "processing" ? "computing\u2026" : "\u00D8 4.0 \u00D7 11.5",
                                  done: control._selected.state === "ready" },
                            ]
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 22
                                spacing: 8
                                Rectangle {
                                    width: 6; height: 6; radius: 3
                                    color: modelData.done ? "#10B981" : "#F59E0B"
                                    Layout.alignment: Qt.AlignVCenter
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.label
                                    color: "#4A5568"
                                    font.family: "Plus Jakarta Sans"
                                    font.pixelSize: 12
                                    renderType: Text.NativeRendering
                                    antialiasing: true
                                }
                                Text {
                                    text: modelData.value
                                    color: modelData.done ? "#1A202C" : "#B45309"
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 11
                                    renderType: Text.NativeRendering
                                    antialiasing: true
                                }
                            }
                        }
                    }

                    Item { Layout.preferredHeight: 16 }

                    RowLayout {
                        Layout.preferredWidth: 320
                        spacing: 8
                        P.Button {
                            Layout.fillWidth: true
                            text: "Open study \u2192"
                            variant: "default"
                            onClicked: control.openStudy(control.selectedIndex)
                        }
                        P.Button {
                            text: "Export"
                            variant: "outline"
                            onClicked: control.exportStudy(control.selectedIndex)
                        }
                    }

                    Item { Layout.preferredHeight: 20 }
                }
            }
        }
    }

    component HeaderCell : Text {
        color: "#6B7280"
        font.family: "JetBrains Mono"
        font.pixelSize: 10
        font.weight: Font.Medium
        font.letterSpacing: 0.8
        font.capitalization: Font.AllUppercase
        renderType: Text.NativeRendering
        antialiasing: true
        verticalAlignment: Text.AlignVCenter
    }
}
