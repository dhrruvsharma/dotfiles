import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services as Services
import "../../colors" as ColorsModule
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: win

    color: "transparent"

    anchors.top: true
    anchors.right: true

    implicitWidth: 340
    implicitHeight: 600

    Column {
        id: stack
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 16
        spacing: 8

        Repeater {
            model: Services.Notification.popups

            delegate: Rectangle {
                required property var modelData

                radius: 14
                width: 280
                height: content.implicitHeight + 16

                color: ColorsModule.Colors.surface_container_high
                border.color: ColorsModule.Colors.outline_variant
                border.width: 1

                opacity: 1

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 3
                    radius: 16
                    samples: 24
                    color: ColorsModule.Colors.shadow
                }

                Behavior on opacity {
                    NumberAnimation { duration: 120 }
                }

                ColumnLayout {
                    id: content
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Text {
                        text: modelData.summary
                        font.bold: true
                        color: ColorsModule.Colors.on_surface
                        wrapMode: Text.Wrap
                    }

                    Text {
                        visible: modelData.body.length > 0
                        text: modelData.body
                        color: ColorsModule.Colors.on_surface_variant
                        wrapMode: Text.Wrap
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.popup = false
                }
            }
        }
    }
}
