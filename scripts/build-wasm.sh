#!/usr/bin/env bash
# Build the WASM gallery bundle from wasm/ sources, copy into docs/wasm/.
# Requires Qt 6.6.3 wasm_singlethread and emsdk 3.1.37 on the system.
# (Qt stopped shipping newer WASM builds through the public online repo —
# Qt 6.7+ WASM is behind the Qt Account-gated installer. See wasm/README.md.)
# Set Qt6_DIR_WASM to the Qt install prefix, e.g.
#   export Qt6_DIR_WASM=~/Qt/6.6.3/wasm_singlethread
# Activate emsdk before running:
#   source ~/emsdk/emsdk_env.sh
# On macOS (no public mac WASM build exists), use build-wasm-docker.sh instead.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build-wasm"
DEST="$ROOT/docs/wasm"

if [[ -z "${Qt6_DIR_WASM:-}" ]]; then
    echo "error: Qt6_DIR_WASM is not set" >&2
    echo "       export Qt6_DIR_WASM=/path/to/Qt/6.8.x/wasm_singlethread" >&2
    exit 1
fi
if ! command -v emcmake >/dev/null 2>&1; then
    echo "error: emcmake not found; activate emsdk first" >&2
    echo "       source /path/to/emsdk/emsdk_env.sh" >&2
    exit 1
fi

# Fetch Inter + JetBrains Mono on first run so the bundled font substitution
# actually finds real TTFs. Idempotent — curl -f skips if already present.
fonts_dir="$ROOT/wasm/fonts"
mkdir -p "$fonts_dir"
if [[ ! -f "$fonts_dir/Inter-Variable.ttf" ]]; then
    echo "Fetching Inter-Variable.ttf"
    curl -fsSL -o "$fonts_dir/Inter-Variable.ttf" \
        https://cdn.jsdelivr.net/gh/rsms/inter@v4.0/docs/font-files/InterVariable.ttf
fi
if [[ ! -f "$fonts_dir/JetBrainsMono-Regular.ttf" ]]; then
    echo "Fetching JetBrainsMono-Regular.ttf"
    curl -fsSL -o "$fonts_dir/JetBrainsMono-Regular.ttf" \
        https://cdn.jsdelivr.net/gh/JetBrains/JetBrainsMono@master/fonts/ttf/JetBrainsMono-Regular.ttf
fi

echo "Configuring with Qt at $Qt6_DIR_WASM"
# aqtinstall ships qt-cmake without +x; restore it. (Silent no-op if already
# executable.)
chmod +x "${Qt6_DIR_WASM}/bin/qt-cmake" 2>/dev/null || true
# Use Qt's qt-cmake wrapper so find_package(Qt6) is not hidden by the
# Emscripten toolchain's find_root restriction.
"${Qt6_DIR_WASM}/bin/qt-cmake" -S "$ROOT/wasm" -B "$BUILD" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release

echo "Building"
cmake --build "$BUILD"

echo "Copying artifacts into $DEST"
mkdir -p "$DEST"
for f in pearl_kit_gallery.wasm pearl_kit_gallery.js qtloader.js; do
    if [[ -f "$BUILD/$f" ]]; then
        cp "$BUILD/$f" "$DEST/$f"
    fi
done
cp "$ROOT/wasm/shell.html" "$DEST/pearl_kit_gallery.html"

echo
echo "Build complete. Run: uv run mkdocs serve"
