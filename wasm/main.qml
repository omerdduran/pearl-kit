import QtQuick
import QtQuick.Controls
import QtQuick.Window
import PearlKit 1.0 as P

Window {
    id: root

    property string demoKey: _initialDemoKey

    // On Qt for WebAssembly Window.width/height are overridden by the
    // container's client rect once the canvas is measured — the literal
    // values below are just an initial hint. Keep them near typical
    // component-demo sizes so the first frame is not awkwardly large.
    width: 880
    height: 460
    visibility: Window.AutomaticVisibility
    visible: true
    title: "pearl-kit demo — " + (demoKey || "index")
    color: P.Tokens.background

    // DarkBlue reads well on both light and dark mkdocs themes; v2 will
    // sync this with the docs theme toggle via postMessage.
    Component.onCompleted: P.Tokens.mode = P.Tokens.DarkBlue

    // Resource path matches generate_qrc.py's layout — demos go under
    // qrc:/demos/<slug>.qml and main.qml lives at qrc:/main.qml.
    Loader {
        id: demoLoader
        anchors.fill: parent
        anchors.margins: 24
        asynchronous: false
        source: root.demoKey ? "qrc:/demos/" + root.demoKey + ".qml"
                             : "qrc:/demos/index.qml"
        onStatusChanged: {
            if (status === Loader.Error)
                source = "qrc:/demos/index.qml"
        }
    }

    // Toaster overlay is always mounted so any demo can fire toasts.
    P.ToasterHost { }
}
