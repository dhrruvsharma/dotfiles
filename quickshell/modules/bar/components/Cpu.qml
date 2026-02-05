import QtQuick
import qs.services as Services
import "../../../colors" as ColorsModule

Rectangle {
    radius: 13
    color: ColorsModule.Colors.surface_container
    implicitHeight: 28
    implicitWidth: cpu.implicitWidth + 16
    Text {
        id: cpu
        anchors.centerIn: parent
        text: "💻 " + Math.round(Services.System.cpu) + "%"
        color: ColorsModule.Colors.on_surface
        font.pixelSize: 17
    }
}