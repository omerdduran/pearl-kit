import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PearlKit 1.0 as P

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        P.PearlText {
            variant: "muted"
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: "The copy button animates success but the system clipboard bridge is a no-op in this WASM build (would require asyncify). Copy works natively on desktop."
        }

        P.CodeBlock {
            Layout.fillWidth: true
            Layout.preferredWidth: 520
            filename: "greet.ts"
            language: "typescript"
            code: "const greet = (name: string) => `Hello, ${name}!`\nconsole.log(greet(\"world\"))\n"
        }

        P.CodeBlock {
            Layout.fillWidth: true
            Layout.preferredWidth: 520
            filename: "install.sh"
            language: "bash"
            code: "$ pip install pearl-kit\n$ uv run python examples/gallery.py\n"
        }

        P.CodeBlock {
            Layout.fillWidth: true
            Layout.preferredWidth: 520
            code: "// no header, no copy button — read-only display\nreturn 42;\n"
            showCopyButton: false
        }
    }
}
