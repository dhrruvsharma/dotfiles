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

    NetworkPanel { }
    ControlCenter { }
    NotificationToasts { }
    CalendarWindow { }
    ClockWindow { }
    MediaPanel { }
    CavaPanel { }
    TopBar { }

    PanelWindow {
        id: hoverTrigger
        anchors {
            left: true
            top: true
            bottom: true
        }
        implicitWidth: 1
        implicitHeight: 150
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "#40000000"

            TapHandler {
                onTapped: {
                    notesDrawer.opened = !notesDrawer.opened
                }
            }
        }
    }

    NotesDrawer {
        id: notesDrawer
    }

    OsdWindow { }

    SystemPanel { }
}