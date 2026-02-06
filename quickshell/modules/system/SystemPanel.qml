import QtQuick
import Quickshell
import qs.components
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: systemPanel
    property bool opened: false

    color: "transparent"
    focusable: true

    anchors.top: true
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    implicitWidth: opened ? 550 : 0
    implicitHeight: opened ? 180 : 0

    visible: true

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        opacity: systemPanel.opened ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

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
            SystemGraphs {
                id: system
                anchors.horizontalCenter: parent.horizontalCenter

                y: opened ? 0 : -implicitHeight - 30


                Behavior on y {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutCubic
                    }
                }

                opacity: opened ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuad
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
        target: "systemPanel"
        function toggle(): void {
            systemPanel.opened = !systemPanel.opened
        }
    }
}