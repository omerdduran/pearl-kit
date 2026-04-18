import QtQuick
import PearlKit 1.0

Rectangle {
    id: control

    property string orientation: "horizontal"
    property bool decorative: true

    color: Tokens.border

    implicitWidth:  orientation === "vertical"   ? 1 : 0
    implicitHeight: orientation === "horizontal" ? 1 : 0

    Accessible.role: decorative ? Accessible.NoRole : Accessible.Separator
}
