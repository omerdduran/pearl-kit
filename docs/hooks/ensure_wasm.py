"""Mkdocs hook: warn when the WASM gallery bundle is missing from docs/wasm/.

The docs pages embed live component demos compiled to WebAssembly via Qt for
WebAssembly. The bundle lives at docs/wasm/ but is never committed — it is
either fetched from the deployed site with ./scripts/fetch-wasm.sh or
rebuilt locally with ./scripts/build-wasm.sh.

When the bundle is absent the iframe embeds 404 quietly in the browser, so
the build itself must stay green. This hook only prints a hint so contributors
know how to populate the directory.
"""

from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from mkdocs.config.defaults import MkDocsConfig

REQUIRED = (
    "pearl_kit_gallery.html",
    "pearl_kit_gallery.wasm",
    "pearl_kit_gallery.js",
)


def on_pre_build(config: MkDocsConfig, **_: object) -> None:
    docs_dir: str = config.docs_dir
    wasm_dir = Path(docs_dir) / "wasm"
    missing = [name for name in REQUIRED if not (wasm_dir / name).is_file()]
    if not missing:
        return

    print(
        "\n[pearl-kit] WASM gallery bundle not found in docs/wasm/.\n"
        "  Fast path:  ./scripts/fetch-wasm.sh   (prebuilt, no Qt needed)\n"
        "  Rebuild:    ./scripts/build-wasm.sh   (needs Qt 6.8 WASM + emsdk)\n"
        f"  Missing:    {', '.join(missing)}\n"
        "  The docs will build, but live component iframes will 404 until you fetch or build.\n"
    )
