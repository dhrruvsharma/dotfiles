import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar.components

PanelWindow {
    id: topBar

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        left: 20
        right: 20
    }

    implicitHeight: 42
    exclusiveZone: implicitHeight
    color: "transparent"

    Item {
        anchors.fill: parent

        RowLayout {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            spacing: 8
            Workspaces {}
            Cpu {}
            Battery {}
            Clock {}
            Bluetooth {}
        }

        MediaPill {
            anchors.centerIn: parent
        }

        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            spacing: 10
            Network {}
            Volume {}
            Temp {}
            Memory {}
            SystemTray {}
        }
    }
}