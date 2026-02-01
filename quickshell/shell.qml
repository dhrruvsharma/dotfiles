import QtQuick
import Quickshell
import qs.modules
import Quickshell.Io

ShellRoot {
    id: root

    WifiPanel {
        visible: false
        id: wifiPanel
    }

    IpcHandler {
        target: "wifiPanel"
        function changeVisible(): void {
            wifiPanel.visible = !wifiPanel.visible
        }
    }
}
