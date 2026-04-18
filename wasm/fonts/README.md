# Bundled fonts for the WASM gallery

The WASM runner substitutes `SF Pro Display` → `Inter` and `SF Mono` →
`JetBrains Mono` at runtime (see `wasm/main.cpp:registerBundledFonts()`).
Both TTFs are required for a local rebuild but are not committed — they
are fetched at build time to keep the repo small.

## Files expected here

- `Inter-Variable.ttf`
- `JetBrainsMono-Regular.ttf`

## One-line download

```bash
# from the repo root (jsdelivr is more reliable than github raw for large binaries)
curl -fsSL -o wasm/fonts/Inter-Variable.ttf \
  https://cdn.jsdelivr.net/gh/rsms/inter@v4.0/docs/font-files/InterVariable.ttf
curl -fsSL -o wasm/fonts/JetBrainsMono-Regular.ttf \
  https://cdn.jsdelivr.net/gh/JetBrains/JetBrainsMono@master/fonts/ttf/JetBrainsMono-Regular.ttf
```

Both fonts are Open Font License. Licenses live in their respective
upstream repos and do not need to be checked into pearl-kit.

In CI the same two curl commands run as part of the WASM build step in
`.github/workflows/docs.yml`. The `scripts/build-wasm.sh` helper also
fetches them automatically if they are missing locally.
