// WindowLevelPresets — pill row for Bone / Soft tissue / Implant WL/WW presets.
//
// Thin composition around SegmentedControl with a fixed preset set matching
// DALI's `settings.presets_wl_ww` ("bone", "soft", "implant"). The control
// lights up the active preset in blue and emits `changed(key)` on selection.
// Consumers hand the key to `ImplantController` / `ImageViewer.set_preset()`
// or the equivalent in their app.

import QtQuick
import PearlKit 1.0

Item {
    id: control

    //: "bone" | "soft" | "implant"
    property string current: "bone"
    property var labels: ({
        bone: "Bone",
        soft: "Soft tissue",
        implant: "Implant"
    })

    signal changed(string key)

    implicitWidth: _seg.implicitWidth
    implicitHeight: _seg.implicitHeight

    SegmentedControl {
        id: _seg
        anchors.fill: parent
        variant: "pill"
        current: control.current
        options: [
            { key: "bone",    label: control.labels.bone },
            { key: "soft",    label: control.labels.soft },
            { key: "implant", label: control.labels.implant }
        ]
        onChanged: (key) => {
            control.current = key
            control.changed(key)
        }
    }
}
