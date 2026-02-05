import QtQuick
import qs.services as Services
import "../../../colors" as ColorsModule

Rectangle {
    radius: 13
    color: ColorsModule.Colors.surface_container
    implicitHeight: 28
    implicitWidth: battery.implicitWidth + 16
    Text {
        id: battery
        anchors.centerIn: parent
        text: Services.Battery.charging
            ? "⚡ " + Services.Battery.percentage + "%"
            : "🔋 " + Services.Battery.percentage + "%"
        color: ColorsModule.Colors.on_surface
        font.pixelSize: 17
    }
}