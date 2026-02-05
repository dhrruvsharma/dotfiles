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

    RowLayout {
        anchors.fill: parent
        spacing: 8

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 8
            Workspaces {}
            Cpu {}
            Battery {}
            Clock { }
        }

        MediaPill {
            Layout.alignment: Qt.AlignHCenter
            anchors.centerIn: parent
        }

        Item { Layout.fillWidth: true }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 10
            Network {}
            Volume {}
            Temp {}
            Memory {}
            SystemTray {}
        }
    }
}
