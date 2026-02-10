import QtQuick
import Quickshell
import qs.modules.network
import qs.modules.control
import qs.modules.calendar
import qs.modules.media
import qs.modules.bar
import qs.modules.system
import Quickshell.Io
import qs.services as Services
import qs.components
import qs.Osd

ShellRoot {
    id: root

    NotificationToasts {}
    CalendarWindow { }
    ClockWindow {}
    PanelWindow {
        id: rootPanel
        exclusionMode: ExclusionMode.Ignore
        implicitHeight: screen.height
        implicitWidth: screen.width
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"
        focusable: true

        Loader {
            id: mediaPanelLoader
            active: false
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: MediaPanel {
                id: mediaPanel
            }
            focus: true
        }

        SystemPanel {
            id: systemPanel
        }

        Loader {
            id: networkPanelLoader
            active: false
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            sourceComponent: NetworkPanel {
                id: networkPanel
            }
        }

        OsdWindow { }

        PanelWindow{
            implicitHeight: 42
            implicitWidth: 0
            anchors {
                top: true
            }
            color: "transparent"
            mask: rootPanel.mask
        }

        TopBar{
            id: topBar
        }
        NotesDrawer{
            id: notesDrawer
        }

        MouseArea {
            id: notesDrawerTrigger
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            width: 2
            z: 100

            onClicked: {
                notesDrawer.opened = !notesDrawer.opened
            }

            hoverEnabled: true

            Rectangle {
                anchors.fill: parent
                color: parent.containsMouse ? "#40FFFFFF" : "transparent"
                visible: parent.containsMouse
            }
        }

        Loader {
            active: false
            id: controlCenterLoader
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            sourceComponent: ControlCenter {
                id: controlCenter
            }
            focus: true
        }

        mask: Region{
            Region{
                item: mediaPanelLoader.active ? mediaPanelLoader : null
            }
            Region{
                item: systemPanel
            }
            Region{
                item: topBar
            }
            Region {
                item: networkPanelLoader.item ? networkPanelLoader.item : null
            }
            Region{
                item: notesDrawer.opened ? notesDrawer : null
            }
            Region{
                item: notesDrawerTrigger
            }
            Region{
                item: controlCenterLoader.active ? controlCenterLoader : null
            }
        }
    }

    Connections {
        target: mediaPanelLoader.item
        function onOpenedChanged() {
            if (!mediaPanelLoader.item.opened) {
                closeTimer.start()
            }
        }
    }

    Timer {
        id: closeTimer
        interval: 600
        onTriggered: mediaPanelLoader.active = false
    }

    IpcHandler {
        target: "mediaPanel"

        function toggle(): void {
            if (!mediaPanelLoader.active) {
                mediaPanelLoader.active = true
                mediaPanelLoader.item.opened = true
            } else {
                mediaPanelLoader.item.opened = !mediaPanelLoader.item.opened
            }
        }
    }

    IpcHandler {
        target: "networkPanel"

        function changeVisible(): void {
            if (!networkPanelLoader.active) {
                networkPanelLoader.active = true
                networkPanelLoader.item.opened = true
            } else {
                networkPanelLoader.item.opened = !networkPanelLoader.item.opened
            }
        }
    }

    IpcHandler {
        target: "controlCenter"
        function changeVisible(): void {
            if (!controlCenterLoader.active) {
                controlCenterLoader.active = true
                controlCenterLoader.item.opened = true
            } else {
                controlCenterLoader.item.opened = !controlCenterLoader.item.opened
            }
        }
    }

}