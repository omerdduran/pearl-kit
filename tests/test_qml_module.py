import sys

from PySide6.QtCore import QCoreApplication
from PySide6.QtQml import QQmlApplicationEngine


def test_tokens_singleton_loads() -> None:
    import pearl_kit

    app = QCoreApplication.instance() or QCoreApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(
        b"import QtQuick\n"
        b"import PearlKit 1.0 as P\n"
        b"QtObject { property color c: P.Tokens.background }\n"
    )
    assert engine.rootObjects(), "PearlKit.Tokens failed to load"
    _ = app


def test_tokens_apply_colors_overrides_palette_and_propagates() -> None:
    """applyColors() swaps a palette table; the bound `primary` color
    re-evaluates while unrelated tokens (`background`) stay on defaults."""
    import pearl_kit

    app = QCoreApplication.instance() or QCoreApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(
        b"import QtQuick\n"
        b"import PearlKit 1.0 as P\n"
        b"QtObject {\n"
        b"    property string primaryDefault: P.Tokens.primary.toString()\n"
        b"    property string backgroundDefault: P.Tokens.background.toString()\n"
        b"    property string primaryAfter: ''\n"
        b"    property string backgroundAfter: ''\n"
        b"    Component.onCompleted: {\n"
        b"        P.Tokens.applyColors({ _primary: ['#FF0000','#FF0000','#FF0000'] });\n"
        b"        primaryAfter = P.Tokens.primary.toString();\n"
        b"        backgroundAfter = P.Tokens.background.toString();\n"
        b"    }\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots, "applyColors test QML failed to load"
    obj = roots[0]
    # Light mode primary default = brand.blue.600 = #2563EB
    assert obj.property("primaryDefault").lower() == "#2563eb"
    # Override propagated through _c(_primary) binding
    assert obj.property("primaryAfter").lower() == "#ff0000"
    # Unrelated token unchanged
    assert obj.property("backgroundDefault") == obj.property("backgroundAfter")
    _ = app


def test_tokens_apply_colors_noop_on_falsy_input() -> None:
    """applyColors(null|undefined|{}) must not throw or mutate state."""
    import pearl_kit

    app = QCoreApplication.instance() or QCoreApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(
        b"import QtQuick\n"
        b"import PearlKit 1.0 as P\n"
        b"QtObject {\n"
        b"    property string primaryAfter: ''\n"
        b"    Component.onCompleted: {\n"
        b"        P.Tokens.applyColors(null);\n"
        b"        P.Tokens.applyColors(undefined);\n"
        b"        P.Tokens.applyColors({});\n"
        b"        primaryAfter = P.Tokens.primary.toString();\n"
        b"    }\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots, "applyColors no-op test QML failed to load"
    assert roots[0].property("primaryAfter").lower() == "#2563eb"
    _ = app


def test_tokens_apply_theme_merges_subobjects_and_preserves_unspecified() -> None:
    """applyTheme() shallow-merges sub-objects; deep-merges font.size/weight;
    delegates `palette` to applyColors; populates anatomy/crosshair slots."""
    import pearl_kit

    app = QCoreApplication.instance() or QCoreApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(
        b"import QtQuick\n"
        b"import PearlKit 1.0 as P\n"
        b"QtObject {\n"
        b"    property int radiusMd: 0\n"
        b"    property int radiusSmKept: 0\n"
        b"    property int spaceX4: 0\n"
        b"    property int spaceX2Kept: 0\n"
        b"    property string fontUi: ''\n"
        b"    property string fontMonoKept: ''\n"
        b"    property int fontSizeSm: 0\n"
        b"    property int fontSizeMdKept: 0\n"
        b"    property int motionBase: 0\n"
        b"    property int motionFastKept: 0\n"
        b"    property string anatomyBone: ''\n"
        b"    property string crosshairAxial: ''\n"
        b"    property string primaryAfter: ''\n"
        b"    Component.onCompleted: {\n"
        b"        P.Tokens.applyTheme({\n"
        b"            palette: { _primary: ['#FF0000','#FF0000','#FF0000'] },\n"
        b"            radius:  { md: 12 },\n"
        b"            space:   { x4: 24 },\n"
        b"            font:    { ui: 'Plus Jakarta Sans', size: { sm: 13 } },\n"
        b"            motion:  { base: 200 },\n"
        b"            anatomy:   { bone: '#E8DCC8' },\n"
        b"            crosshair: { axial: '#0078FF' }\n"
        b"        });\n"
        b"        radiusMd        = P.Tokens.radius.md;\n"
        b"        radiusSmKept    = P.Tokens.radius.sm;\n"
        b"        spaceX4         = P.Tokens.space.x4;\n"
        b"        spaceX2Kept     = P.Tokens.space.x2;\n"
        b"        fontUi          = P.Tokens.font.ui;\n"
        b"        fontMonoKept    = P.Tokens.font.mono;\n"
        b"        fontSizeSm      = P.Tokens.font.size.sm;\n"
        b"        fontSizeMdKept  = P.Tokens.font.size.md;\n"
        b"        motionBase      = P.Tokens.motion.base;\n"
        b"        motionFastKept  = P.Tokens.motion.fast;\n"
        b"        anatomyBone     = P.Tokens.anatomy.bone;\n"
        b"        crosshairAxial  = P.Tokens.crosshair.axial;\n"
        b"        primaryAfter    = P.Tokens.primary.toString();\n"
        b"    }\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots, "applyTheme test QML failed to load"
    obj = roots[0]
    # Overrides applied
    assert obj.property("radiusMd") == 12
    assert obj.property("spaceX4") == 24
    assert obj.property("fontUi") == "Plus Jakarta Sans"
    assert obj.property("fontSizeSm") == 13
    assert obj.property("motionBase") == 200
    assert obj.property("anatomyBone") == "#E8DCC8"
    assert obj.property("crosshairAxial") == "#0078FF"
    # Palette delegation
    assert obj.property("primaryAfter").lower() == "#ff0000"
    # Shallow merge preserves unspecified sub-fields
    assert obj.property("radiusSmKept") == 4
    assert obj.property("spaceX2Kept") == 8
    assert obj.property("fontMonoKept") == "SF Mono"
    assert obj.property("motionFastKept") == 150
    # Deep merge preserves unspecified font.size entries
    assert obj.property("fontSizeMdKept") == 16
    _ = app


def test_tokens_apply_theme_noop_on_falsy_input() -> None:
    """applyTheme(null|undefined|{}) must not throw or mutate state."""
    import pearl_kit

    app = QCoreApplication.instance() or QCoreApplication(sys.argv)
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    engine.loadData(
        b"import QtQuick\n"
        b"import PearlKit 1.0 as P\n"
        b"QtObject {\n"
        b"    property int radiusMd: 0\n"
        b"    property string fontUi: ''\n"
        b"    Component.onCompleted: {\n"
        b"        P.Tokens.applyTheme(null);\n"
        b"        P.Tokens.applyTheme(undefined);\n"
        b"        P.Tokens.applyTheme({});\n"
        b"        radiusMd = P.Tokens.radius.md;\n"
        b"        fontUi   = P.Tokens.font.ui;\n"
        b"    }\n"
        b"}\n"
    )
    roots = engine.rootObjects()
    assert roots, "applyTheme no-op test QML failed to load"
    assert roots[0].property("radiusMd") == 6  # default
    assert roots[0].property("fontUi") == "SF Pro Display"  # default
    _ = app
