# pearl-kit WASM gallery builder
#
# Self-contained Linux image that ships Qt 6.8 WASM + emsdk 3.1.56, used by
# scripts/build-wasm-docker.sh so contributors on macOS/Windows (or anyone
# who doesn't want a local Qt install) can rebuild the gallery bundle
# without host-side toolchain wrangling.
#
# First image build downloads ~3 GB (Qt desktop + Qt WASM + emsdk) and takes
# ~8-12 min. Rebuilds after that hit the layer cache and finish in seconds.
# Build command: docker build -t pearl-kit-wasm:6.8.2 wasm
#
# Mount the repo at /workspace and the entrypoint handles everything:
#   docker run --rm -v $PWD:/workspace pearl-kit-wasm:6.8.2

# Force x86_64 even on Apple Silicon: emsdk 3.1.37 does not ship Linux arm64
# binaries (emscripten-core/emsdk#547). Docker Desktop runs the container
# under Rosetta 2 on M-series Macs — ~20 % build-time overhead, everything
# works transparently.
FROM --platform=linux/amd64 ubuntu:24.04

# Qt Company stopped shipping public WASM binaries after 6.6.3 (newer builds
# moved behind the Qt Account-gated online installer). 6.6.3 is therefore
# the last freely-downloadable WASM Qt — emsdk 3.1.37 is the version Qt 6.6
# documents. Do not bump either in isolation.
ENV DEBIAN_FRONTEND=noninteractive \
    QT_VERSION=6.6.3 \
    EMSDK_VERSION=3.1.37 \
    HOME=/tmp

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        ninja-build \
        python3 \
        python3-pip \
        python3-venv \
        # Qt 6.6 host-tool runtime deps: qmlimportscanner / moc / rcc dynamically
        # link against glib/fontconfig/freetype/dbus/xkbcommon even in headless
        # mode. Missing any of them surfaces as "cannot open shared object".
        libglib2.0-0t64 \
        libfontconfig1 \
        libfreetype6 \
        libdbus-1-3 \
        libxkbcommon0 \
        libxkbcommon-x11-0 \
        libxcb-cursor0 \
        libxcb-xinerama0 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-randr0 \
        libxcb-render-util0 \
        libxcb-shape0 \
        libxcb-sync1 \
        libxcb-util1 \
        libxcb-xkb1 \
        libgl1 \
        libegl1 \
    && rm -rf /var/lib/apt/lists/*

# aqtinstall lives in its own venv so it cannot collide with the system python.
RUN python3 -m venv /opt/aqt-venv \
    && /opt/aqt-venv/bin/pip install --no-cache-dir 'aqtinstall==3.3.*'

# Qt desktop (host, provides moc/rcc/qmltools that the WASM build needs) +
# Qt WASM single-threaded (the cross-compile target).
# `icu` archive is mandatory on Linux: Qt 6.6's host binaries (qmlimportscanner,
# moc, rcc) dynamically link libicui18n.so.56. Ubuntu ships ICU 74, so we must
# install Qt's bundled copy explicitly — aqt's default set includes it, but we
# use --archives below for install-size, so it has to be listed by name.
RUN /opt/aqt-venv/bin/aqt install-qt linux desktop "${QT_VERSION}" \
        --outputdir /opt/Qt \
        --archives qtbase qtdeclarative qtsvg qtimageformats qtshadertools icu \
    && /opt/aqt-venv/bin/aqt install-qt linux desktop "${QT_VERSION}" wasm_singlethread \
        --outputdir /opt/Qt \
        --archives qtbase qtdeclarative qtsvg qtimageformats \
    # aqtinstall ships qt-cmake without +x — restore it so the build script
    # can invoke the wrapper directly.
    && chmod +x /opt/Qt/${QT_VERSION}/gcc_64/bin/qt-cmake \
                /opt/Qt/${QT_VERSION}/wasm_singlethread/bin/qt-cmake

# emsdk 3.1.56 — Qt 6.8's supported Emscripten. Do not bump without also
# bumping the Qt version; Qt pins Emscripten tightly.
RUN git clone --depth 1 https://github.com/emscripten-core/emsdk /opt/emsdk \
    && /opt/emsdk/emsdk install "${EMSDK_VERSION}" \
    && /opt/emsdk/emsdk activate "${EMSDK_VERSION}"

ENV Qt6_DIR_WASM=/opt/Qt/6.6.3/wasm_singlethread \
    Qt6_HOST_PATH=/opt/Qt/6.6.3/gcc_64 \
    PATH=/opt/emsdk:/opt/emsdk/upstream/emscripten:/opt/Qt/6.6.3/gcc_64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    # Qt 6.6 Linux binaries were built against ICU 56 and bundle the matching
    # libs under gcc_64/lib; Ubuntu 24.04 ships ICU 74 so qmlimportscanner
    # and other host tools need to prefer Qt's own libraries at runtime.
    LD_LIBRARY_PATH=/opt/Qt/6.6.3/gcc_64/lib

WORKDIR /workspace

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
