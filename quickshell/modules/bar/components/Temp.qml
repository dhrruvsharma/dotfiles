import QtQuick
import qs.services as Services
import "../../../colors" as ColorsModule

Rectangle {
    color: ColorsModule.Colors.surface_container
    implicitHeight: 28
    implicitWidth: temp.implicitWidth + 16
    radius: 13
    Text {
        id: temp
        anchors.centerIn: parent
        text: Services.System.temp > 75
            ? "🔥 " + Services.System.temp + "°C"
            : "🌡️ " + Services.System.temp + "°C"
        color: ColorsModule.Colors.on_surface
        font.pixelSize: 17
    }
}
