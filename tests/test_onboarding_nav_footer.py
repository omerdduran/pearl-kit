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


def test_onboarding_nav_footer_default_loads() -> None:
    engine = _load(b"import QtQuick\nimport PearlKit 1.0\nOnboardingNavFooter { }\n")
    roots = engine.rootObjects()
    assert roots, "default OnboardingNavFooter failed to load"
    assert roots[0].property("currentStep") == 1
    assert roots[0].property("totalSteps") == 5
    assert roots[0].property("canSkip") is False
    assert roots[0].property("primaryEnabled") is True


def test_onboarding_nav_footer_skippable_step() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"OnboardingNavFooter {\n"
        b"  currentStep: 3\n"
        b"  totalSteps: 5\n"
        b"  canSkip: true\n"
        b'  primaryText: "Continue"\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("canSkip") is True
    assert roots[0].property("currentStep") == 3


def test_onboarding_nav_footer_final_step() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\n"
        b"OnboardingNavFooter {\n"
        b"  currentStep: 5\n"
        b"  totalSteps: 5\n"
        b'  secondaryText: "GO TO LIBRARY"\n'
        b'  primaryText: "Open sample case"\n'
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("secondaryText") == "GO TO LIBRARY"


def test_onboarding_nav_footer_disabled_back() -> None:
    engine = _load(
        b"import QtQuick\nimport PearlKit 1.0\nOnboardingNavFooter { backEnabled: false }\n"
    )
    roots = engine.rootObjects()
    assert roots
    assert roots[0].property("backEnabled") is False
