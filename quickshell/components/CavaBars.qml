import QtQuick
import QtQuick.Layouts
import qs.services as Services
import "../colors" as ColorsModule
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property int barCount: Services.Cava.barsCount
    property real spacing: 3
    property real corner: 2
    property bool enableShadow: true  // Add this property

    Component.onCompleted: Services.Cava.running = true

    implicitHeight: 42
    implicitWidth: 320

    Row {
        anchors.fill: parent
        spacing: root.spacing

        Repeater {
            model: Services.Cava.values

            Rectangle {
                width: Math.max(2, root.width / barCount - root.spacing)
                height: Math.max(2, modelData * root.height)

                radius: root.corner

                gradient: Gradient {
                    GradientStop { position: 0;   color: ColorsModule.Colors.primary_container }
                    GradientStop { position: 0.6; color: ColorsModule.Colors.primary }
                    GradientStop { position: 1;   color: ColorsModule.Colors.primary_fixed }
                }

                layer.enabled: root.enableShadow  // Use the property here
                layer.effect: DropShadow {
                    radius: 8
                    samples: 16
                    color: ColorsModule.Colors.primary
                    horizontalOffset: 0
                    verticalOffset: 0
                }

                anchors.verticalCenter: parent.verticalCenter

                Behavior on height {
                    NumberAnimation {
                        duration: 60
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }
}