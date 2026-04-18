#include <QFont>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QString>
#include <QUrl>

#ifdef __EMSCRIPTEN__
#  include <emscripten/emscripten.h>
#endif

namespace {

QQmlApplicationEngine *g_engine = nullptr;

void registerBundledFonts()
{
    const int interId = QFontDatabase::addApplicationFont(
        QStringLiteral(":/fonts/Inter-Variable.ttf"));
    const int monoId = QFontDatabase::addApplicationFont(
        QStringLiteral(":/fonts/JetBrainsMono-Regular.ttf"));

    const QString interFamily = interId >= 0
        ? QFontDatabase::applicationFontFamilies(interId).value(0, QStringLiteral("Inter"))
        : QStringLiteral("Inter");
    const QString monoFamily = monoId >= 0
        ? QFontDatabase::applicationFontFamilies(monoId).value(0, QStringLiteral("JetBrains Mono"))
        : QStringLiteral("JetBrains Mono");

    // Tokens.qml hardcodes SF Pro Display / SF Mono. On Linux CI and most
    // browsers those families are absent, so Qt's font resolver falls back to
    // DejaVu Sans. Route the Apple names to the bundled families instead —
    // leaves Tokens.qml untouched (package stays as shipped) while the WASM
    // runner sees the correct typography.
    QFont::insertSubstitution(QStringLiteral("SF Pro Display"), interFamily);
    QFont::insertSubstitution(QStringLiteral("SF Mono"), monoFamily);

    QFont appFont(interFamily);
    appFont.setPixelSize(14);
    QGuiApplication::setFont(appFont);
}

} // namespace

#ifdef __EMSCRIPTEN__
extern "C" EMSCRIPTEN_KEEPALIVE void setDemoKey(const char *key)
{
    if (!g_engine)
        return;
    const auto roots = g_engine->rootObjects();
    if (roots.isEmpty())
        return;
    roots.first()->setProperty("demoKey", QString::fromUtf8(key ? key : ""));
}
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName(QStringLiteral("pearl-kit gallery"));
    QQuickStyle::setStyle(QStringLiteral("Basic"));

    registerBundledFonts();

    QQmlApplicationEngine engine;
    g_engine = &engine;

    // Mirrors pearl_kit._register.register_qml(): make `import PearlKit 1.0`
    // resolve to the qmldir embedded in Qt resources.
    engine.addImportPath(QStringLiteral("qrc:/qml"));

    // Demo key arrives as argv[1] — on WebAssembly the HTML shell parses
    // ?demo=xyz from the iframe URL and hands it to qtLoad's `arguments`
    // config which Emscripten forwards into main() argv. Natively, the same
    // mechanism works for quick local testing: ./pearl_kit_gallery button
    QString initialKey;
    if (argc > 1)
        initialKey = QString::fromLocal8Bit(argv[1]);
    engine.rootContext()->setContextProperty(
        QStringLiteral("_initialDemoKey"), initialKey);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return 1;

    return app.exec();
}
