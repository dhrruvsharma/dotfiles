import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import Quickshell.Io
import "../../../colors" as ColorsModule

Item {
    id: root

    implicitHeight: 32
    implicitWidth: pill.implicitWidth

    property var media: Media
    visible: media.activePlayer !== null

    Rectangle {
        id: pill
        radius: height / 2
        height: 32
        color: ColorsModule.Colors.background

        implicitWidth: row.implicitWidth + 20

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: 8

            MouseArea {
                id: volume
                onClicked: toggleProc.running = true
                anchors.fill: parent
            }

            Text {
                text: media.artist
                    ? media.title + " — " + media.artist
                    : media.title

                color: ColorsModule.Colors.on_surface
                font.pixelSize: 17
                elide: Text.ElideRight
                maximumLineCount: 1
            }
        }
    }

    Process {
        id: toggleProc
        command: ["qs", "ipc", "call", "mediaPanel", "toggle"]
    }
}
