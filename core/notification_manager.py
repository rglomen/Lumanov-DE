from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer

class NotificationManager(QObject):
    notifyChanged = Signal()

    def __init__(self):
        super().__init__()
        self._message = ""
        self._visible = False
        self._timer = QTimer()
        self._timer.setSingleShot(True)
        self._timer.timeout.connect(self.hide_notification)

    @Slot(str)
    def show(self, text, duration=3000):
        self._message = text
        self._visible = True
        self.notifyChanged.emit()
        self._timer.start(duration)

    def hide_notification(self):
        self._visible = False
        self.notifyChanged.emit()

    @Property(str, notify=notifyChanged)
    def message(self): return self._message

    @Property(bool, notify=notifyChanged)
    def visible(self): return self._visible
