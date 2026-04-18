cmake_minimum_required(VERSION 3.21)

project(pearl_kit_gallery LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt 6.5 floor captures MultiEffect (introduced 6.5) while staying compatible
# with the last publicly-shipped WASM Qt (6.6.3). Pearl-kit itself pins
# PySide6>=6.8 at runtime — the WASM gallery is a docs-only build artifact
# and doesn't have to match that version.
find_package(Qt6 6.5 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
    Svg
)
# PearlKit's QML files depend on QtQuick.Effects (MultiEffect in Toast/Menu).
# The plugin target Qt6::effectsplugin is declared in a Qml sub-config that
# find_package(Qt6) does not auto-load; include it explicitly. Also load the
# matching Qt6QuickEffectsPrivate C++ module which the plugin needs at link.
if(Qt6Qml_DIR AND EXISTS "${Qt6Qml_DIR}/QmlPlugins/Qt6effectspluginConfig.cmake")
    include("${Qt6Qml_DIR}/QmlPlugins/Qt6effectspluginConfig.cmake")
    message(STATUS "pearl-kit: loaded Qt6effectspluginConfig")
endif()
find_package(Qt6QuickEffectsPrivate QUIET)

qt_standard_project_setup(REQUIRES 6.5)

# Regenerate qml.qrc from the current pearl-kit QML sources every configure.
# Keeps the resource file in sync with src/pearl_kit/qml/PearlKit/ without
# manual upkeep when new components ship.
execute_process(
    COMMAND ${CMAKE_COMMAND} -E env
        python3 ${CMAKE_CURRENT_SOURCE_DIR}/generate_qrc.py
        --pearlkit-dir ${CMAKE_CURRENT_SOURCE_DIR}/../src/pearl_kit/qml/PearlKit
        --output ${CMAKE_CURRENT_SOURCE_DIR}/qml.qrc
    RESULT_VARIABLE _qrc_gen_result
)
if(NOT _qrc_gen_result EQUAL 0)
    message(FATAL_ERROR "generate_qrc.py failed (exit ${_qrc_gen_result})")
endif()

qt_add_executable(pearl_kit_gallery main.cpp qml.qrc)

target_link_libraries(pearl_kit_gallery PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Svg
)

# Force the static QtQuick.Effects plugin into the executable. qmlimportscanner
# does not trace imports inside qrc-embedded QML, and qt_import_plugins(INCLUDE)
# only works when the target was declared with qt_add_qml_module — our app is
# a plain qt_add_executable + qrc, so we bypass the macro and link directly.
if(TARGET Qt6::effectsplugin)
    target_link_libraries(pearl_kit_gallery PRIVATE Qt6::effectsplugin)
    message(STATUS "pearl-kit: linked Qt6::effectsplugin")
else()
    message(WARNING "pearl-kit: Qt6::effectsplugin target NOT FOUND — MultiEffect will fail at runtime")
endif()

# ---------------------------------------------------------------------------
# Emscripten / WASM specific: keep setDemoKey reachable from JS via ccall.
# ---------------------------------------------------------------------------
if(EMSCRIPTEN)
    target_link_options(pearl_kit_gallery PRIVATE
        "SHELL:-s EXPORTED_FUNCTIONS=['_main','_setDemoKey','_malloc']"
        "SHELL:-s EXPORTED_RUNTIME_METHODS=['ccall','cwrap','stringToUTF8','UTF8ToString']"
        "SHELL:-s INITIAL_MEMORY=128MB"
        "SHELL:-s ALLOW_MEMORY_GROWTH=1"
    )
endif()
