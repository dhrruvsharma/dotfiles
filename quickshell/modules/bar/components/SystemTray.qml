import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import qs.Core
import qs.Widgets
import "../../../colors" as ColorsModule

RowLayout {
    id: root

    property var colors: ColorsModule.Colors
    property bool trayOpen: false

    visible: SystemTray.items.values.length > 0
    spacing: 4

    Rectangle {
        clip: true
        height: 26
        radius: height / 2

        color: colors.surface_container
        border.color: colors.outline_variant
        border.width: 1

        Layout.preferredWidth: trayOpen ? (trayInner.implicitWidth + 16) : 0
        Layout.rightMargin: trayOpen ? 4 : 0
        opacity: trayOpen ? 1 : 0

        RowLayout {
            id: trayInner
            anchors.centerIn: parent
            spacing: 8

            Tray {
                iconSize: 16
                colors: root.colors
            }
        }

        Behavior on Layout.preferredWidth {
            NumberAnimation {
                duration: Animations.medium
                easing.type: Animations.standardEasing
            }
        }

        Behavior on Layout.rightMargin {
            NumberAnimation {
                duration: Animations.medium
                easing.type: Animations.standardEasing
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: Animations.fast }
        }
    }

    Rectangle {
        id: toggleBtn

        Layout.preferredWidth: 26
        Layout.preferredHeight: 26
        radius: height / 2

        color: colors.background

        Icon {
            anchors.centerIn: parent
            icon: Icons.arrowLeft
            font.pixelSize: 14

            color: colors.on_surface

            rotation: trayOpen ? 180 : 0

            Behavior on rotation {
                NumberAnimation {
                    duration: Animations.medium
                    easing.type: Animations.enterEasing
                }
            }

            Behavior on color {
                ColorAnimation { duration: Animations.fast }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onClicked: trayOpen = !trayOpen

            onEntered: toggleBtn.border.color = colors.primary
            onExited: toggleBtn.border.color = colors.outline_variant
        }

        Behavior on color {
            ColorAnimation { duration: Animations.fast }
        }

        Behavior on border.color {
            ColorAnimation { duration: Animations.fast }
        }
    }
}
