import QtQuick
import Quickshell
import qs.modules.network
import qs.modules.control
import Quickshell.Io
import qs.services as Services

ShellRoot {
    id: root

    NetworkPanel { }

    ControlCenter { }

    NotificationToasts { }

}
