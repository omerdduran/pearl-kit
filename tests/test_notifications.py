import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def _ensure_app() -> QGuiApplication:
    app = QGuiApplication.instance()
    if not isinstance(app, QGuiApplication):
        app = QGuiApplication(sys.argv)
    return app


def test_notification_center_without_icon_path_has_no_tray() -> None:
    from pearl_kit import NotificationCenter

    _ensure_app()
    center = NotificationCenter(icon_path=None)
    assert center._tray is None  # pyright: ignore[reportPrivateUsage]


def test_notification_center_show_os_notification_no_op_without_tray() -> None:
    from pearl_kit import NotificationCenter

    _ensure_app()
    center = NotificationCenter(icon_path=None)
    # Must not raise even though tray is absent.
    center.showOsNotification("t", "b", False)
    center.showOsNotification("e", "b", True)


def test_notification_center_is_app_active_returns_bool() -> None:
    from pearl_kit import NotificationCenter

    _ensure_app()
    center = NotificationCenter(icon_path=None)
    # In offscreen mode the reported state is not guaranteed; we just care
    # that the property responds with a bool without crashing.
    assert isinstance(center.isAppActive, bool)


def test_notification_center_force_inactive_override() -> None:
    from pearl_kit import NotificationCenter

    _ensure_app()
    center = NotificationCenter(icon_path=None)
    center._force_inactive = True  # pyright: ignore[reportPrivateUsage]
    assert center.isAppActive is False
    center._force_inactive = False  # pyright: ignore[reportPrivateUsage]
    # Falling back to the Qt-reported state — may be active or inactive
    # depending on the QPA platform, but must be a bool.
    assert isinstance(center.isAppActive, bool)


def test_register_notifications_injects_context_property() -> None:
    import pearl_kit

    _ensure_app()
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    center = pearl_kit.register_notifications(engine, icon_path=None)

    assert center is engine.property("_pearl_notification_center")

    engine.loadData(
        b"""
import QtQuick
import PearlKit 1.0
Item {
    property bool bridgeSeen: typeof NotificationCenter !== "undefined" && NotificationCenter !== null
    property bool active: bridgeSeen ? NotificationCenter.isAppActive : false
}
"""
    )
    roots = engine.rootObjects()
    assert roots, "engine with NotificationCenter failed to load QML"
    assert roots[0].property("bridgeSeen") is True
    assert isinstance(roots[0].property("active"), bool)
