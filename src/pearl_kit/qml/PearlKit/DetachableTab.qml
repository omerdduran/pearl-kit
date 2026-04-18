import QtQuick

Item {
    id: tab

    // ---- public API
    property string title: ""
    property string stackKey: ""
    property url iconSource: ""
    property bool permanent: false        // cannot detach; re-docks at index 0; no close/dock on floating
    property bool nonDetachable: false    // cannot detach; still closable via regular flow if consumer wires one

    // ---- private (DetachableTabView updates these)
    property bool isCurrent: false
    property bool isFloating: false

    // Discovery marker — DetachableTabView iterates children and filters on this.
    objectName: "detachableTab"

    // Fills whichever parent is active (host Item or FloatingWindow content area).
    anchors.fill: parent

    // Hide when not current unless floating (floating means a separate Window shows it).
    visible: isCurrent || isFloating
}
