import QtQuick
import Quickshell
import qs.modules.network
import qs.modules.control
import qs.modules.calendar
import qs.modules.media
import qs.modules.bar
import Quickshell.Io
import qs.services as Services

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

}
