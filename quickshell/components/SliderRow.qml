import QtQuick.Layouts
import Quickshell.Io
import QtQuick.Controls
import QtQuick
import Quickshell
import "../colors" as ColorsModule

RowLayout {
    required property string label
    required property string icon
    required property int value
    signal moved(int value)

    Layout.fillWidth: true
    spacing: 16

    Text {
        text: icon
        font.pixelSize: 18
        color: ColorsModule.Colors.primary
        Layout.alignment: Qt.AlignVCenter
    }

    Text {
        text: label
        Layout.preferredWidth: 90
        color: ColorsModule.Colors.on_surface
        font.pixelSize: 13
        font.weight: Font.Medium
        Layout.alignment: Qt.AlignVCenter
    }

    Slider {
        id: slider
        Layout.fillWidth: true
        from: 0
        to: 100
        value: 50
        onMoved: parent.moved(value)

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 6
            width: slider.availableWidth
            height: implicitHeight
            radius: 3
            color: ColorsModule.Colors.surface_container_highest

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                color: ColorsModule.Colors.primary
                radius: 3
            }
        }

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 20
            implicitHeight: 20
            radius: 10
            color: slider.pressed ? ColorsModule.Colors.primary_fixed : ColorsModule.Colors.primary
            border.color: ColorsModule.Colors.primary_container
            border.width: slider.hovered ? 2 : 0

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }

    Text {
        text: Math.round(slider.value) + "%"
        color: ColorsModule.Colors.on_surface_variant
        font.pixelSize: 12
        font.weight: Font.Medium
        Layout.preferredWidth: 40
        horizontalAlignment: Text.AlignRight
        Layout.alignment: Qt.AlignVCenter
    }
}