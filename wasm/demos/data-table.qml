import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    P.DataTable {
        anchors.fill: parent
        anchors.margins: 8

        columns: [
            { key: "id",       label: "ID",       width: 70 },
            { key: "position", label: "POSITION", width: 140 },
            { key: "depth",    label: "DEPTH" },
            { key: "clearance", label: "CLEARANCE" },
            { key: "status",   label: "STATUS",   width: 80 }
        ]
        rows: [
            { id: "I1", position: "Upper left 14", depth: "12.0 mm", clearance: "4.1 mm", status: "OK",   statusColor: "#10B981" },
            { id: "I2", position: "Upper left 15", depth: "10.0 mm", clearance: "3.8 mm", status: "WARN", statusColor: "#F59E0B" },
            { id: "I3", position: "Upper left 17", depth: "12.0 mm", clearance: "2.1 mm", status: "WARN", statusColor: "#F59E0B" },
            { id: "I4", position: "Upper left 18", depth: "10.0 mm", clearance: "5.2 mm", status: "OK",   statusColor: "#10B981" }
        ]
    }
}
