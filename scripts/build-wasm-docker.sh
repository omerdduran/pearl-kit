#!/usr/bin/env bash
# Build the pearl-kit WASM gallery inside a Linux Docker container.
# Use this when you don't have Qt 6.8 WASM installed natively (e.g. macOS,
# where Qt stopped shipping prebuilt WASM after 6.6.3). Requires Docker —
# on macOS install via Docker Desktop and ensure the daemon is running.
#
# First invocation builds the base image (~8-12 min, ~3 GB download).
# Subsequent runs reuse the cached image and only rebuild your QML / wasm/
# sources (~4-6 min).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE="${PEARL_WASM_IMAGE:-pearl-kit-wasm:6.6.3}"

if ! command -v docker >/dev/null 2>&1; then
    echo "error: docker CLI not found; install Docker Desktop first" >&2
    exit 1
fi
if ! docker info >/dev/null 2>&1; then
    echo "error: docker daemon not reachable; start Docker Desktop" >&2
    exit 1
fi

# Build the image if missing. `docker image inspect` is a cheap existence check.
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "Building builder image $IMAGE (first-time download ~3 GB, ~10 min)"
    docker build -t "$IMAGE" "$ROOT/wasm"
fi

echo "Running build inside $IMAGE"
# Do not pass --platform to docker run: the image is a single-arch amd64
# build (FROM --platform=linux/amd64 in the Dockerfile), and Rosetta 2 on
# Apple Silicon handles execution transparently. Passing --platform here
# triggers a manifest-index lookup and a spurious registry pull.
docker run --rm \
    -v "$ROOT":/workspace \
    -e HOST_UID="$(id -u)" \
    -e HOST_GID="$(id -g)" \
    "$IMAGE"
