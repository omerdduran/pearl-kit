from pathlib import Path


def test_qml_import_path_exists() -> None:
    import pearl_kit

    path = pearl_kit.qml_import_path()
    assert isinstance(path, Path)
    assert path.is_dir()
    assert (path / "PearlKit" / "qmldir").exists()
    assert (path / "PearlKit" / "Tokens.qml").exists()
    assert (path / "PearlKit" / "internal" / "qmldir").exists()
