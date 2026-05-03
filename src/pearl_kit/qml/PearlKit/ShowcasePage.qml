import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

Item {
    id: control

    // ---- public API
    property string title: ""
    property string subtitle: ""
    property string gridPreset: "single-col"
    // gridPreset: "single-col" | "two-col" | "four-col" | "flow"
    default property alias tiles: _grid.data

    // Reserved for v2 — opt-in code snippet slot. Hidden in v1; accepting a value
    // does not render anything yet, but the API surface exists so v2 doesn't break
    // contracts in consuming pages.
    property string codeSnippet: ""

    // ---- chrome
    readonly property int _hPadding: Tokens.space.x6
    readonly property int _vPadding: Tokens.space.x6
    readonly property int _gridGap: Tokens.space.x5
    readonly property int _flowMinTile: 200

    // ---- preset resolver
    readonly property int _columns: {
        switch (control.gridPreset) {
            case "single-col": return 1
            case "two-col":    return 2
            case "four-col":   return 4
            case "flow": {
                const avail = Math.max(0, control.width - 2 * control._hPadding)
                return Math.max(1, Math.floor((avail + control._gridGap) / (control._flowMinTile + control._gridGap)))
            }
            default:
                console.warn("ShowcasePage: unknown gridPreset '" + control.gridPreset
                             + "', falling back to 'single-col'")
                return 1
        }
    }

    Flickable {
        id: _scroll
        anchors.fill: parent
        contentWidth: width
        contentHeight: _column.implicitHeight + 2 * control._vPadding
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: _column
            x: control._hPadding
            y: control._vPadding
            width: control.width - 2 * control._hPadding
            spacing: control._gridGap

            // ---- header
            Column {
                width: parent.width
                spacing: 4

                PearlText {
                    width: parent.width
                    visible: control.title !== ""
                    text: control.title
                    variant: "title"
                    elide: Text.ElideRight
                }

                PearlText {
                    width: parent.width
                    visible: control.subtitle !== ""
                    text: control.subtitle
                    variant: "muted"
                    wrapMode: Text.WordWrap
                }
            }

            // ---- grid container; tiles are routed here via the default-property alias above
            GridLayout {
                id: _grid
                width: parent.width
                columns: control._columns
                columnSpacing: control._gridGap
                rowSpacing: control._gridGap
            }
        }
    }
}
