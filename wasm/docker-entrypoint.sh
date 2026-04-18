#!/usr/bin/env bash
# Entrypoint for the pearl-kit WASM builder container.
# Expects the repo root mounted at /workspace.
# Optional env vars:
#   HOST_UID / HOST_GID  chown the final build output back to this user:group.
set -euo pipefail

cd /workspace

source /opt/emsdk/emsdk_env.sh >/dev/null

# Fetch font assets if they are not already present (jsdelivr is more reliable
# than raw.githubusercontent for large binary files).
mkdir -p wasm/fonts
if [[ ! -f wasm/fonts/Inter-Variable.ttf ]]; then
    echo "Fetching Inter-Variable.ttf"
    curl -fsSL -o wasm/fonts/Inter-Variable.ttf \
        https://cdn.jsdelivr.net/gh/rsms/inter@v4.0/docs/font-files/InterVariable.ttf
fi
if [[ ! -f wasm/fonts/JetBrainsMono-Regular.ttf ]]; then
    echo "Fetching JetBrainsMono-Regular.ttf"
    curl -fsSL -o wasm/fonts/JetBrainsMono-Regular.ttf \
        https://cdn.jsdelivr.net/gh/JetBrains/JetBrainsMono@master/fonts/ttf/JetBrainsMono-Regular.ttf
fi

# Drop any stale CMake cache — if a previous build ran natively on the host,
# the cached source / build dirs still reference /Users/... paths which
# CMake rejects with a hard error when seen from inside the container.
rm -rf build-wasm

# Use Qt's own qt-cmake wrapper, not bare emcmake. The wrapper sets up both
# the Emscripten toolchain AND Qt's find_package search paths. Bare emcmake
# alone restricts find_package to Emscripten's sysroot, which hides Qt.
echo "Configuring with Qt at ${Qt6_DIR_WASM}"
"${Qt6_DIR_WASM}/bin/qt-cmake" -S wasm -B build-wasm -G Ninja \
    -DQT_HOST_PATH="${Qt6_HOST_PATH}" \
    -DCMAKE_BUILD_TYPE=Release

echo "Building"
cmake --build build-wasm

echo "Copying artifacts into docs/wasm/"
mkdir -p docs/wasm
for f in pearl_kit_gallery.wasm pearl_kit_gallery.js qtloader.js; do
    if [[ -f "build-wasm/$f" ]]; then
        cp "build-wasm/$f" "docs/wasm/$f"
    fi
done
# Overwrite Qt's generic HTML shell with our minimal loader + URL-param wiring
# that feeds ?demo=xyz into setDemoKey() on onLoaded.
cp wasm/shell.html docs/wasm/pearl_kit_gallery.html

# Hand ownership back to the host user on Linux hosts (macOS / Windows
# Docker Desktop already maps this transparently).
if [[ -n "${HOST_UID:-}" && -n "${HOST_GID:-}" ]]; then
    chown -R "${HOST_UID}:${HOST_GID}" build-wasm docs/wasm wasm/fonts
fi

echo
echo "--- docs/wasm/ ---"
ls -lh docs/wasm/
echo
echo "Done. Run: uv run mkdocs serve"
