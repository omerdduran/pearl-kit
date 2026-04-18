"""Opt-in QSystemTrayIcon bridge for pearl-kit's Toaster.

Usage:

    import pearl_kit
    engine = QQmlApplicationEngine()
    pearl_kit.register_qml(engine)
    pearl_kit.register_notifications(engine, icon_path="my-app-tray.png")

Once registered, ``Toaster.show({...})`` routes to an OS tray notification
instead of an in-app toast whenever the application is not focused.
"""

from __future__ import annotations

from typing import TYPE_CHECKING

from PySide6.QtCore import Property, QObject, Qt, Signal, Slot
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtWidgets import QSystemTrayIcon

if TYPE_CHECKING:
    from pathlib import Path

    from PySide6.QtQml import QQmlApplicationEngine, QQmlEngine


class NotificationCenter(QObject):
    """Bridges QSystemTrayIcon and focus-state tracking into QML.

    Exposes an ``isAppActive`` property (reactive via ``app_state_changed``
    signal) and a ``showOsNotification(title, body, is_error)`` slot.
    Toaster calls ``isAppActive`` to decide between in-app rendering and
    OS notification forwarding.
    """

    app_state_changed = Signal()

    def __init__(
        self,
        icon_path: Path | str | None = None,
        parent: QObject | None = None,
    ) -> None:
        super().__init__(parent)
        self._tray: QSystemTrayIcon | None = None
        self._force_inactive = False

        if icon_path is not None and QSystemTrayIcon.isSystemTrayAvailable():
            tray = QSystemTrayIcon(QIcon(str(icon_path)), self)
            tray.show()
            self._tray = tray

        app = QGuiApplication.instance()
        if isinstance(app, QGuiApplication):
            app.applicationStateChanged.connect(self._on_state_changed)

    def _on_state_changed(self, _: Qt.ApplicationState) -> None:
        self.app_state_changed.emit()

    @Property(bool, notify=app_state_changed)
    def isAppActive(self) -> bool:  # noqa: N802 — QML property name
        if self._force_inactive:
            return False
        app = QGuiApplication.instance()
        if not isinstance(app, QGuiApplication):
            return True
        return app.applicationState() == Qt.ApplicationState.ApplicationActive

    @Slot(str, str, bool)
    def showOsNotification(self, title: str, body: str, is_error: bool) -> None:  # noqa: N802
        if self._tray is None:
            return
        icon = (
            QSystemTrayIcon.MessageIcon.Critical
            if is_error
            else QSystemTrayIcon.MessageIcon.Information
        )
        self._tray.showMessage(title, body, icon, 5000)


def register_notifications(
    engine: QQmlEngine | QQmlApplicationEngine,
    icon_path: Path | str | None = None,
) -> NotificationCenter:
    """Register a ``NotificationCenter`` as a QML context property.

    ``engine`` must be a ``QQmlEngine`` or ``QQmlApplicationEngine``.
    ``icon_path`` is optional: when omitted, Toaster still gains focus-state
    awareness but OS notifications are no-ops (useful for apps that don't
    ship a tray icon but still want in-app toasts suppressed when focused).

    Returns the created ``NotificationCenter`` so consumers can keep a
    reference for testing or manual calls. The engine itself also keeps a
    reference via ``engine.setProperty`` to prevent garbage collection.
    """
    center = NotificationCenter(icon_path=icon_path)
    engine.setProperty("_pearl_notification_center", center)
    engine.rootContext().setContextProperty("NotificationCenter", center)
    return center
