import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../colors" as ColorsModule
import qs.services as Services

Rectangle {
    id: root

    /* ---------- sizing ---------- */
    width: 200
    height: width
    radius: width / 2



    /* ---------- matugen colors ---------- */
    color: ColorsModule.Colors.surface_container
    border.color: ColorsModule.Colors.outline_variant
    border.width: 2

    /* ---------- clock face ---------- */
    Item {
        anchors.fill: parent
        anchors.margins: 20

        // Hour markers
        Repeater {
            model: 12
            Rectangle {
                width: index % 3 === 0 ? 3 : 2
                height: index % 3 === 0 ? 12 : 8
                color: ColorsModule.Colors.on_surface_variant
                opacity: index % 3 === 0 ? 0.8 : 0.5
                radius: width / 2

                x: parent.width / 2 - width / 2
                y: 0

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: parent.height / 2
                    angle: index * 30
                }
            }
        }

        // Hour hand
        Rectangle {
            id: hourHand
            width: 6
            height: parent.height * 0.3
            color: ColorsModule.Colors.primary
            radius: width / 2
            antialiasing: true

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: -8

            transform: Rotation {
                origin.x: hourHand.width / 2
                origin.y: hourHand.height + 8
                angle: (Services.Time.date.getHours() % 12 + Services.Time.date.getMinutes() / 60) * 30
            }
        }

        // Minute hand
        Rectangle {
            id: minuteHand
            width: 4
            height: parent.height * 0.4
            color: ColorsModule.Colors.primary
            radius: width / 2
            antialiasing: true

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: -8

            transform: Rotation {
                origin.x: minuteHand.width / 2
                origin.y: minuteHand.height + 8
                angle: Services.Time.date.getMinutes() * 6
            }
        }

        // Second hand
        Rectangle {
            id: secondHand
            width: 2
            height: parent.height * 0.45
            color: ColorsModule.Colors.tertiary
            radius: width / 2
            antialiasing: true

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: -8

            transform: Rotation {
                origin.x: secondHand.width / 2
                origin.y: secondHand.height + 8
                angle: Services.Time.date.getSeconds() * 6
            }
        }

        // Center dot
        Rectangle {
            width: 16
            height: 16
            radius: width / 2
            color: ColorsModule.Colors.primary
            anchors.centerIn: parent

            Rectangle {
                width: 8
                height: 8
                radius: width / 2
                color: ColorsModule.Colors.surface_container
                anchors.centerIn: parent
            }
        }
    }

    /* ---------- subtle material look ---------- */
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.color: ColorsModule.Colors.surface_tint
        border.width: 1
        opacity: 0.08
    }
}