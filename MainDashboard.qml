import QtQuick
import QtQuick.Controls
import QtQuick.Effects

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 720
    title: "Lumanov Shell"
    visibility: "FullScreen"
    color: theme.bgColor

    // --- Background Layer ---
    Rectangle {
        id: bgRect
        anchors.fill: parent
        color: theme.bgColor
        Behavior on color { ColorAnimation { duration: 500 } }
    }

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "../assets/bg.png" 
        fillMode: Image.PreserveAspectCrop
        opacity: theme.glassEffect ? 0.6 : 0.3
        visible: status === Image.Ready
    }

    // --- Top Bar (macOS Style) ---
    Rectangle {
        id: topBar
        width: parent.width
        height: 35
        color: theme.panelColor
        opacity: theme.panelOpacity
        anchors.top: parent.top
        
        layer.enabled: theme.glassEffect
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 1.0
            blurMaxRadius: theme.blurRadius
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20

            Text {
                text: ""
                color: theme.accentColor
                font.pixelSize: 20
                visible: theme.glassEffect
            }

            Text {
                text: "LumanovOS"
                color: theme.textColor
                font.bold: true
                font.pixelSize: 14
            }
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15

            Text {
                text: Qt.formatDateTime(new Date(), "ddd d MMM HH:mm")
                color: theme.textColor
                font.pixelSize: 13
            }
        }
    }

    // --- Central Launcher (PS5 Style) ---
    ListView {
        id: appList
        anchors.top: topBar.bottom
        anchors.bottom: dock.top
        width: parent.width
        anchors.topMargin: 50
        anchors.bottomMargin: 50
        orientation: ListView.Horizontal
        spacing: 50
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: parent.width / 2 - 110
        preferredHighlightEnd: parent.width / 2 + 110
        clip: true

        model: lumanov.apps

        delegate: Item {
            width: 220
            height: 350

            Column {
                anchors.centerIn: parent
                spacing: 25

                Rectangle {
                    width: 170
                    height: 170
                    radius: theme.glassEffect ? 40 : 25
                    color: appList.currentIndex === index ? theme.panelColor : "#20000000"
                    border.color: theme.accentColor
                    border.width: appList.currentIndex === index ? 3 : 0
                    
                    scale: appList.currentIndex === index ? 1.2 : 1.0
                    Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
                    Behavior on color { ColorAnimation { duration: 300 } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.name[0].toUpperCase()
                        font.pixelSize: 80
                        color: theme.accentColor
                        visible: !appIcon.visible
                    }

                    Image {
                        id: appIcon
                        anchors.fill: parent
                        anchors.margins: 35
                        source: "image://icon/" + modelData.icon
                        visible: status === Image.Ready
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: appList.currentIndex = index
                        onClicked: lumanov.launchApp(modelData.exec)
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    color: theme.textColor
                    font.pixelSize: 22
                    font.bold: appList.currentIndex === index
                    opacity: appList.currentIndex === index ? 1.0 : 0.5
                }
            }
        }
    }

    // --- Bottom Dock (macOS Style) ---
    Rectangle {
        id: dock
        width: 600
        height: 70
        radius: 20
        color: theme.panelColor
        opacity: theme.panelOpacity
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter

        layer.enabled: theme.glassEffect
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 1.0
            blurMaxRadius: theme.blurRadius
        }

        Row {
            anchors.centerIn: parent
            spacing: 20

            // Theme Switcher Buttons
            Button {
                text: "Dark"
                onClicked: lumanov.switchTheme("default")
            }
            Button {
                text: "macOS"
                onClicked: lumanov.switchTheme("macos")
            }
            
            Rectangle { width: 2; height: 30; color: "#444" }

            Text {
                text: "Settings"
                color: theme.textColor
                MouseArea {
                    anchors.fill: parent
                    onClicked: settingsPanel.visible = !settingsPanel.visible
                }
            }
        }
    }

    // --- Overlay Settings Panel ---
    Rectangle {
        id: settingsPanel
        width: 400
        height: 500
        anchors.centerIn: parent
        radius: 25
        color: theme.panelColor
        visible: false
        border.color: theme.accentColor
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20

            Text {
                text: "LumanovOS Settings"
                font.pixelSize: 24
                font.bold: true
                color: theme.textColor
            }

            Rectangle { width: parent.width; height: 1; color: "#333" }

            Text { text: "Active Theme: " + theme.name; color: theme.textColor }

            Row {
                spacing: 10
                Button { text: "Lumanov Dark"; onClicked: lumanov.switchTheme("default") }
                Button { text: "Apple Glass"; onClicked: lumanov.switchTheme("macos") }
            }
            
            Button {
                text: "Close"
                onClicked: settingsPanel.visible = false
            }
        }
    }

    // --- Notification Overlay ---
    Rectangle {
        id: notifyRect
        width: 300
        height: 60
        radius: 15
        color: theme.panelColor
        opacity: notifications.visible ? theme.panelOpacity : 0
        anchors.top: topBar.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 300 } }

        layer.enabled: theme.glassEffect
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 1.0
            blurMaxRadius: theme.blurRadius
        }

        border.color: theme.accentColor
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: notifications.message
            color: theme.textColor
            font.pixelSize: 14
        }
    }
}
