// Source: design_handoff_planning_workspace/src/report-tab.jsx:513-515, :538-540, :577-579
// Editorial section header: "I · ANATOMY & PLACEMENT" in mono uppercase.
// Essentially SectionLabel with a numeral prefix joined by " · ".
import QtQuick
import PearlKit 1.0

Text {
    id: control

    property string numeral: ""
    property string label: ""
    property string fontFamily: Tokens.font.mono

    text: control.numeral !== "" && control.label !== ""
        ? (control.numeral + " \u00B7 " + control.label)
        : (control.numeral || control.label)

    color: "#9CA3AF"
    font.family: control.fontFamily
    font.pixelSize: 10
    font.letterSpacing: 1.5
    font.capitalization: Font.AllUppercase
    font.weight: Font.Medium
    renderType: Text.NativeRendering
    antialiasing: true
}
