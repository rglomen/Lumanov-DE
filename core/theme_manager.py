import json
import os
from PySide6.QtCore import QObject, Property, Signal

class ThemeManager(QObject):
    themeChanged = Signal()

    def __init__(self, themes_dir):
        super().__init__()
        self.themes_dir = themes_dir
        self.current_theme_name = "default"
        self.theme_data = {}
        self.load_theme("default")

    def load_theme(self, name):
        path = os.path.join(self.themes_dir, f"{name}.json")
        if not os.path.exists(path):
            # Fallback to default
            self.theme_data = {
                "name": "Default Dark",
                "bg_color": "#0f1218",
                "accent_color": "#00aaff",
                "panel_color": "#1a1f26",
                "panel_opacity": 0.8,
                "blur_radius": 0,
                "text_color": "#ffffff",
                "glass_effect": False
            }
        else:
            with open(path, 'r') as f:
                self.theme_data = json.load(f)
        
        self.current_theme_name = name
        self.themeChanged.emit()

    @Property(str, notify=themeChanged)
    def name(self): return self.theme_data.get("name", "Unknown")

    @Property(str, notify=themeChanged)
    def bgColor(self): return self.theme_data.get("bg_color", "#000000")

    @Property(str, notify=themeChanged)
    def accentColor(self): return self.theme_data.get("accent_color", "#00aaff")

    @Property(str, notify=themeChanged)
    def panelColor(self): return self.theme_data.get("panel_color", "#1a1f26")

    @Property(float, notify=themeChanged)
    def panelOpacity(self): return self.theme_data.get("panel_opacity", 0.8)

    @Property(int, notify=themeChanged)
    def blurRadius(self): return self.theme_data.get("blur_radius", 0)

    @Property(str, notify=themeChanged)
    def textColor(self): return self.theme_data.get("text_color", "#ffffff")

    @Property(bool, notify=themeChanged)
    def glassEffect(self): return self.theme_data.get("glass_effect", False)
