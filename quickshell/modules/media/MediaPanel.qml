import QtQuick
import Quickshell
import qs.components
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: mediaPanel
    property bool opened: false

    color: "transparent"
    focusable: true

    anchors.top: true
    margins.top: 16
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    implicitWidth: opened ? 420 : 0
    implicitHeight: opened ? 120 : 0

    visible: true

    FocusScope {

        anchors.fill: parent
        focus: mediaPanel.opened

        Keys.onEscapePressed: {
            mediaPanel.opened = false
        }

        MediaControl {
            id: panel
            anchors.horizontalCenter: parent.horizontalCenter

            y: opened ? 0 : -implicitHeight - 20

            opened: mediaPanel.opened

            Behavior on y {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            opacity: opened ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
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