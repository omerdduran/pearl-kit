import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def _load(qml: bytes) -> QQmlApplicationEngine:
    import pearl_kit

    _ = QGuiApplication.instance() or QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(qml)
    return engine


def test_select_default_loads() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSelect { model: ["One", "Two", "Three"] }\n',
    )
    roots = engine.rootObjects()
    assert roots, "default Select failed to load"
    obj = roots[0]
    assert obj.property("implicitHeight") == 36
    assert obj.property("count") == 3


def test_select_sm_size() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSelect { size: "sm"; model: ["a", "b"] }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("implicitHeight") == 32


def test_select_error_state() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSelect { error: true; model: ["x"] }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("error") is True


def test_select_disabled_state() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSelect { enabled: false; model: ["x"] }\n',
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("enabled") is False


def test_select_current_index_roundtrip() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSelect { model: ["alpha", "beta", "gamma"] }\n',
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    obj.setProperty("currentIndex", 2)
    assert obj.property("currentIndex") == 2
    assert obj.property("currentText") == "gamma"


def test_select_placeholder_when_unselected() -> None:
    engine = _load(
        b'import QtQuick\nimport PearlKit 1.0\nSelect { model: []; placeholderText: "Pick one" }\n',
    )
    roots = engine.rootObjects()
    assert roots
    obj = roots[0]
    assert obj.property("placeholderText") == "Pick one"


def test_select_structured_model_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport QtQml.Models\nimport PearlKit 1.0\n"
        b"Select {\n"
        b"  textRole: 'text'\n"
        b"  valueRole: 'value'\n"
        b"  model: ListModel {\n"
        b"    ListElement { text: 'Turkish'; value: 'tr' }\n"
        b"    ListElement { text: 'English'; value: 'en' }\n"
        b"  }\n"
        b"}\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("count") == 2


def test_select_header_separator_model_loads() -> None:
    engine = _load(
        b"import QtQuick\nimport QtQml.Models\nimport PearlKit 1.0\n"
        b"Select {\n"
        b"  textRole: 'text'\n"
        b"  model: ListModel {\n"
        b"    ListElement { type: 'header'; text: 'Vowels' }\n"
        b"    ListElement { type: 'item'; text: 'A' }\n"
        b"    ListElement { type: 'item'; text: 'E' }\n"
        b"    ListElement { type: 'separator'; text: '' }\n"
        b"    ListElement { type: 'header'; text: 'Consonants' }\n"
        b"    ListElement { type: 'item'; text: 'B' }\n"
        b"  }\n"
        b"}\n",
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("count") == 6
