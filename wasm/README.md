# pearl-kit WASM gallery

A Qt for WebAssembly build of the pearl-kit component gallery. Produces
`pearl_kit_gallery.{wasm,js,html}` that the docs site embeds in each
component page via `<iframe>`.

> **Local docs preview without this toolchain:** run `./scripts/fetch-wasm.sh`
> from the repo root to download the prebuilt bundle from the deployed docs,
> then `uv run mkdocs serve`. You only need the toolchain below when changing
> files inside `wasm/` itself.
>
> **On macOS?** Qt stopped shipping prebuilt WASM for macOS after Qt 6.6.3.
> Use the Docker path (`./scripts/build-wasm-docker.sh`) instead of installing
> Qt natively — see "Docker (recommended for macOS)" below.

## Docker (recommended for macOS)

```bash
# Needs Docker Desktop (start it before running).
./scripts/build-wasm-docker.sh
```

First run builds the `pearl-kit-wasm:6.6.3` image — Ubuntu 24.04 + Qt 6.6.3
WebAssembly + emsdk 3.1.37, ~2.5 GB download, 8-12 min. Subsequent invocations
reuse the image and just rerun the cmake build (4-6 min).

**Why 6.6.3?** Qt Company stopped publishing WASM binaries to the public
online repo after 6.6.3. Newer WASM Qt (6.7+) is only available through the
Qt Online Installer behind a Qt Account. Since this gallery only uses stable
QML primitives available since Qt 6.5 (MultiEffect and friends), staying on
6.6.3 keeps the build account-free and CI-friendly.

The container mounts the repo at `/workspace` and writes the final bundle to
`docs/wasm/` on the host. `mkdocs serve` picks it up immediately.

To force a fresh image (e.g. after bumping Qt or emsdk version):

```bash
docker rmi pearl-kit-wasm:6.6.3
./scripts/build-wasm-docker.sh
```

## One-time setup (native, non-macOS)

Install Qt 6.6.3 for WebAssembly (single-threaded) and the matching emsdk:

```bash
# aqtinstall can still reach Qt 6.6.x WASM from the public online repo
# (Qt 6.7+ WASM requires the Qt Online Installer + Qt Account).
pip install aqtinstall
aqt install-qt linux desktop 6.6.3 --outputdir ~/Qt \
    --archives qtbase qtdeclarative qtsvg qtimageformats qtshadertools
aqt install-qt linux desktop 6.6.3 wasm_singlethread --outputdir ~/Qt \
    --archives qtbase qtdeclarative qtsvg qtimageformats

# emsdk 3.1.37 pairs with Qt 6.6 — any other version is unsupported.
git clone https://github.com/emscripten-core/emsdk ~/emsdk
~/emsdk/emsdk install 3.1.37
~/emsdk/emsdk activate 3.1.37
source ~/emsdk/emsdk_env.sh
```

## Download font assets

The build expects `fonts/Inter-Variable.ttf` and
`fonts/JetBrainsMono-Regular.ttf`. They are not committed — see
[`fonts/README.md`](fonts/README.md) for the one-line download command.

## Build

```bash
export Qt6_DIR_WASM=~/Qt/6.6.3/wasm_singlethread
./scripts/build-wasm.sh      # from repo root
```

Or manually:

```bash
cmake -S wasm -B build-wasm -G Ninja \
  -DCMAKE_PREFIX_PATH="$Qt6_DIR_WASM"
cmake --build build-wasm
```

Output lands in `build-wasm/`. The script copies the bundle to `docs/wasm/`
so `mkdocs serve` can find it.

## Test in isolation

```bash
python -m http.server 8000 --directory build-wasm
open http://localhost:8000/pearl_kit_gallery.html?demo=button
```

Valid demo keys match the docs component page slugs:
`button`, `input`, `textarea`, `toggle`, `select`, `dialog`, `message-box`,
`checkbox`, `stepper`, `pearl-text`, `group-box`, `separator`, `card`,
`form-row`, `splitter`, `scroll-area`, `progress-bar`, `spinner`,
`statusbar`, `tooltip`, `toast`, `slider`, `stacked-view`, `tabbar`,
`nav-item`, `icon-strip`, `menu`, `avatar`, `detachable-tabs`, `badge`,
`code-block`.

Omitting `?demo=...` falls back to the index placeholder.

## Known limitations

- **Fonts**: `Tokens.qml` references SF Pro Display and SF Mono. The WASM
  runner rewrites those to Inter / JetBrains Mono via
  `QFont::insertSubstitution` in `main.cpp` — `Tokens.qml` itself is never
  modified. See `main.cpp:registerBundledFonts()`.
- **FloatingWindow / DetachableTab detach**: secondary `Window` instances
  misbehave inside an iframe (frameless hint no-ops, drag math is
  canvas-relative). The `detachable-tabs` demo disables the detach action
  with a muted hint and keeps the docked view functional.
- **CodeBlock copy button**: `TextEdit.copy()` needs async Permissions API
  and `-s ASYNCIFY` to reach the system clipboard. The button still animates
  success, but cross-tab paste is a no-op. Documented on `code-block.md`.
- **Single-threaded only**: GitHub Pages cannot send COOP/COEP headers, so
  `SharedArrayBuffer` / multi-threaded Qt WASM are out of scope. Acceptable
  because pearl-kit demos are visual, not compute-heavy.

## Adding a new component demo

1. Add the public component to `src/pearl_kit/qml/PearlKit/qmldir` as usual.
2. Drop a new file at `wasm/demos/<slug>.qml` that imports `PearlKit 1.0` and
   shows the component's variants / sizes / states. Use the existing demos
   under `wasm/demos/` as a template.
3. Add an iframe block to the matching `docs/components/<slug>.md`.
4. Rerun `./scripts/build-wasm.sh`. `generate_qrc.py` picks up both the new
   component source and the new demo automatically.
