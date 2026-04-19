#!/usr/bin/env python3
"""Regenerate wasm/qml.qrc from the current pearl-kit QML sources.

Walks src/pearl_kit/qml/PearlKit/ and emits a Qt resource file bundling:
  - every PearlKit public + internal QML file, under prefix /qml/PearlKit/
  - the qmldir files so `import PearlKit 1.0` resolves via addImportPath("qrc:/qml")
  - the per-component demo files under wasm/demos/, under prefix /demos/
  - bundled fonts under wasm/fonts/, under prefix /fonts/
"""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path
from xml.sax.saxutils import escape


def _relpath(target: Path, start: str) -> str:
    return os.path.relpath(str(target.resolve()), start)


def _find_files(root: Path, extensions: set[str]) -> list[Path]:
    return sorted(p for p in root.rglob("*") if p.is_file() and p.suffix in extensions)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pearlkit-dir", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()

    wasm_dir = Path(__file__).resolve().parent
    demos_dir = wasm_dir / "demos"
    fonts_dir = wasm_dir / "fonts"
    main_qml = wasm_dir / "main.qml"
    pearlkit_dir: Path = args.pearlkit_dir.resolve()
    output: Path = args.output.resolve()
    base = str(output.parent)

    if not pearlkit_dir.is_dir():
        print(f"generate_qrc: pearlkit dir not found: {pearlkit_dir}", file=sys.stderr)
        return 1

    pearlkit_files: list[tuple[str, Path]] = []
    for path in _find_files(pearlkit_dir, {".qml"}):
        alias = "PearlKit/" + path.relative_to(pearlkit_dir).as_posix()
        pearlkit_files.append((alias, path))

    qmldir_top = pearlkit_dir / "qmldir"
    if qmldir_top.is_file():
        pearlkit_files.append(("PearlKit/qmldir", qmldir_top))
    qmldir_int = pearlkit_dir / "internal" / "qmldir"
    if qmldir_int.is_file():
        pearlkit_files.append(("PearlKit/internal/qmldir", qmldir_int))

    demo_files = _find_files(demos_dir, {".qml"}) if demos_dir.is_dir() else []
    font_files = _find_files(fonts_dir, {".ttf", ".otf"}) if fonts_dir.is_dir() else []

    lines: list[str] = ["<!DOCTYPE RCC>", '<RCC version="1.0">']

    lines.append('  <qresource prefix="/">')
    lines.append(f'    <file alias="main.qml">{escape(_relpath(main_qml, base))}</file>')
    lines.append("  </qresource>")

    lines.append('  <qresource prefix="/qml">')
    for alias, path in pearlkit_files:
        lines.append(f'    <file alias="{escape(alias)}">{escape(_relpath(path, base))}</file>')
    lines.append("  </qresource>")

    if demo_files:
        lines.append('  <qresource prefix="/demos">')
        for path in demo_files:
            alias = path.stem
            lines.append(
                f'    <file alias="{escape(alias)}.qml">{escape(_relpath(path, base))}</file>'
            )
        lines.append("  </qresource>")

    if font_files:
        lines.append('  <qresource prefix="/fonts">')
        for path in font_files:
            lines.append(
                f'    <file alias="{escape(path.name)}">{escape(_relpath(path, base))}</file>'
            )
        lines.append("  </qresource>")

    lines.append("</RCC>")
    lines.append("")

    output.write_text("\n".join(lines), encoding="utf-8")
    print(
        f"generate_qrc: wrote {output} "
        f"(pearlkit={len(pearlkit_files)} demos={len(demo_files)} fonts={len(font_files)})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
