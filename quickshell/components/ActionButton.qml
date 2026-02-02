import QtQuick
import QtQuick.Layouts
import "../colors" as ColorsModule
Rectangle {
        required property string icon
        required property string label
        signal clicked

        Layout.fillWidth: true
        Layout.preferredHeight: 56
        radius: 14
        color: ColorsModule.Colors.error_container
        border.width: 1
        border.color: Qt.rgba(ColorsModule.Colors.error.r, ColorsModule.Colors.error.g, ColorsModule.Colors.error.b, 0.3)

        RowLayout {
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: icon
                font.family: "Material Design Icons"
                font.pixelSize: 22
                color: ColorsModule.Colors.on_error_container
            }

            Text {
                text: label
                font.pixelSize: 14
                font.weight: Font.DemiBold
                color: ColorsModule.Colors.on_error_container
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: parent.clicked()

            onEntered: {
                parent.scale = 0.96
                parent.opacity = 0.9
            }
            onExited: {
                parent.scale = 1.0
                parent.opacity = 1.0
            }
        }

        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }