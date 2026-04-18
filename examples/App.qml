import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: root
    width: 1280
    height: 800
    visible: true
    title: "DALI \u00B7 Launch flow (pearl-kit)"
    color: "#FAFBFC"

    property string screen: "splash"

    Loader {
        id: splashLoader
        anchors.fill: parent
        active: root.screen === "splash"
        sourceComponent: Splash {
            onReady: root.screen = "library"
        }
    }

    Loader {
        id: libraryLoader
        anchors.fill: parent
        active: root.screen === "library"
        sourceComponent: CaseLibrary {
            onOpenStudy: function (index) { console.log("open study", index) }
            onExportStudy: function (index) { console.log("export study", index) }
            onImportCbct: console.log("import CBCT")
        }
    }
}
