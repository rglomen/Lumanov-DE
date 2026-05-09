import sys
import os
import subprocess
import glob
from PySide6.QtGui import QGuiApplication, QIcon, QPixmap
from PySide6.QtQml import QQmlApplicationEngine, QQuickImageProvider
from PySide6.QtCore import QObject, Slot, Property, Qt, QSize
from core.theme_manager import ThemeManager
from core.notification_manager import NotificationManager

class IconProvider(QQuickImageProvider):
    def __init__(self):
        super().__init__(QQuickImageProvider.Pixmap)

    def requestPixmap(self, id, size, requestedSize):
        icon = QIcon.fromTheme(id)
        if icon.isNull():
            if os.path.exists(id):
                pixmap = QPixmap(id)
            else:
                return QPixmap()
        else:
            pixmap = icon.pixmap(QSize(128, 128))
        
        if requestedSize.width() > 0 and requestedSize.height() > 0:
            pixmap = pixmap.scaled(requestedSize, Qt.KeepAspectRatio, Qt.SmoothTransformation)
        return pixmap

class LumanovCore(QObject):
    def __init__(self, theme_manager, notify_manager):
        super().__init__()
        self._apps = []
        self._theme_manager = theme_manager
        self._notify_manager = notify_manager
        self.refresh_apps()

    def refresh_apps(self):
        self._apps = []
        app_paths = glob.glob("/usr/share/applications/*.desktop")
        for path in app_paths:
            app_info = self.parse_desktop_file(path)
            if app_info:
                self._apps.append(app_info)
        self._apps.sort(key=lambda x: x['name'].lower())

    def parse_desktop_file(self, path):
        info = {"name": "", "exec": "", "icon": "application-x-executable", "path": path}
        try:
            with open(path, 'r', errors='ignore') as f:
                is_desktop_entry = False
                for line in f:
                    line = line.strip()
                    if line == "[Desktop Entry]": is_desktop_entry = True
                    elif line.startswith("[") and is_desktop_entry: break
                    if "=" in line:
                        key, val = line.split("=", 1)
                        if key == "Name": info['name'] = val
                        elif key == "Exec": info['exec'] = val.split(' %')[0].replace('"', '')
                        elif key == "Icon": info['icon'] = val
                        elif key == "NoDisplay" and val == "true": return None
                if info['name'] and info['exec']: return info
        except: pass
        return None

    @Property(list)
    def apps(self): return self._apps

    @Slot(str)
    def launchApp(self, cmd):
        print(f"LumanovOS: Launching {cmd}...")
        try:
            subprocess.Popen(cmd, shell=True, start_new_session=True)
            self._notify_manager.show(f"Launched: {cmd}")
        except Exception as e:
            self._notify_manager.show(f"Error: {e}")

    @Slot(str)
    def switchTheme(self, theme_name):
        self._theme_manager.load_theme(theme_name)
        self._notify_manager.show(f"Theme: {self._theme_manager.name}")

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    base_dir = os.path.dirname(__file__)
    themes_dir = os.path.join(base_dir, "themes")

    theme_manager = ThemeManager(themes_dir)
    notify_manager = NotificationManager()
    lumanov_core = LumanovCore(theme_manager, notify_manager)
    icon_provider = IconProvider()
    
    engine.addImageProvider("icon", icon_provider)
    engine.rootContext().setContextProperty("lumanov", lumanov_core)
    engine.rootContext().setContextProperty("theme", theme_manager)
    engine.rootContext().setContextProperty("notifications", notify_manager)

    engine.load(os.path.join(base_dir, "ui", "MainDashboard.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())

if __name__ == "__main__":
    main()
