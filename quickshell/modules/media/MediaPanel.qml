import QtQuick
import Quickshell
import qs.components
import Quickshell.Io
import Quickshell.Wayland

Rectangle {
    id: mediaPanel
    property bool opened: false

    color: "transparent"
    focus: true
    implicitWidth: 520
    implicitHeight: opened ? 320 : 0
    y: 0
    anchors.horizontalCenter: parent.horizontalCenter

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 260
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked: mediaPanel.opened = false
        }
    }

    FocusScope {
        anchors.fill: parent
        focus: mediaPanel.opened

        Keys.onEscapePressed: {
            mediaPanel.opened = false
        }

        Popout {
            anchors.fill: parent
            alignment: 0
            MediaControl {
                id: panel
                anchors.horizontalCenter: parent.horizontalCenter

                y: opened ? 0 : -implicitHeight - 30

                opened: mediaPanel.opened

                Behavior on y {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutCubic
                    }
                }

                scale: opened ? 1.0 : 0.95

                Behavior on scale {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "mediaPanel"
        function toggle(): void {
            mediaPanel.opened = !mediaPanel.opened
        }
    }
}