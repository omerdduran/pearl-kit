#!/usr/bin/env bash
# Download the latest deployed WASM gallery bundle into docs/wasm/.
# Use this when you want to preview docs locally without installing
# Qt for WebAssembly + emsdk. For rebuilds from wasm/ sources, use
# scripts/build-wasm.sh instead.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/docs/wasm"
BASE="${PEARL_WASM_BASE:-https://omerdduran.github.io/pearl-kit/wasm}"

mkdir -p "$DEST"

files=(
    pearl_kit_gallery.html
    pearl_kit_gallery.js
    pearl_kit_gallery.wasm
    qtloader.js
    pearl_kit_gallery.svg
)

echo "Fetching prebuilt WASM gallery from $BASE"
for f in "${files[@]}"; do
    printf '  %-32s ' "$f"
    if curl -fsSL -o "$DEST/$f" "$BASE/$f"; then
        size=$(wc -c <"$DEST/$f" | tr -d ' ')
        printf 'ok (%s bytes)\n' "$size"
    else
        printf 'missing (skipping)\n'
    fi
done

echo
echo "Done. Now run: uv run mkdocs serve"
