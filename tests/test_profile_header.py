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


def test_profile_header_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nProfileHeader { }\n")
    roots = engine.rootObjects()
    assert roots, "default ProfileHeader failed to load"
    assert roots[0].property("implicitHeight") == 96


def test_profile_header_payload() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"ProfileHeader {\n"
        b'  initials: "MK"\n'
        b'  name: "Dr. Mehmet Kaya"\n'
        b'  title: "Oral and Maxillofacial Surgeon"\n'
        b"  stats: [\n"
        b'    { "key": "LICENSE", "value": "TR-DDS-21487" },\n'
        b'    { "key": "SINCE",   "value": "MAR 2024" },\n'
        b'    { "key": "PLANS",   "value": "1,247" }\n'
        b"  ]\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("initials") == "MK"
    assert roots[0].property("name") == "Dr. Mehmet Kaya"
