import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

SAMPLE = "const x = 1\nconsole.log(x)\n"


def _load(qml: bytes) -> QQmlApplicationEngine:
    import pearl_kit

    _ = QGuiApplication.instance() or QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(qml)
    return engine


def test_code_block_loads_empty() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nCodeBlock {}\n")
    roots = engine.rootObjects()
    assert roots, "empty CodeBlock failed to load"
    cb = roots[0]
    assert cb.property("implicitWidth") > 0
    assert cb.property("implicitHeight") > 0


def test_code_block_code_roundtrip() -> None:
    qml = (
        b"import QtQuick\nimport PearlKit 1.0\n"
        + f'CodeBlock {{ code: "{SAMPLE.replace(chr(10), chr(92) + "n")}" }}\n'.encode()
    )
    engine = _load(qml)
    roots = engine.rootObjects()
    assert roots
    cb = roots[0]
    assert cb.property("code") == SAMPLE


def test_code_block_filename_roundtrip() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b'CodeBlock { filename: "example.ts"; language: "typescript" }\n'
    )
    roots = engine.rootObjects()
    assert roots
    cb = roots[0]
    assert cb.property("filename") == "example.ts"
    assert cb.property("language") == "typescript"


def test_code_block_defaults() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nCodeBlock {}\n")
    roots = engine.rootObjects()
    assert roots
    cb = roots[0]
    assert cb.property("showCopyButton") is True
    assert cb.property("copyTimeout") == 2000
    assert cb.property("copied") is False
    assert cb.property("maxBodyHeight") == 360


def test_code_block_header_visible_when_no_filename_but_copy_shown() -> None:
    engine = _load(b'import QtQuick\nimport PearlKit 1.0\nCodeBlock { code: "x" }\n')
    roots = engine.rootObjects()
    assert roots, "CodeBlock with default copy button failed to load"


def test_code_block_no_header_when_no_filename_and_no_copy() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nCodeBlock { code: "x"; showCopyButton: false }\n'
    )
    roots = engine.rootObjects()
    assert roots
    cb = roots[0]
    assert cb.property("showCopyButton") is False


def test_code_block_disabled_state() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nCodeBlock { code: "x"; enabled: false }\n'
    )
    roots = engine.rootObjects()
    assert roots
    cb = roots[0]
    assert cb.property("enabled") is False


def test_code_block_copy_timeout_custom() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nCodeBlock { copyTimeout: 500 }\n")
    roots = engine.rootObjects()
    assert roots
    cb = roots[0]
    assert cb.property("copyTimeout") == 500
