import QtQuick.Layouts
import qs.components
import qs.services as Services

ColumnLayout {
    Layout.fillWidth: true
    Layout.leftMargin: 20
    Layout.rightMargin: 20
    Layout.topMargin: 8
    spacing: 14

    SliderRow {
        label: "Volume"
        icon: "󰕾"
        value: Services.System.volume
        onMoved: Services.System.setVolume(value)
    }

    SliderRow {
        label: "Brightness"
        icon: "󰃞"
        value: Services.System.brightness
        onMoved: Services.System.setBrightness(value)
    }
}