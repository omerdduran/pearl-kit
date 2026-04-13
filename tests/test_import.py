def test_version_exposed() -> None:
    import pearl_kit

    assert isinstance(pearl_kit.__version__, str)
    assert pearl_kit.__version__


def test_register_qml_is_callable() -> None:
    import pearl_kit

    assert callable(pearl_kit.register_qml)
